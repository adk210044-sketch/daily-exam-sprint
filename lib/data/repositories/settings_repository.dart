import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// UserSettings (単一行, id=0) のCRUD
class SettingsRepository {
  final AppDatabase db;
  SettingsRepository(this.db);

  Future<UserSetting> getOrCreate() async {
    final existing = await (db.select(
      db.userSettings,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    if (existing != null) return existing;
    await db
        .into(db.userSettings)
        .insert(const UserSettingsCompanion(id: Value(0)));
    return (await (db.select(
      db.userSettings,
    )..where((t) => t.id.equals(0))).getSingle());
  }

  Stream<UserSetting> watch() {
    return (db.select(
      db.userSettings,
    )..where((t) => t.id.equals(0))).watchSingle();
  }

  Future<void> update(UserSettingsCompanion companion) async {
    await db
        .into(db.userSettings)
        .insertOnConflictUpdate(companion.copyWith(id: const Value(0)));
  }

  Future<void> setExamType(String examType) =>
      update(UserSettingsCompanion(examType: Value(examType)));

  Future<void> setReminderTime(String time) =>
      update(UserSettingsCompanion(reminderTime: Value(time)));

  Future<void> setGoalDate(DateTime? date) =>
      update(UserSettingsCompanion(goalDate: Value(date)));

  Future<void> setFontSize(String size) =>
      update(UserSettingsCompanion(fontSize: Value(size)));

  Future<void> setOnboardingComplete(bool complete) =>
      update(UserSettingsCompanion(onboardingComplete: Value(complete)));

  Future<void> setNotificationsEnabled(bool enabled) =>
      update(UserSettingsCompanion(notificationsEnabled: Value(enabled)));

  Future<void> setCurrentSessionId(String? id) =>
      update(UserSettingsCompanion(currentSessionId: Value(id)));

  Future<void> setPurchased(bool purchased) =>
      update(UserSettingsCompanion(purchased: Value(purchased)));
}
