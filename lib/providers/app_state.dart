import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart';
import '../data/repositories/exam_session_repository.dart';
import '../data/repositories/review_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/services/exam_session_initializer.dart';
import '../data/services/notification_service.dart';
import '../data/services/question_importer.dart';

/// アプリ全体の初期化・設定・現在セッションを保持するグローバル状態
class AppState extends ChangeNotifier {
  final AppDatabase db;
  late final SettingsRepository settingsRepo;
  late final ExamSessionRepository examRepo;
  late final ReviewRepository reviewRepo;

  UserSetting? settings;
  bool isReady = false;

  AppState(this.db) {
    settingsRepo = SettingsRepository(db);
    examRepo = ExamSessionRepository(db);
    reviewRepo = ReviewRepository(db);
  }

  Future<void> init() async {
    await QuestionImporter(db).importIfNeeded();
    await ExamSessionInitializer(db).initIfNeeded();
    settings = await settingsRepo.getOrCreate();
    await NotificationService.instance.init();
    if (settings?.notificationsEnabled == true) {
      await NotificationService.instance.scheduleDailyReminder(
        settings!.reminderTime,
      );
    }
    isReady = true;
    notifyListeners();
  }

  Future<void> refreshSettings() async {
    settings = await settingsRepo.getOrCreate();
    notifyListeners();
  }

  Future<void> setExamType(String type) async {
    await settingsRepo.setExamType(type);
    // 試験区分を切り替えたら、古い試験区分のセッションが再利用されないよう
    // currentSessionId をクリアする。HomeScreen が次回ロード時に
    // 新しい examType に一致するセッションを自動選択する。
    await settingsRepo.setCurrentSessionId(null);
    await refreshSettings();
  }

  Future<void> setReminderTime(String time) async {
    await settingsRepo.setReminderTime(time);
    await refreshSettings();
    if (settings?.notificationsEnabled == true) {
      await NotificationService.instance.scheduleDailyReminder(time);
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await settingsRepo.setNotificationsEnabled(enabled);
    await refreshSettings();
    if (enabled) {
      final granted = await NotificationService.instance.requestPermission();
      if (granted || kIsWeb) {
        await NotificationService.instance.scheduleDailyReminder(
          settings?.reminderTime ?? '08:15',
        );
      }
    } else {
      await NotificationService.instance.cancelDailyReminder();
    }
  }

  Future<void> setFontSize(String size) async {
    await settingsRepo.setFontSize(size);
    await refreshSettings();
  }

  Future<void> setGoalDate(DateTime? date) async {
    await settingsRepo.setGoalDate(date);
    await refreshSettings();
  }

  Future<void> completeOnboarding() async {
    await settingsRepo.setOnboardingComplete(true);
    await refreshSettings();
  }

  Future<void> setCurrentSession(String id) async {
    await settingsRepo.setCurrentSessionId(id);
    await refreshSettings();
  }

  Future<void> setPurchased(bool purchased) async {
    await settingsRepo.setPurchased(purchased);
    await refreshSettings();
  }

  bool get purchased => settings?.purchased ?? false;
  String get examType => settings?.examType ?? 'type1';
  int get dailyQuestionCount => examType == 'type1' ? 9 : 6;

  String get fontSize => settings?.fontSize ?? 'medium';
  bool get notificationsEnabled => settings?.notificationsEnabled ?? false;

  /// フォントサイズ設定 ('small' / 'medium' / 'large') に対応する textScale
  double get textScale {
    switch (fontSize) {
      case 'small':
        return 0.9;
      case 'large':
        return 1.15;
      default:
        return 1.0;
    }
  }
}
