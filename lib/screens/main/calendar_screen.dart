import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/database/app_database.dart';
import '../../providers/app_state.dart';
import '../../widgets/enso_circle.dart';
import '../../widgets/zen_widgets.dart';
import 'home_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';

/// 暦 (ZenCalendar) — 月間カレンダー
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime viewMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  Map<String, CalendarMark> marksByDate = {};
  int streak = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final appState = context.read<AppState>();
    final marks = await appState.examRepo.getMarksForMonth(
      viewMonth.year,
      viewMonth.month,
    );
    final s = await appState.examRepo.getStreakDays();
    if (!mounted) return;
    setState(() {
      marksByDate = {
        for (final m in marks) DateFormat('yyyy-MM-dd').format(m.date): m,
      };
      streak = s;
      loading = false;
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      viewMonth = DateTime(viewMonth.year, viewMonth.month + delta, 1);
      loading = true;
    });
    _load();
  }

  void _onTabTap(String key) {
    if (key == 'calendar') return;
    Widget screen;
    switch (key) {
      case 'home':
        screen = const HomeScreen();
        break;
      case 'review':
        screen = const ReviewScreen();
        break;
      case 'settings':
        screen = const SettingsScreen();
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
    final today = DateTime.now();
    final firstWeekday =
        DateTime(viewMonth.year, viewMonth.month, 1).weekday % 7; // 0=Sun
    final daysInMonth = DateTime(viewMonth.year, viewMonth.month + 1, 0).day;

    final cells = <int?>[];
    for (var i = 0; i < firstWeekday; i++) {
      cells.add(null);
    }
    for (var d = 1; d <= daysInMonth; d++) {
      cells.add(d);
    }
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    final hanamaruCount = marksByDate.values.where((m) => m.hanamaru).length;

    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${viewMonth.year}',
                        style: const TextStyle(
                          fontSize: 10,
                          letterSpacing: 3.2,
                          color: ZenColors.inkMute,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('MMMM').format(viewMonth),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                          color: ZenColors.ink,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _navBtn(Icons.chevron_left, () => _changeMonth(-1)),
                      const SizedBox(width: 8),
                      _navBtn(Icons.chevron_right, () => _changeMonth(1)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '連続',
                        style: TextStyle(
                          fontSize: 10,
                          color: ZenColors.inkSub,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$streak',
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w200,
                                letterSpacing: -1.5,
                                color: ZenColors.ink,
                              ),
                            ),
                            const TextSpan(
                              text: '日',
                              style: TextStyle(
                                fontSize: 18,
                                color: ZenColors.inkSub,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '今月の ◎',
                        style: TextStyle(
                          fontSize: 10,
                          color: ZenColors.inkSub,
                          letterSpacing: 1.6,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '◎' * hanamaruCount.clamp(0, 5),
                        style: const TextStyle(
                          fontSize: 22,
                          color: ZenColors.gold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(color: ZenColors.accent),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                      child: Column(
                        children: [
                          Row(
                            children: ['日', '月', '火', '水', '木', '金', '土']
                                .map(
                                  (w) => Expanded(
                                    child: Center(
                                      child: Text(
                                        w,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: (w == '日' || w == '土')
                                              ? ZenColors.inkSub
                                              : ZenColors.inkMute,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 6),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  childAspectRatio: 1,
                                ),
                            itemCount: cells.length,
                            itemBuilder: (context, i) {
                              final d = cells[i];
                              if (d == null) return const SizedBox();
                              final date = DateTime(
                                viewMonth.year,
                                viewMonth.month,
                                d,
                              );
                              final isToday =
                                  date.year == today.year &&
                                  date.month == today.month &&
                                  date.day == today.day;
                              final isFuture = date.isAfter(
                                DateTime(today.year, today.month, today.day),
                              );
                              final mark =
                                  marksByDate[DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(date)];
                              final isHanamaru = mark?.hanamaru ?? false;

                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (isToday)
                                    Container(
                                      margin: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ZenColors.accentSoft,
                                        border: Border.all(
                                          color: ZenColors.accent,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  if (isHanamaru)
                                    const EnsoCircle(
                                      size: 36,
                                      color: ZenColors.gold,
                                      strokeBase: 2.5,
                                    ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$d',
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: -0.3,
                                          fontWeight: isToday
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          color: isFuture
                                              ? ZenColors.inkMute
                                              : (isToday
                                                    ? ZenColors.accentDeep
                                                    : ZenColors.ink),
                                        ),
                                      ),
                                      if (mark != null && !isHanamaru)
                                        Text(
                                          '${mark.score}',
                                          style: const TextStyle(
                                            fontSize: 8,
                                            color: ZenColors.inkMute,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Row(
                children: [
                  _legend(
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ZenColors.accentSoft,
                        border: Border.all(color: ZenColors.accent),
                      ),
                    ),
                    '今日',
                  ),
                  const SizedBox(width: 16),
                  _legend(
                    const Text(
                      '◎',
                      style: TextStyle(color: ZenColors.gold, fontSize: 14),
                    ),
                    '満点',
                  ),
                  const SizedBox(width: 16),
                  _legend(
                    const Text(
                      '80%',
                      style: TextStyle(color: ZenColors.inkMute, fontSize: 11),
                    ),
                    '正答率',
                  ),
                ],
              ),
            ),
            ZenBottomTab(active: 'calendar', onTap: _onTabTap),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ZenColors.line, width: 0.5),
        ),
        child: Icon(icon, size: 18, color: ZenColors.inkSub),
      ),
    );
  }

  Widget _legend(Widget indicator, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: ZenColors.inkMute),
        ),
      ],
    );
  }
}
