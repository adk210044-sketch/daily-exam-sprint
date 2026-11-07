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
    // 新規インストール: 「7日間フルアクセス体験」トライアルの起点として
    // 現在時刻を記録する。既存インストール (マイグレーション経由で行が
    // 既に存在するケース) はこの分岐を通らないため firstLaunchAt は
    // null のまま = トライアル対象外になる。
    await db
        .into(db.userSettings)
        .insert(
          UserSettingsCompanion(
            id: const Value(0),
            firstLaunchAt: Value(DateTime.now()),
          ),
        );
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
