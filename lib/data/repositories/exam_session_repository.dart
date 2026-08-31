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

  /// 暦日ベースで day (1-7) を進行させる。
  ///
  /// 仕様: 「1日の中では同じ9問を繰り返し、日付が変わると次のDayの
  /// 新しい9問に切り替わる」ため、満点かどうかに関わらず、日付が
  /// 変わった時点で自動的に day を進める。
  ///
  /// 重要: 「経過した暦日数」ではなく「日付が変わったかどうか」だけで
  /// 判定し、変わっていれば常に +1 する。これにより、アプリを開かなかった
  /// 日は一切カウントされず、次にアプリを開いた日が「次の未消化のDay」に
  /// なる (Day3を丸ごとスキップするようなことはない)。
  /// 例: 1日目=Day1, 2日目=Day2, 3日目は開かず, 4日目に開く → Day3。
  ///
  /// - 初回アクセス時 ([dayStartedAt] が null): 現在の day (0なら1) と、
  ///   カレンダー実績([calendarFloorDay] — CalendarMarksのdistinct日数+1)の
  ///   大きい方を採用する。
  ///   (旧バージョン(花丸判定でdayが進まない実装)からの移行時に、実際には
  ///   複数日分カレンダーが埋まっているにも関わらず day が古い値のまま
  ///   引き継がれてしまう不整合を補正するため)
  /// - 2回目以降: 前回の [dayStartedAt] と今日が異なる日であれば、
  ///   経過日数に関わらず day を +1 のみ進め、[dayStartedAt] を今日に更新する。
  ///   このとき、カレンダー実績が (day+1) を上回っていればそちらを優先する。
  /// - 同じ日に再度呼ばれた場合でも、カレンダー実績が現在の day を上回って
  ///   いれば自動補正する (マイグレーション直後で今日中に発覚したケースの
  ///   自己修復)。
  /// - 既に完走済み ([status] == 'completed') のセッションは変更しない。
  ///
  /// 戻り値: 更新後の [ExamSession] (変更がなければ渡された session をそのまま返す)。
  Future<ExamSession> ensureDayProgress(ExamSession session) async {
    if (session.status == 'completed') return session;

    // 自己修復: 旧バージョンのバグ等により、実際には複数の暦日に渡って
    // 解いたにも関わらず DailyProgress/AnswerLog が同じ day 番号のまま
    // 記録されてしまっているケースを補正する。バグがなければ何もしない
    // (毎回呼んでも安全な冪等処理)。
    await _repairStuckDailyProgress(session.id);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // カレンダー実績(CalendarMarks)から「本来到達しているべき day」の下限を
    // 算出する。CalendarMarks は「その暦日に完走したか」を日付ごとに1件だけ
    // 記録するため、今日より前の distinct 日数 + 1 が、今日あるべき day の
    // 下限になる。これにより、旧バージョン等の理由で session.day が
    // カレンダー実績より遅れてしまった場合に自動的に補正できる
    // (自己修復ロジック)。
    final pastMarks =
        await (db.select(db.calendarMarks)..where(
              (t) =>
                  t.sessionId.equals(session.id) &
                  t.date.isSmallerThanValue(today),
            ))
            .get();
    final pastDaysCount = pastMarks
        .map((m) => DateTime(m.date.year, m.date.month, m.date.day))
        .toSet()
        .length;
    final calendarFloorDay = min(pastDaysCount + 1, 7);

    if (session.dayStartedAt == null) {
      final storedDay = session.day == 0 ? 1 : session.day;
      final startDay = max(storedDay, calendarFloorDay);
      await (db.update(
        db.examSessions,
      )..where((t) => t.id.equals(session.id))).write(
        ExamSessionsCompanion(day: Value(startDay), dayStartedAt: Value(today)),
      );
      return (await getSession(session.id)) ?? session;
    }

    final startedDate = DateTime(
      session.dayStartedAt!.year,
      session.dayStartedAt!.month,
      session.dayStartedAt!.day,
    );
    final currentDay = session.day == 0 ? 1 : session.day;

    if (!today.isAfter(startedDate)) {
      // 同じ日にはまだ進めないが、カレンダー実績が session.day を上回って
      // いる場合 (既にマイグレーション済みだが取り残されているケース) は
      // 補正する。
      if (calendarFloorDay > currentDay) {
        await (db.update(db.examSessions)
              ..where((t) => t.id.equals(session.id)))
            .write(ExamSessionsCompanion(day: Value(calendarFloorDay)));
        return (await getSession(session.id)) ?? session;
      }
      return session; // 同じ日にはまだ進めない
    }

    // 経過日数に関わらず常に +1 のみ進める (未消化のDayを飛ばさないため)。
    // ただし、カレンダー実績がそれ以上進んでいる場合はそちらを優先する
    // (自己修復)。
    final newDay = min(max(currentDay + 1, calendarFloorDay), 7);
    await (db.update(
      db.examSessions,
    )..where((t) => t.id.equals(session.id))).write(
      ExamSessionsCompanion(
        day: Value(newDay),
        dayStartedAt: Value(today),
        attempt: const Value(0), // 新しいDayになったので挑戦回数をリセット
      ),
    );
    return (await getSession(session.id)) ?? session;
  }

  /// 自己修復: 旧バージョンのバグ (Day進行が「満点判定」のままになっていた等)
  /// により、実際には複数の暦日に渡って解答したにも関わらず、DailyProgress /
  /// AnswerLog の day 番号 (1-5) が同じ値のまま記録されてしまっているケースを
  /// 検出し、実際に完走した日付の順序 (completedAt の日付昇順) に基づいて
  /// day 番号を正しく再割り当てする。
  ///
  /// 正常に動作しているデータに対しては、再割り当て結果が元の値と常に一致する
  /// ため no-op となる (= 何度呼んでも安全な冪等処理)。
  /// なお「おかわり」(replay) の完走は DailyProgress に記録されないため、
  /// このロジックの対象には含まれない (影響を受けない)。
  Future<void> _repairStuckDailyProgress(String sessionId) async {
    final rows =
        await (db.select(db.dailyProgress)..where(
              (t) =>
                  t.sessionId.equals(sessionId) &
                  t.day.isBiggerOrEqualValue(1) &
                  t.day.isSmallerOrEqualValue(5),
            ))
            .get();
    if (rows.isEmpty) return;

    DateTime dateOf(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

    // completedAt の日付(時刻を除く)を昇順に並べ、出現順に 1,2,3... を
    // 正しい day 番号として割り当てる (最大5)。
    final distinctDates =
        rows.map((r) => dateOf(r.completedAt)).toSet().toList()..sort();
    final correctDayOf = <DateTime, int>{};
    for (var i = 0; i < distinctDates.length; i++) {
      correctDayOf[distinctDates[i]] = min(i + 1, 5);
    }

    var changed = false;
    for (final row in rows) {
      final correctDay = correctDayOf[dateOf(row.completedAt)]!;
      if (correctDay != row.day) {
        changed = true;
        await (db.update(db.dailyProgress)..where((t) => t.id.equals(row.id)))
            .write(DailyProgressCompanion(day: Value(correctDay)));
      }
    }
    if (!changed) return; // バグの兆候なし → AnswerLog側の補正も不要

    // AnswerLog も同様に補正する (苦手復習セットの集計に使われるため)。
    final logs =
        await (db.select(db.answerLog)..where(
              (t) =>
                  t.sessionId.equals(sessionId) &
                  t.day.isBiggerOrEqualValue(1) &
                  t.day.isSmallerOrEqualValue(5),
            ))
            .get();
    for (final log in logs) {
      final correctDay = correctDayOf[dateOf(log.answeredAt)];
      if (correctDay != null && correctDay != log.day) {
        await (db.update(db.answerLog)..where((t) => t.id.equals(log.id)))
            .write(AnswerLogCompanion(day: Value(correctDay)));
      }
    }
  }

  /// 挑戦開始時: attempt をインクリメント、status を in_progress に。
  Future<void> startAttempt(String sessionId) async {
    final session0 = await getSession(sessionId);
    if (session0 == null) return;
    // 日付が変わっていれば先に day を進めてから attempt を積む。
    final session = await ensureDayProgress(session0);
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
