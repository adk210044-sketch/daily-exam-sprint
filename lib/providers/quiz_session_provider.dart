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

  /// true の場合、これは「おかわり(過去の回を選んで解き直す)」セッション。
  /// 現在の進捗Day (session.day) には影響を与えない。
  bool isReplay = false;
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
    isReplay = false;
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

  /// おかわり(過去の回を選んで解き直す)専用セッション開始。
  /// [replayDay] は 1-5 のいずれか (Day6,7は復習日のため対象外)。
  /// 進捗 (session.day / attempt カウント) には一切影響を与えない、
  /// 練習用の読み取り専用プレイセッション。
  Future<void> startReplay({
    required String examSessionId,
    required int replayDay,
  }) async {
    isLoading = true;
    notifyListeners();

    mode = QuizMode.daily;
    isReplay = true;
    sessionId = examSessionId;
    day = replayDay;
    attempt = 1;

    final session = await examRepo.getSession(examSessionId);
    if (session == null) {
      isLoading = false;
      notifyListeners();
      return;
    }
    questions = await examRepo.getQuestionsForDay(session, replayDay);
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

  /// 苦手復習セッションの回答ログに使う sessionId のプレースホルダー。
  /// 苦手復習は特定の試験回に紐付かないため固定値を使う。
  /// (ExamSessionRepository.getQuestionsForCurrentDay 等の day=1〜5 フィルタには
  /// 影響しない — sessionId が一致しない限りそのクエリ結果には含まれないため)
  static const String reviewSessionId = 'review';

  /// 選択肢を選んだ時に呼ぶ。正誤判定・ログ記録・進捗更新を行う。
  Future<bool> answer(int choiceIndex) async {
    final q = currentQuestion;
    final correct = choiceIndex == q.correctIndex;
    chosenAnswers[currentIndex] = choiceIndex;
    if (correct) correctCount++;

    if (mode == QuizMode.daily && sessionId != null && !isReplay) {
      // 通常の「今日のN問」学習: 進捗に反映される正式なログ。
      await examRepo.recordAnswer(
        sessionId: sessionId!,
        questionId: q.id,
        day: day,
        attempt: attempt,
        chosen: choiceIndex,
        correct: correct,
      );
    } else if (mode == QuizMode.review) {
      // 苦手復習: 進捗には影響しないが、苦手判定 (連続正解による卒業) の
      // ためにログは記録する。
      await examRepo.recordAnswer(
        sessionId: reviewSessionId,
        questionId: q.id,
        day: 0,
        attempt: 0,
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
    if (mode == QuizMode.daily && sessionId != null && !isReplay) {
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

  /// 満点なら次のDayへ進める (daily モードのみ、おかわり再挑戦時は進めない)
  Future<void> maybeAdvanceDay({required bool hanamaru}) async {
    if (mode == QuizMode.daily && sessionId != null && hanamaru && !isReplay) {
      await examRepo.advanceToNextDay(sessionId!);
    }
  }
}
