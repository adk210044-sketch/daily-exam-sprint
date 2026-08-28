import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/app_state.dart';
import '../../widgets/zen_widgets.dart';
import '../main/home_screen.dart';

/// 通知許可 (ZenNotificationPermission) — iOSカスタムダイアログ形式
class OnbNotificationPermissionScreen extends StatelessWidget {
  const OnbNotificationPermissionScreen({super.key});

  Future<void> _finish(BuildContext context, {required bool enabled}) async {
    final appState = context.read<AppState>();
    await appState.setNotificationsEnabled(enabled);
    await appState.completeOnboarding();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final dailyN = appState.dailyQuestionCount;
    final reminderTime = appState.reminders.isNotEmpty
        ? appState.reminders.first.time
        : '8:15';
    return Scaffold(
      backgroundColor: ZenColors.ink.withValues(alpha: 0.4),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            Container(
              decoration: const BoxDecoration(
                color: ZenColors.card,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(32, 12, 32, 24),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: ZenColors.line,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ZenColors.accentSoft,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: ZenColors.accent,
                      size: 30,
                    ),
                  ),
                  const Text(
                    'リマインダーを送っても\nいいですか？',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ZenColors.ink,
                      letterSpacing: 0.7,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$reminderTime に、その日の $dailyN問をお届けします。\n通知を切っても、アプリは使えます。',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: ZenColors.inkSub,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ZenPrimaryButton(
                    label: '許可する',
                    onPressed: () => _finish(context, enabled: true),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      onPressed: () => _finish(context, enabled: false),
                      child: const Text(
                        'あとで',
                        style: TextStyle(fontSize: 13, color: ZenColors.inkSub),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
