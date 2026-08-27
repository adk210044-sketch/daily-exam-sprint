import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// ローカル通知(リマインダー)の管理サービス。
/// Web platformでは通知はサポートされないため、no-opとして動作する。
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const int _dailyReminderId = 1001;

  Future<void> init() async {
    if (_initialized) return;
    // Web platform は flutter_local_notifications が対応していないためスキップ
    if (kIsWeb) {
      _initialized = true;
      return;
    }

    try {
      tz_data.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings();
      const settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(settings: settings);
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('NotificationService init failed: $e');
      }
    }
  }

  /// 通知の許可をリクエストする (Android 13+ / iOS)
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    try {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidImpl != null) {
        final granted = await androidImpl.requestNotificationsPermission();
        return granted ?? false;
      }
      final iosImpl = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (iosImpl != null) {
        final granted = await iosImpl.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('NotificationService requestPermission failed: $e');
      }
      return false;
    }
  }

  /// "HH:mm" 形式の時刻で毎日リマインダーを再スケジュールする。
  /// [dailyCount] は試験区分に応じた1日の問題数 (第1種=9 / 第2種=6)。
  Future<void> scheduleDailyReminder(
    String hhmm, {
    int dailyCount = 9,
  }) async {
    if (kIsWeb) return;
    await init();
    try {
      await _plugin.cancel(id: _dailyReminderId);

      final parts = hhmm.split(':');
      final hour = int.tryParse(parts[0]) ?? 8;
      final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 15;

      final scheduled = _nextInstanceOfTime(hour, minute);

      await _plugin.zonedSchedule(
        id: _dailyReminderId,
        title: '今日の$dailyCount問、はじめましょう',
        body: '1日$dailyCount問 衛生管理者 — 今日の分がまだ残っています。',
        scheduledDate: scheduled,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel',
            '日次リマインダー',
            channelDescription: '1日$dailyCount問の学習リマインダー',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('NotificationService scheduleDailyReminder failed: $e');
      }
    }
  }

  Future<void> cancelDailyReminder() async {
    if (kIsWeb) return;
    try {
      await _plugin.cancel(id: _dailyReminderId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('NotificationService cancelDailyReminder failed: $e');
      }
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
