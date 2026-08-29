import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/database/app_database.dart';
import '../../providers/app_state.dart';
import '../../widgets/zen_widgets.dart';
import '../commerce/exam_selector_screen.dart';
import '../commerce/paywall_screen.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'legal_text_screen.dart';
import 'review_screen.dart';

/// 設定 (ZenSettings)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _onTabTap(BuildContext context, String key) {
    if (key == 'settings') return;
    Widget screen;
    switch (key) {
      case 'home':
        screen = const HomeScreen();
        break;
      case 'calendar':
        screen = const CalendarScreen();
        break;
      case 'review':
        screen = const ReviewScreen();
        break;
      default:
        return;
    }
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  Future<String?> _showTimePickerFor(
    BuildContext context,
    String currentTime,
  ) async {
    final parts = currentTime.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 8,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 15,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: ZenColors.accent),
          ),
          child: child!,
        );
      },
    );
    if (picked == null) return null;
    final hh = picked.hour.toString().padLeft(2, '0');
    final mm = picked.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> _addReminder(BuildContext context, AppState appState) async {
    final time = await _showTimePickerFor(context, '08:15');
    if (time != null) {
      await appState.addReminder(time);
    }
  }

  Future<void> _editReminderTime(
    BuildContext context,
    AppState appState,
    Reminder reminder,
  ) async {
    final time = await _showTimePickerFor(context, reminder.time);
    if (time != null) {
      await appState.updateReminderTime(reminder.id, time);
    }
  }

  Future<void> _pickExamType(BuildContext context, AppState appState) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: ZenColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: ZenColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                _examTypeTile(
                  context,
                  value: 'type1',
                  label: '第1種 衛生管理者',
                  sub: '有害業務あり · 1日9問',
                  current: appState.examType,
                ),
                _examTypeTile(
                  context,
                  value: 'type2',
                  label: '第2種 衛生管理者',
                  sub: '有害業務なし · 1日6問',
                  current: appState.examType,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null && selected != appState.examType) {
      await appState.setExamType(selected);
    }
  }

  Widget _examTypeTile(
    BuildContext context, {
    required String value,
    required String label,
    required String sub,
    required String current,
  }) {
    final isSel = value == current;
    return ListTile(
      onTap: () => Navigator.of(context).pop(value),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isSel ? ZenColors.accent : ZenColors.ink,
        ),
      ),
      subtitle: Text(
        sub,
        style: const TextStyle(fontSize: 12, color: ZenColors.inkSub),
      ),
      trailing: isSel
          ? const Icon(Icons.check_circle, color: ZenColors.accent)
          : null,
    );
  }

  Future<void> _pickFontSize(BuildContext context, AppState appState) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: ZenColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        const options = [
          (value: 'small', label: '小'),
          (value: 'medium', label: '標準'),
          (value: 'large', label: '大'),
        ];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: ZenColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ...options.map((opt) {
                  final isSel = opt.value == appState.fontSize;
                  return ListTile(
                    onTap: () => Navigator.of(context).pop(opt.value),
                    title: Text(
                      opt.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isSel ? ZenColors.accent : ZenColors.ink,
                      ),
                    ),
                    trailing: isSel
                        ? const Icon(
                            Icons.check_circle,
                            color: ZenColors.accent,
                          )
                        : null,
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null && selected != appState.fontSize) {
      await appState.setFontSize(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final examTypeLabel = appState.examType == 'type1' ? '第1種' : '第2種';
        final fontSizeLabel = switch (appState.fontSize) {
          'small' => '小',
          'large' => '大',
          _ => '標準',
        };

        return Scaffold(
          backgroundColor: ZenColors.bg,
          body: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SETTINGS',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 3.2,
                            color: ZenColors.inkMute,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '設 定',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: ZenColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _sectionLabel('学習'),
                      _switchRow(
                        label: '通知',
                        value: appState.notificationsEnabled,
                        onChanged: (v) => appState.setNotificationsEnabled(v),
                      ),
                      _reminderSectionHeader(context, appState),
                      ...appState.reminders.map(
                        (r) => _reminderRow(context, appState, r),
                      ),
                      if (appState.reminders.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'リマインダーが設定されていません',
                            style: TextStyle(
                              fontSize: 12,
                              color: ZenColors.inkMute,
                            ),
                          ),
                        ),
                      _row(
                        context,
                        label: '試験区分',
                        value: examTypeLabel,
                        onTap: () => _pickExamType(context, appState),
                      ),
                      _row(
                        context,
                        label: '解いている試験',
                        value: '',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ExamSelectorScreen(),
                          ),
                        ),
                      ),
                      _sectionLabel('外観'),
                      _row(
                        context,
                        label: 'フォントサイズ',
                        value: fontSizeLabel,
                        onTap: () => _pickFontSize(context, appState),
                      ),
                      _sectionLabel('購入について'),
                      _row(
                        context,
                        label: '購入プラン',
                        value: appState.purchased ? '買い切り版 購入済み' : '無料版',
                        onTap: appState.purchased
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const PaywallScreen(),
                                ),
                              ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4, left: 4),
                        child: Text(
                          '本アプリは買い切り課金制です。\nサブスクリプション(自動更新の定期課金)はありません。\n無料版には学習の妨げにならない範囲の広告(バナー)が表示されます。買い切り購入後は広告が完全に非表示になります。',
                          style: TextStyle(
                            fontSize: 11,
                            color: ZenColors.inkMute,
                            height: 1.6,
                          ),
                        ),
                      ),
                      _sectionLabel(''),
                      _row(
                        context,
                        label: '利用規約',
                        value: '',
                        onTap: () => openLegalUrl(
                          context,
                          url: kTermsOfServiceUrl,
                          title: '利用規約',
                          fallbackBody: kTermsOfServiceText,
                        ),
                      ),
                      _row(
                        context,
                        label: 'プライバシー',
                        value: '',
                        onTap: () => openLegalUrl(
                          context,
                          url: kPrivacyPolicyUrl,
                          title: 'プライバシーポリシー',
                          fallbackBody: kPrivacyPolicyText,
                        ),
                      ),
                      _row(
                        context,
                        label: 'このアプリについて',
                        value: 'v1.0.0',
                        onTap: null,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                ZenBottomTab(
                  active: 'settings',
                  onTap: (key) => _onTabTap(context, key),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String label) {
    if (label.isEmpty) {
      return const SizedBox(height: 12);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          letterSpacing: 1.6,
          color: ZenColors.inkMute,
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required String label,
    required String value,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: ZenColors.line, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: ZenColors.ink),
            ),
            Row(
              children: [
                if (value.isNotEmpty)
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ZenColors.inkSub,
                    ),
                  ),
                if (onTap != null) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: ZenColors.inkMute,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _reminderSectionHeader(BuildContext context, AppState appState) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'リマインダー',
            style: TextStyle(
              fontSize: 12,
              color: ZenColors.inkSub,
              letterSpacing: 0.4,
            ),
          ),
          GestureDetector(
            onTap: () => _addReminder(context, appState),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 16, color: ZenColors.accent),
                SizedBox(width: 2),
                Text(
                  '追加',
                  style: TextStyle(
                    fontSize: 12,
                    color: ZenColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reminderRow(
    BuildContext context,
    AppState appState,
    Reminder reminder,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ZenColors.line, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _editReminderTime(context, appState, reminder),
              child: Row(
                children: [
                  Text(
                    reminder.time,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: reminder.enabled
                          ? ZenColors.ink
                          : ZenColors.inkMute,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: ZenColors.inkMute,
                  ),
                ],
              ),
            ),
          ),
          Switch(
            value: reminder.enabled,
            activeThumbColor: ZenColors.accent,
            onChanged: (v) => appState.setReminderEnabled(reminder.id, v),
          ),
          GestureDetector(
            onTap: () => appState.removeReminder(reminder.id),
            child: const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.close, size: 16, color: ZenColors.inkMute),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ZenColors.line, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: ZenColors.ink),
          ),
          Switch(
            value: value,
            activeThumbColor: ZenColors.accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
