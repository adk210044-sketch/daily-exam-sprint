import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Questions,
    ExamSessions,
    DailyProgress,
    AnswerLog,
    CalendarMarks,
    UserSettings,
    Reminders,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(reminders);
      }
      if (from < 3) {
        // 目標日設定機能を廃止 (シンプル化のため削除)
        await m.dropColumn(userSettings, 'goal_date');
      }
      if (from < 4) {
        // 問題データ(exam_questions.json)のコンテンツバージョン管理用カラム。
        // 既存インストールでは 0 から開始し、QuestionImporter が
        // currentContentVersion との比較で再インポートの必要性を判定する。
        await m.addColumn(userSettings, userSettings.contentVersion);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'zen_habit_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }
}
