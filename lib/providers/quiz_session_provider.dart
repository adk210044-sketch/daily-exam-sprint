import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart' show QuizDraft;
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

  /// 現在のモードに対応する QuizModeName (一時保存用の独立enumへの変換)。
  /// 「おかわり」は一時保存の対象外 (常に null)。
  QuizModeName? get _draftMode {
    if (mode == QuizMode.daily && !isReplay) return QuizModeName.daily;
    if (mode == QuizMode.review) return QuizModeName.review;
    return null;
  }

  /// 「今日の9問」に再開可能な下書きがあるか確認する。
  /// [examSessionId]/[expectedDay] と下書きの内容が一致しない場合 (試験回や
  /// Dayが変わってしまった場合) は古い下書きとして自動的に破棄し false を返す。
  Future<bool> hasResumableDailyDraft({
    required String examSessionId,
    required int expectedDay,
  }) async {
    final draft = await examRepo.getQuizDraft(QuizModeName.daily);
    if (draft == null) return false;
    if (draft.sessionId != examSessionId || draft.day != expectedDay) {
      await examRepo.clearQuizDraft(QuizModeName.daily);
      return false;
    }
    return _draftHasProgress(draft);
  }

  /// 「苦手復習」に再開可能な下書きがあるか確認する。
  Future<bool> hasResumableReviewDraft() async {
    final draft = await examRepo.getQuizDraft(QuizModeName.review);
    if (draft == null) return false;
    return _draftHasProgress(draft);
  }

  bool _draftHasProgress(QuizDraft draft) {
    final chosen = (jsonDecode(draft.chosenAnswersJson) as List<dynamic>);
    // 1問も回答していない、または既に全問回答済みの下書きは再開する意味が
    // ないため false とする (呼び出し側で不要な下書きとして扱われる)。
    final answeredCount = chosen.where((c) => c != null).length;
    return answeredCount > 0 && answeredCount < chosen.length;
  }

  Future<void> startDaily(String examSessionId) async {
    isLoading = true;
    notifyListeners();

    mode = QuizMode.daily;
    isReplay = false;
    sessionId = examSessionId;
    final session0 = await examRepo.getSession(examSessionId);
    if (session0 == null) {
      isLoading = false;
      notifyListeners();
      return;
    }
    // 日付が変わっていれば、ここで day を暦日ベースに進める
    // (満点かどうかに関わらず、1日経てば次のDayの新しい9問に切り替わる)。
    final session = await examRepo.ensureDayProgress(session0);
    day = session.day == 0 ? 1 : session.day;
    // 新しく始める (再開ではない) ため、古い下書きが残っていれば破棄する。
    await examRepo.clearQuizDraft(QuizModeName.daily);
    await examRepo.startAttempt(examSessionId);
    final refreshed = await examRepo.getSession(examSessionId);
    attempt = refreshed?.attempt ?? 1;

    questions = await examRepo.getQuestionsForCurrentDay(refreshed ?? session);
    _resetProgress();

    isLoading = false;
    notifyListeners();
  }

  /// 中断していた「今日の9問」を、保存されていた地点から再開する。
  /// [hasResumableDailyDraft] が true を返した場合にのみ呼ぶこと。
  Future<void> resumeDaily(String examSessionId) async {
    isLoading = true;
    notifyListeners();

    final draft = await examRepo.getQuizDraft(QuizModeName.daily);
    if (draft == null) {
      // 想定外 (呼び出し側のチェック漏れ)。新規開始にフォールバック。
      isLoading = false;
      notifyListeners();
      await startDaily(examSessionId);
      return;
    }

    mode = QuizMode.daily;
    isReplay = false;
    sessionId = examSessionId;
    day = draft.day ?? 1;
    attempt = draft.attempt ?? 1;

    final ids = (jsonDecode(draft.questionIdsJson) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    questions = await examRepo.getQuestionsByIds(ids);
    _restoreFromDraft(draft);

    isLoading = false;
    notifyListeners();
  }

  /// おかわり(過去の回を選んで解き直す)専用セッション開始。
  /// [replayDay] は 1-5 のいずれか (Day6,7は復習日のため対象外)。
  /// 進捗 (session.day / attempt カウント) には一切影響を与えない、
  /// 練習用の読み取り専用プレイセッション (一時保存の対象外)。
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
    // 新しく始める (再開ではない) ため、古い下書きが残っていれば破棄する。
    await examRepo.clearQuizDraft(QuizModeName.review);
    questions = await reviewRepo.buildReviewSet(
      purchased: purchased,
      dailyCount: dailyCount,
    );
    _resetProgress();

    isLoading = false;
    notifyListeners();
  }

  /// 中断していた「苦手復習」を、保存されていた地点から再開する。
  /// [hasResumableReviewDraft] が true を返した場合にのみ呼ぶこと。
  Future<void> resumeReview() async {
    isLoading = true;
    notifyListeners();

    final draft = await examRepo.getQuizDraft(QuizModeName.review);
    if (draft == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    mode = QuizMode.review;
    sessionId = null;
    day = 0;
    attempt = 1;

    final ids = (jsonDecode(draft.questionIdsJson) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    questions = await examRepo.getQuestionsByIds(ids);
    _restoreFromDraft(draft);

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

  /// 下書きの chosenAnswers を復元し、最初の未回答問題の位置まで進める。
  void _restoreFromDraft(QuizDraft draft) {
    final chosen = (jsonDecode(draft.chosenAnswersJson) as List<dynamic>)
        .map((e) => e as int?)
        .toList();
    chosenAnswers
      ..clear()
      ..addAll(chosen);
    correctCount = 0;
    for (var i = 0; i < chosenAnswers.length && i < questions.length; i++) {
      final chosenIdx = chosenAnswers[i];
      if (chosenIdx != null && chosenIdx == questions[i].correctIndex) {
        correctCount++;
      }
    }
    // 最初の未回答位置に移動 (全問回答済みなら最後の問題に留まる)。
    final firstUnanswered = chosenAnswers.indexWhere((c) => c == null);
    currentIndex = firstUnanswered != -1
        ? firstUnanswered
        : (questions.isEmpty ? 0 : questions.length - 1);
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
    await _saveDraft();
    notifyListeners();
    return correct;
  }

  /// 回答するたびに、現在の途中経過を下書きとして自動保存する
  /// (中断してアプリを完全に閉じても、次回同じ地点から再開できるようにするため)。
  /// 「おかわり」は対象外。
  Future<void> _saveDraft() async {
    final draftMode = _draftMode;
    if (draftMode == null) return;
    await examRepo.saveQuizDraft(
      mode: draftMode,
      sessionId: draftMode == QuizModeName.daily ? sessionId : null,
      day: draftMode == QuizModeName.daily ? day : null,
      attempt: draftMode == QuizModeName.daily ? attempt : null,
      questionIds: questions.map((q) => q.id).toList(),
      chosenAnswers: chosenAnswers,
    );
  }

  void nextQuestion() {
    if (!isLastQuestion) {
      currentIndex++;
      notifyListeners();
    }
  }

  /// 完走時に呼ぶ。score(0-100) と 花丸フラグを返す。
  Future<({int score, bool hanamaru})> completeSession() async {
    // 完走したので下書きは不要 (次回開始時は必ず新規スタート)。
    final draftMode = _draftMode;
    if (draftMode != null) {
      await examRepo.clearQuizDraft(draftMode);
    }

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
}
