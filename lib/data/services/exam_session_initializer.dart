import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// 令和年月ラベルの並び順 (新しい順)。ソート・直近判定に使用。
/// 出典: 03_specs/dev_handoff_README.md / mockData.js の EXAM_SESSIONS
///
/// 【運用ルール】 新しい試験回の問題データ (exam_questions.json) を追加した際は、
/// 必ずこのリストの先頭に新しい年度を追加すること。
/// [ExamSessionInitializer.syncSessions] が起動の都度呼ばれ、
/// ・まだ ExamSessions テーブルに存在しない年度を自動で追加
/// ・直近2回 (kFreeExamCount) の isLatest / 全セッションの sortOrder を再計算
/// するため、既存ユーザーの端末にも新しい試験回が自動的に反映される。
/// (進捗データ: status/day/attempt/avgScore等は insertOnConflictUpdate が
/// 明示的に指定したカラムのみ更新する Drift の仕様により、一切上書きされない)
const List<String> kYearOrderNewestFirst = [
  '令和8年4月公表',
  '令和7年10月公表',
  '令和7年4月公表',
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

/// Questions テーブルの実データから ExamSessions を生成・同期する。
/// 新規インストール時は全件作成、既存インストールでは不足分のみ追加し、
/// isLatest / sortOrder を常に最新の [kYearOrderNewestFirst] に合わせて更新する。
class ExamSessionInitializer {
  final AppDatabase db;
  ExamSessionInitializer(this.db);

  /// 後方互換のためのエイリアス。
  Future<void> initIfNeeded() => syncSessions();

  Future<void> syncSessions() async {
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

        // 新規行の作成、または isLatest/sortOrder/totalQ のみを更新。
        // (Companion.insert で指定していない進捗系カラムは Value.absent()
        //  となるため、insertOnConflictUpdate は既存行の進捗データを
        //  一切変更しない)
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
