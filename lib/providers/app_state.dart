import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart';
import '../data/repositories/exam_session_repository.dart';
import '../data/repositories/review_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/services/exam_session_initializer.dart';
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
    isReady = true;
    notifyListeners();
  }

  Future<void> refreshSettings() async {
    settings = await settingsRepo.getOrCreate();
    notifyListeners();
  }

  Future<void> setExamType(String type) async {
    await settingsRepo.setExamType(type);
    await refreshSettings();
  }

  Future<void> setReminderTime(String time) async {
    await settingsRepo.setReminderTime(time);
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
}
