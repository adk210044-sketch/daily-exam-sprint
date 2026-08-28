import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Reminders (複数リマインダー) のCRUD
class ReminderRepository {
  final AppDatabase db;
  ReminderRepository(this.db);

  Future<List<Reminder>> getAll() async {
    return (db.select(
      db.reminders,
    )..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).get();
  }

  Stream<List<Reminder>> watchAll() {
    return (db.select(
      db.reminders,
    )..orderBy([(t) => OrderingTerm(expression: t.sortOrder)])).watch();
  }

  Future<int> add(String time, {String? label}) async {
    final all = await getAll();
    final nextOrder = all.isEmpty
        ? 0
        : (all.map((r) => r.sortOrder).reduce((a, b) => a > b ? a : b) + 1);
    return db
        .into(db.reminders)
        .insert(
          RemindersCompanion.insert(
            time: time,
            label: Value(label),
            sortOrder: Value(nextOrder),
          ),
        );
  }

  Future<void> updateTime(int id, String time) async {
    await (db.update(
      db.reminders,
    )..where((t) => t.id.equals(id))).write(RemindersCompanion(time: Value(time)));
  }

  Future<void> setEnabled(int id, bool enabled) async {
    await (db.update(db.reminders)..where((t) => t.id.equals(id))).write(
      RemindersCompanion(enabled: Value(enabled)),
    );
  }

  Future<void> remove(int id) async {
    await (db.delete(db.reminders)..where((t) => t.id.equals(id))).go();
  }
}
