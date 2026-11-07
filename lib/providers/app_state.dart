import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart';
import '../data/repositories/exam_session_repository.dart';
import '../data/repositories/reminder_repository.dart';
import '../data/repositories/review_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/services/diagnosis_service.dart';
import '../data/services/exam_session_initializer.dart';
import '../data/services/notification_service.dart';
import '../data/services/purchase_service.dart';
import '../data/services/question_importer.dart';

/// アプリ全体の初期化・設定・現在セッションを保持するグローバル状態
class AppState extends ChangeNotifier {
  final AppDatabase db;
  late final SettingsRepository settingsRepo;
  late final ExamSessionRepository examRepo;
  late final ReviewRepository reviewRepo;
  late final ReminderRepository reminderRepo;
  late final DiagnosisService diagnosisService;
  late final MockExamService mockExamService;

  UserSetting? settings;
  List<Reminder> reminders = [];
  bool isReady = false;

  /// 購入フロー中にUIへ伝えるエラーメッセージ (SnackBar等で一度だけ消費する)
  String? purchaseErrorMessage;

  AppState(this.db) {
    settingsRepo = SettingsRepository(db);
    examRepo = ExamSessionRepository(db);
    reviewRepo = ReviewRepository(db);
    reminderRepo = ReminderRepository(db);
    diagnosisService = DiagnosisService(db, examRepo);
    mockExamService = MockExamService(db);
  }

  Future<void> init() async {
    await QuestionImporter(db).importIfNeeded();
    await ExamSessionInitializer(db).syncSessions();
    settings = await settingsRepo.getOrCreate();
    reminders = await reminderRepo.getAll();
    await NotificationService.instance.init();
    if (settings?.notificationsEnabled == true) {
      await _scheduleAllEnabledReminders();
    }
    _initPurchaseService();
    isReady = true;
    notifyListeners();
  }

  /// PurchaseService の購入完了・エラーコールバックを配線し、初期化する。
  void _initPurchaseService() {
    PurchaseService.instance.onPurchaseSuccess = () {
      // ストアからの購入確定 (新規購入 or 復元) を受けてDBに反映
      setPurchased(true);
    };
    PurchaseService.instance.onPurchaseError = (message) {
      purchaseErrorMessage = message;
      notifyListeners();
    };
    PurchaseService.instance.init();
  }

  /// UI側で一度表示したエラーメッセージをクリアする。
  void clearPurchaseError() {
    purchaseErrorMessage = null;
    notifyListeners();
  }

  Future<void> refreshSettings() async {
    settings = await settingsRepo.getOrCreate();
    notifyListeners();
  }

  Future<void> refreshReminders() async {
    reminders = await reminderRepo.getAll();
    notifyListeners();
  }

  Future<void> _scheduleAllEnabledReminders() async {
    for (final r in reminders) {
      if (r.enabled) {
        await NotificationService.instance.scheduleReminder(
          r.id,
          r.time,
          dailyCount: dailyQuestionCount,
        );
      } else {
        await NotificationService.instance.cancelReminder(r.id);
      }
    }
  }

  Future<void> _cancelAllReminders() async {
    for (final r in reminders) {
      await NotificationService.instance.cancelReminder(r.id);
    }
  }

  /// リマインダーを追加する ("HH:mm" 形式)
  Future<void> addReminder(String time, {String? label}) async {
    final id = await reminderRepo.add(time, label: label);
    await refreshReminders();
    if (notificationsEnabled) {
      await NotificationService.instance.scheduleReminder(
        id,
        time,
        dailyCount: dailyQuestionCount,
      );
    }
  }

  Future<void> updateReminderTime(int id, String time) async {
    await reminderRepo.updateTime(id, time);
    await refreshReminders();
    final reminder = reminders.firstWhere((r) => r.id == id);
    if (notificationsEnabled && reminder.enabled) {
      await NotificationService.instance.scheduleReminder(
        id,
        time,
        dailyCount: dailyQuestionCount,
      );
    }
  }

  Future<void> setReminderEnabled(int id, bool enabled) async {
    await reminderRepo.setEnabled(id, enabled);
    await refreshReminders();
    if (!notificationsEnabled) return;
    if (enabled) {
      final reminder = reminders.firstWhere((r) => r.id == id);
      await NotificationService.instance.scheduleReminder(
        id,
        reminder.time,
        dailyCount: dailyQuestionCount,
      );
    } else {
      await NotificationService.instance.cancelReminder(id);
    }
  }

  Future<void> removeReminder(int id) async {
    await NotificationService.instance.cancelReminder(id);
    await reminderRepo.remove(id);
    await refreshReminders();
  }

  Future<void> setExamType(String type) async {
    await settingsRepo.setExamType(type);
    // 試験区分を切り替えたら、古い試験区分のセッションが再利用されないよう
    // currentSessionId をクリアする。HomeScreen が次回ロード時に
    // 新しい examType に一致するセッションを自動選択する。
    await settingsRepo.setCurrentSessionId(null);
    await refreshSettings();
    // 試験区分変更で1日の問題数(9→6等)も変わるため、通知文言を再スケジュール
    if (settings?.notificationsEnabled == true) {
      await _scheduleAllEnabledReminders();
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await settingsRepo.setNotificationsEnabled(enabled);
    await refreshSettings();
    if (enabled) {
      final granted = await NotificationService.instance.requestPermission();
      if (granted || kIsWeb) {
        await _scheduleAllEnabledReminders();
      }
    } else {
      await _cancelAllReminders();
    }
  }

  Future<void> setFontSize(String size) async {
    await settingsRepo.setFontSize(size);
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

  /// 「7日間フルアクセス体験」トライアル期間の長さ。
  static const Duration trialDuration = Duration(days: 7);

  /// 現在トライアル期間中 (インストールから7日以内) かどうか。
  /// 既存インストール (マイグレーションで firstLaunchAt が null のまま) は
  /// 対象外として常に false を返す。購入済みの場合もトライアル判定は
  /// 無意味だが false を返す (呼び出し側は hasFullAccess を使うこと)。
  bool get isInTrial {
    final start = settings?.firstLaunchAt;
    if (start == null) return false;
    return DateTime.now().isBefore(start.add(trialDuration));
  }

  /// トライアル残り日数 (切り上げ、0以上)。トライアル対象外/終了後は 0。
  int get trialDaysRemaining {
    final start = settings?.firstLaunchAt;
    if (start == null) return 0;
    final end = start.add(trialDuration);
    final remaining = end.difference(DateTime.now());
    if (remaining.isNegative) return 0;
    // 端数の時間も「1日」として切り上げる (例: 残り3時間でも「残り1日」と表示)
    return (remaining.inHours / 24).ceil().clamp(0, trialDuration.inDays);
  }

  /// 「全14回フルアクセス」を得られる条件 (購入済み or トライアル中)。
  /// 試験選択のロック判定・苦手復習の無制限化などはこちらを使うこと。
  bool get hasFullAccess => purchased || isInTrial;

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

  @override
  void dispose() {
    PurchaseService.instance.dispose();
    super.dispose();
  }
}
