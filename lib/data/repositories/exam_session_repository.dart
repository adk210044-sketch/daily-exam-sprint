import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../models/quiz_question.dart';
import '../services/day_split_service.dart';

/// ExamSessions・DailyProgress・AnswerLog・CalendarMarks を扱うリポジトリ。
/// 1週間サイクル (Day1-5 新問 + Day6-7 復習) の管理を担う。
class ExamSessionRepository {
  final AppDatabase db;
  ExamSessionRepository(this.db);

  Future<List<ExamSession>> getAllSessions() async {
    final rows = await (db.select(
      db.examSessions,
    )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    return rows;
  }

  Stream<List<ExamSession>> watchAllSessions() {
    return (db.select(
      db.examSessions,
    )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).watch();
  }

  Future<ExamSession?> getSession(String id) {
    return (db.select(
      db.examSessions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Stream<ExamSession?> watchSession(String id) {
    return (db.select(
      db.examSessions,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// セッションの全問題を取得 (examType+yearで絞り込み)
  Future<List<QuizQuestion>> _fullQuestionsFor(ExamSession session) async {
    final rows =
        await (db.select(db.questions)..where(
              (t) =>
                  t.examType.equals(session.examType) &
                  t.year.equals(session.year),
            ))
            .get();
    return rows.map(QuizQuestion.fromRow).toList();
  }

  /// Day1-5 の問題セットを取得 (未生成なら buildDaySets() で生成して保存)
  ///
  /// [dayQuestionIdsJson] には各Dayの「問題ID配列」を保存する。
  /// 最終日(Day5)は前日までの問題が再掲されるため、同一IDが他Dayにも
  /// 出現し得る (これは仕様上正しい挙動)。
  Future<List<List<QuizQuestion>>> ensureDaySets(ExamSession session) async {
    final allQuestions = await _fullQuestionsFor(session);
    final byId = {for (final q in allQuestions) q.id: q};

    if (session.dayQuestionIdsJson != null) {
      final Map<String, dynamic> stored =
          jsonDecode(session.dayQuestionIdsJson!) as Map<String, dynamic>;
      final result = <List<QuizQuestion>>[];
      for (var d = 1; d <= 5; d++) {
        final ids =
            (stored['$d'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        result.add(
          ids.map((id) => byId[id]).whereType<QuizQuestion>().toList(),
        );
      }
      return result;
    }

    // buildDaySets() 相当のロジックで生成
    // (除外済み問題=法改正等で単一正解が崩れたもの は既にDBインポート時に
    //  取り除かれているため、ここで取得する問題は全て出題可能なもの)
    final rows =
        await (db.select(db.questions)..where(
              (t) =>
                  t.examType.equals(session.examType) &
                  t.year.equals(session.year),
            ))
            .get();
    final dailyCount = DaySplitService.dailyCountForExamType(session.examType);
    final sets = DaySplitService.buildDaySets(
      rows,
      dailyCount: dailyCount,
      days: 5,
    );

    final map = <String, List<String>>{};
    for (var i = 0; i < sets.length; i++) {
      map['${i + 1}'] = sets[i].map((q) => q.id).toList();
    }
    await (db.update(
      db.examSessions,
    )..where((t) => t.id.equals(session.id))).write(
      ExamSessionsCompanion(dayQuestionIdsJson: Value(jsonEncode(map))),
    );

    return sets.map((list) => list.map(QuizQuestion.fromRow).toList()).toList();
  }

  /// 現在のDay (1-7) の出題問題を取得。Day6-7は復習(ミス率TOP9)を返す。
  Future<List<QuizQuestion>> getQuestionsForCurrentDay(
    ExamSession session,
  ) async {
    final day = session.day == 0 ? 1 : session.day;
    return getQuestionsForDay(session, day);
  }

  /// 指定した Day (1-7) の出題問題を取得する。
  /// おかわり機能で「現在の進捗Dayとは異なる、過去のDay」を明示的に指定して
  /// 取得する場合に使用する (Day1-5 は固定9問セット、Day6-7 は復習セット)。
  Future<List<QuizQuestion>> getQuestionsForDay(
    ExamSession session,
    int day,
  ) async {
    if (day <= 5) {
      final daySets = await ensureDaySets(session);
      return daySets[day - 1];
    } else {
      return ensureReviewSet(session);
    }
  }

  /// Day6-7 用のミス率TOPNを生成 (未生成なら計算して保存)
  /// N = examType に応じた1日あたり問題数 (第1種=9 / 第2種=6)
  Future<List<QuizQuestion>> ensureReviewSet(ExamSession session) async {
    final n = DaySplitService.dailyCountForExamType(session.examType);
    if (session.reviewQuestionIdsJson != null) {
      final ids = (jsonDecode(session.reviewQuestionIdsJson!) as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      final rows = await (db.select(
        db.questions,
      )..where((t) => t.id.isIn(ids))).get();
      final byId = {for (final r in rows) r.id: QuizQuestion.fromRow(r)};
      return ids.map((id) => byId[id]).whereType<QuizQuestion>().toList();
    }

    // Day1-5 の回答ログからミス率を計算
    final logs =
        await (db.select(db.answerLog)..where(
              (t) =>
                  t.sessionId.equals(session.id) &
                  t.day.isBiggerOrEqualValue(1) &
                  t.day.isSmallerOrEqualValue(5),
            ))
            .get();

    final attempts = <String, int>{};
    final misses = <String, int>{};
    for (final log in logs) {
      attempts[log.questionId] = (attempts[log.questionId] ?? 0) + 1;
      if (!log.correct) {
        misses[log.questionId] = (misses[log.questionId] ?? 0) + 1;
      }
    }

    final missRates =
        misses.entries
            .map(
              (e) => (
                id: e.key,
                rate: e.value / (attempts[e.key] ?? 1),
                count: e.value,
              ),
            )
            .toList()
          ..sort((a, b) => b.rate.compareTo(a.rate));

    var selectedIds = missRates.take(n).map((e) => e.id).toList();

    // ミスがN問未満の場合は、Day1-5の問題からランダムに補充
    if (selectedIds.length < n) {
      final allDaySets = await ensureDaySets(session);
      final allIds = allDaySets.expand((d) => d.map((q) => q.id)).toSet();
      final remaining = allIds.difference(selectedIds.toSet()).toList()
        ..shuffle(Random());
      selectedIds = [...selectedIds, ...remaining.take(n - selectedIds.length)];
    }

    await (db.update(
      db.examSessions,
    )..where((t) => t.id.equals(session.id))).write(
      ExamSessionsCompanion(
        reviewQuestionIdsJson: Value(jsonEncode(selectedIds)),
      ),
    );

    final rows = await (db.select(
      db.questions,
    )..where((t) => t.id.isIn(selectedIds))).get();
    final byId = {for (final r in rows) r.id: QuizQuestion.fromRow(r)};
    return selectedIds.map((id) => byId[id]).whereType<QuizQuestion>().toList();
  }

  /// 挑戦開始時: attempt をインクリメント、status を in_progress に。
  Future<void> startAttempt(String sessionId) async {
    final session = await getSession(sessionId);
    if (session == null) return;
    await (db.update(
      db.examSessions,
    )..where((t) => t.id.equals(sessionId))).write(
      ExamSessionsCompanion(
        attempt: Value(session.attempt + 1),
        status: Value(
          session.status == 'not_started' ? 'in_progress' : session.status,
        ),
        day: Value(session.day == 0 ? 1 : session.day),
      ),
    );
  }

  /// 1問回答をログに記録
  Future<void> recordAnswer({
    required String sessionId,
    required String questionId,
    required int day,
    required int attempt,
    required int chosen,
    required bool correct,
  }) async {
    await db
        .into(db.answerLog)
        .insert(
          AnswerLogCompanion.insert(
            questionId: questionId,
            sessionId: sessionId,
            day: day,
            attempt: attempt,
            chosen: chosen,
            correct: correct,
            answeredAt: DateTime.now(),
          ),
        );
  }

  /// 9問(または8問)完走時: スコア計算・花丸判定・進捗更新・カレンダー記録
  Future<({int score, bool hanamaru})> completeDay({
    required String sessionId,
    required int day,
    required int attempt,
    required int correctCount,
    required int totalQuestions,
  }) async {
    final score = totalQuestions == 0
        ? 0
        : ((correctCount / totalQuestions) * 100).round();
    final hanamaru = correctCount == totalQuestions;

    await db
        .into(db.dailyProgress)
        .insert(
          DailyProgressCompanion.insert(
            sessionId: sessionId,
            day: day,
            attempt: attempt,
            score: score,
            totalQuestions: totalQuestions,
            hanamaru: Value(hanamaru),
            completedAt: DateTime.now(),
          ),
        );

    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    // CalendarMarks の実質的なユニークキーは `date` (uniqueKeys で定義) だが、
    // 主キーは自動採番の `id` のため、insertOnConflictUpdate() のデフォルト
    // (主キーを競合対象にする) では `date` の UNIQUE 制約違反を検知できず、
    // 同日に2回目以降の完走をすると SqliteException(2067) が発生していた。
    // → 明示的に `date` を競合対象に指定して upsert する。
    final markCompanion = CalendarMarksCompanion.insert(
      date: dateOnly,
      score: score,
      hanamaru: hanamaru,
      sessionId: Value(sessionId),
    );
    await db
        .into(db.calendarMarks)
        .insert(
          markCompanion,
          onConflict: DoUpdate(
            (_) => markCompanion,
            target: [db.calendarMarks.date],
          ),
        );

    final session = await getSession(sessionId);
    if (session != null) {
      final isWeekComplete = day >= 7;
      final newHanamaruDays = hanamaru
          ? session.hanamaruDays + 1
          : session.hanamaruDays;
      // 平均スコアは全DailyProgressの平均で概算更新
      final allProgress = await (db.select(
        db.dailyProgress,
      )..where((t) => t.sessionId.equals(sessionId))).get();
      final bestPerDay = <int, int>{};
      for (final p in allProgress) {
        bestPerDay[p.day] = max(bestPerDay[p.day] ?? 0, p.score);
      }
      final avg = bestPerDay.values.isEmpty
          ? score
          : (bestPerDay.values.reduce((a, b) => a + b) /
                    bestPerDay.values.length)
                .round();

      await (db.update(
        db.examSessions,
      )..where((t) => t.id.equals(sessionId))).write(
        ExamSessionsCompanion(
          hanamaruDays: Value(newHanamaruDays),
          avgScore: Value(avg),
          weekComplete: Value(isWeekComplete),
          status: Value(isWeekComplete ? 'completed' : 'in_progress'),
        ),
      );
    }

    return (score: score, hanamaru: hanamaru);
  }

  /// 次のDayへ進む (満点 or 十分な進捗後にユーザーが選択)
  Future<void> advanceToNextDay(String sessionId) async {
    final session = await getSession(sessionId);
    if (session == null) return;
    final nextDay = min(session.day + 1, 7);
    await (db.update(
      db.examSessions,
    )..where((t) => t.id.equals(sessionId))).write(
      ExamSessionsCompanion(day: Value(nextDay), attempt: const Value(0)),
    );
  }

  /// 現在のセッションの Day1-7 それぞれの最高スコア (%) を取得する。
  /// (Home画面の週間進捗バー用。未着手の Day はキーが存在しない)
  Future<Map<int, int>> getBestScoresByDay(String sessionId) async {
    final rows = await (db.select(
      db.dailyProgress,
    )..where((t) => t.sessionId.equals(sessionId))).get();
    final best = <int, int>{};
    for (final p in rows) {
      best[p.day] = max(best[p.day] ?? 0, p.score);
    }
    return best;
  }

  /// 現在のセッションの Day1-7 それぞれの挑戦(完走)回数を取得する。
  /// (Home画面の週間進捗バー用。dailyProgress の記録件数 = 完走した回数)
  Future<Map<int, int>> getAttemptCountsByDay(String sessionId) async {
    final rows = await (db.select(
      db.dailyProgress,
    )..where((t) => t.sessionId.equals(sessionId))).get();
    final counts = <int, int>{};
    for (final p in rows) {
      counts[p.day] = (counts[p.day] ?? 0) + 1;
    }
    return counts;
  }

  /// 直近7日間のスコア履歴 (Home画面のミニバー用)
  Future<List<CalendarMark>> getRecentMarks({int days = 7}) async {
    final now = DateTime.now();
    final from = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: days - 1));
    final rows =
        await (db.select(db.calendarMarks)
              ..where((t) => t.date.isBiggerOrEqualValue(from))
              ..orderBy([(t) => OrderingTerm.asc(t.date)]))
            .get();
    return rows;
  }

  /// 指定月のカレンダーマーク取得
  Future<List<CalendarMark>> getMarksForMonth(int year, int month) async {
    final from = DateTime(year, month, 1);
    final to = DateTime(year, month + 1, 1);
    final rows =
        await (db.select(db.calendarMarks)..where(
              (t) =>
                  t.date.isBiggerOrEqualValue(from) &
                  t.date.isSmallerThanValue(to),
            ))
            .get();
    return rows;
  }

  /// 連続日数 (streak) を計算
  Future<int> getStreakDays() async {
    final rows = await (db.select(
      db.calendarMarks,
    )..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
    if (rows.isEmpty) return 0;
    final dates = rows
        .map((r) => DateTime(r.date.year, r.date.month, r.date.day))
        .toSet();
    var streak = 0;
    var cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
    while (dates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
