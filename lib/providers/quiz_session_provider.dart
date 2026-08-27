import 'package:flutter/foundation.dart';

import '../data/models/quiz_question.dart';
import '../data/repositories/exam_session_repository.dart';
import '../data/repositories/review_repository.dart';

enum QuizMode { daily, review }

/// 1回の演習セッション (Question → Feedback → ... → Result) の状態を管理
class QuizSessionProvider extends ChangeNotifier {
  final ExamSessionRepository examRepo;
  final ReviewRepository reviewRepo;

  QuizSessionProvider(this.examRepo, this.reviewRepo);

  QuizMode mode = QuizMode.daily;
  String? sessionId; // daily モードのときのみ有効
  int day = 1;
  int attempt = 1;
  List<QuizQuestion> questions = [];
  int currentIndex = 0; // 0-based
  final List<int?> chosenAnswers = [];
  int correctCount = 0;
  bool isLoading = false;

  int get totalQuestions => questions.length;
  int get questionNumber => currentIndex + 1; // 1-based (UI表示用)
  QuizQuestion get currentQuestion => questions[currentIndex];
  bool get isLastQuestion => currentIndex >= questions.length - 1;

  Future<void> startDaily(String examSessionId) async {
    isLoading = true;
    notifyListeners();

    mode = QuizMode.daily;
    sessionId = examSessionId;
    final session = await examRepo.getSession(examSessionId);
    if (session == null) {
      isLoading = false;
      notifyListeners();
      return;
    }
    day = session.day == 0 ? 1 : session.day;
    await examRepo.startAttempt(examSessionId);
    final refreshed = await examRepo.getSession(examSessionId);
    attempt = refreshed?.attempt ?? 1;

    questions = await examRepo.getQuestionsForCurrentDay(refreshed ?? session);
    _resetProgress();

    isLoading = false;
    notifyListeners();
  }

  Future<void> startReview({
    required bool purchased,
    required int dailyCount,
  }) async {
    isLoading = true;
    notifyListeners();

    mode = QuizMode.review;
    sessionId = null;
    day = 0;
    attempt = 1;
    questions = await reviewRepo.buildReviewSet(
      purchased: purchased,
      dailyCount: dailyCount,
    );
    _resetProgress();

    isLoading = false;
    notifyListeners();
  }

  void _resetProgress() {
    currentIndex = 0;
    chosenAnswers
      ..clear()
      ..addAll(List.filled(questions.length, null));
    correctCount = 0;
  }

  /// 選択肢を選んだ時に呼ぶ。正誤判定・ログ記録・進捗更新を行う。
  Future<bool> answer(int choiceIndex) async {
    final q = currentQuestion;
    final correct = choiceIndex == q.correctIndex;
    chosenAnswers[currentIndex] = choiceIndex;
    if (correct) correctCount++;

    if (mode == QuizMode.daily && sessionId != null) {
      await examRepo.recordAnswer(
        sessionId: sessionId!,
        questionId: q.id,
        day: day,
        attempt: attempt,
        chosen: choiceIndex,
        correct: correct,
      );
    }
    notifyListeners();
    return correct;
  }

  void nextQuestion() {
    if (!isLastQuestion) {
      currentIndex++;
      notifyListeners();
    }
  }

  /// 完走時に呼ぶ。score(0-100) と 花丸フラグを返す。
  Future<({int score, bool hanamaru})> completeSession() async {
    if (mode == QuizMode.daily && sessionId != null) {
      final result = await examRepo.completeDay(
        sessionId: sessionId!,
        day: day,
        attempt: attempt,
        correctCount: correctCount,
        totalQuestions: questions.length,
      );
      return result;
    } else {
      final score = questions.isEmpty
          ? 0
          : ((correctCount / questions.length) * 100).round();
      return (
        score: score,
        hanamaru: correctCount == questions.length && questions.isNotEmpty,
      );
    }
  }

  /// 満点なら次のDayへ進める (daily モードのみ)
  Future<void> maybeAdvanceDay({required bool hanamaru}) async {
    if (mode == QuizMode.daily && sessionId != null && hanamaru) {
      await examRepo.advanceToNextDay(sessionId!);
    }
  }

  /// おかわり機能 (有料版限定): 満点でなくても次のDayへ前倒しで進める。
  /// 呼び出し側 (UI) で `appState.purchased == true` を確認してから呼ぶこと。
  Future<void> advanceDayEarly() async {
    if (mode == QuizMode.daily && sessionId != null) {
      await examRepo.advanceToNextDay(sessionId!);
    }
  }
}
