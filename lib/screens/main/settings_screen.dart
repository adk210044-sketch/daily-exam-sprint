import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/app_state.dart';
import '../../widgets/zen_widgets.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final settings = appState.settings;
        final examTypeLabel = appState.examType == 'type1' ? '第1種' : '第2種';

        final rows = <_SettingsRow>[
          _SettingsRow(
            label: 'リマインダー',
            value: settings?.reminderTime ?? '08:15',
            section: '学習',
          ),
          _SettingsRow(label: '試験区分', value: examTypeLabel),
          const _SettingsRow(label: '通知サウンド', value: '無音'),
          const _SettingsRow(label: 'フォントサイズ', value: '標準', section: '外観'),
          const _SettingsRow(label: '解いている試験', value: '', section: '学習内容'),
          _SettingsRow(
            label: 'サブスク管理',
            value: appState.purchased ? '購入済み' : '未購入',
            section: 'アカウント',
          ),
          const _SettingsRow(label: '利用規約', value: ''),
          const _SettingsRow(label: 'プライバシー', value: ''),
          const _SettingsRow(label: 'このアプリについて', value: 'v1.0.0'),
        ];

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
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: rows.length,
                    itemBuilder: (context, i) {
                      final row = rows[i];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (row.section != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 8,
                                left: 4,
                              ),
                              child: Text(
                                row.section!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.6,
                                  color: ZenColors.inkMute,
                                ),
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 4,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: ZenColors.line,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  row.label,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: ZenColors.ink,
                                  ),
                                ),
                                if (row.value.isNotEmpty)
                                  Text(
                                    row.value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: ZenColors.inkSub,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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
}

class _SettingsRow {
  final String label;
  final String value;
  final String? section;
  const _SettingsRow({required this.label, required this.value, this.section});
}
