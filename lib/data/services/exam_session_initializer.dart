import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// 令和年月ラベルの並び順 (新しい順)。ソート・直近判定に使用。
/// 出典: 03_specs/dev_handoff_README.md / mockData.js の EXAM_SESSIONS
const List<String> kYearOrderNewestFirst = [
  '令和6年10月公表',
  '令和6年4月公表',
  '令和5年10月公表',
  '令和5年4月公表',
  '令和4年10月公表',
  '令和4年4月公表',
  '令和3年10月公表',
  '令和3年4月公表',
  '令和2年10月公表',
  '令和2年4月公表',
  '令和1年10月公表',
];

const int kFreeExamCount = 2; // 直近2回分は無料

String _labelFromYear(String year) {
  // "令和6年10月公表" -> "令和6年 10月"
  final m = RegExp(r'令和(\d+)年(\d+)月').firstMatch(year);
  if (m == null) return year;
  return '令和${m.group(1)}年 ${m.group(2)}月';
}

String _idFromYear(String year) {
  // "令和6年10月公表" -> "r6_10"
  final m = RegExp(r'令和(\d+)年(\d+)月').firstMatch(year);
  if (m == null) return year;
  final month = m.group(2)!.padLeft(2, '0');
  return 'r${m.group(1)}_$month';
}

/// Questions テーブルの実データから ExamSessions を生成する (初回のみ)。
class ExamSessionInitializer {
  final AppDatabase db;
  ExamSessionInitializer(this.db);

  Future<void> initIfNeeded() async {
    final existing = await db.select(db.examSessions).get();
    if (existing.isNotEmpty) return;

    for (final examType in ['type1', 'type2']) {
      final questions = await (db.select(
        db.questions,
      )..where((t) => t.examType.equals(examType))).get();
      if (questions.isEmpty) continue;

      final byYear = <String, List<Question>>{};
      for (final q in questions) {
        byYear.putIfAbsent(q.year, () => []).add(q);
      }

      for (var i = 0; i < kYearOrderNewestFirst.length; i++) {
        final year = kYearOrderNewestFirst[i];
        final qs = byYear[year];
        if (qs == null || qs.isEmpty) continue;

        final id = '${_idFromYear(year)}_$examType';
        final isLatest = i < kFreeExamCount;

        await db
            .into(db.examSessions)
            .insertOnConflictUpdate(
              ExamSessionsCompanion.insert(
                id: id,
                year: year,
                label: _labelFromYear(year),
                examType: examType,
                totalQ: qs.length,
                isLatest: Value(isLatest),
                sortOrder: Value(i),
              ),
            );
      }
    }
  }
}
