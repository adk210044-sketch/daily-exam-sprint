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

/// カレンダー (ZenCalendar) — 月間カレンダー
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

/// 正答率から表示シンボルを判定する。
/// 満点(100%)=◎ / 60%以上=○ / 40%以上=△ / 40%未満=なし
String? _tierSymbolFor(CalendarMark? mark) {
  if (mark == null) return null;
  if (mark.hanamaru || mark.score >= 100) return '◎';
  if (mark.score >= 60) return '○';
  if (mark.score >= 40) return '△';
  return null;
}

Color _tierColorFor(String symbol) {
  switch (symbol) {
    case '◎':
      return ZenColors.gold;
    case '○':
      return ZenColors.accent;
    case '△':
      return ZenColors.wrong;
    default:
      return ZenColors.inkMute;
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime viewMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  Map<String, CalendarMark> marksByDate = {};
  Map<String, ExamSession> sessionsById = {};
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
    final sessions = await appState.examRepo.getAllSessions();
    final s = await appState.examRepo.getStreakDays();
    if (!mounted) return;
    setState(() {
      marksByDate = {
        for (final m in marks) DateFormat('yyyy-MM-dd').format(m.date): m,
      };
      sessionsById = {for (final sess in sessions) sess.id: sess};
      streak = s;
      loading = false;
    });
  }

  /// 週(7日分のセル)の中から、取り組みを開始した曜日インデックス(0=日〜6=土)と
  /// 試験回の短縮ラベル(例: "R6.10")を取得する。
  /// 複数の回が混在する場合は最初に見つかったものを表示する。
  ({String shortLabel, int startIndex})? _weekExamInfo(List<int?> weekDays) {
    for (var i = 0; i < weekDays.length; i++) {
      final d = weekDays[i];
      if (d == null) continue;
      final date = DateTime(viewMonth.year, viewMonth.month, d);
      final mark = marksByDate[DateFormat('yyyy-MM-dd').format(date)];
      if (mark?.sessionId != null) {
        final session = sessionsById[mark!.sessionId];
        if (session != null) {
          return (shortLabel: _shortExamLabel(session.year), startIndex: i);
        }
      }
    }
    return null;
  }

  /// "令和6年10月公表" -> "R6.10" のように短縮する。
  String _shortExamLabel(String year) {
    final m = RegExp(r'令和(\d+)年(\d+)月').firstMatch(year);
    if (m == null) return year;
    return 'R${m.group(1)}.${m.group(2)}';
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

    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
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
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMMM').format(viewMonth),
                        style: const TextStyle(
                          fontSize: 26,
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
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '連続 ',
                        style: TextStyle(
                          fontSize: 16,
                          color: ZenColors.inkSub,
                        ),
                      ),
                      TextSpan(
                        text: '$streak',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w200,
                          letterSpacing: -1.5,
                          color: ZenColors.ink,
                        ),
                      ),
                      const TextSpan(
                        text: ' 日',
                        style: TextStyle(
                          fontSize: 16,
                          color: ZenColors.inkSub,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(color: ZenColors.accent),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
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
                          Column(
                            children: List.generate(cells.length ~/ 7, (
                              weekIdx,
                            ) {
                              final weekDays = cells.sublist(
                                weekIdx * 7,
                                weekIdx * 7 + 7,
                              );
                              final examInfo = _weekExamInfo(weekDays);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: weekDays.map((d) {
                                        return Expanded(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: _buildDayCell(
                                              context,
                                              d,
                                              today,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 2,
                                        bottom: 2,
                                      ),
                                      child: Row(
                                        children: List.generate(7, (i) {
                                          final showLine = examInfo != null &&
                                              i >= examInfo.startIndex;
                                          final showLabel = examInfo != null &&
                                              i == examInfo.startIndex;
                                          return Expanded(
                                            child: SizedBox(
                                              height: 14,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  if (showLine)
                                                    Container(
                                                      height: 7,
                                                      color: const Color(
                                                        0xFFC8C8C0,
                                                      ),
                                                    ),
                                                  if (showLabel)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 3,
                                                          ),
                                                      color: ZenColors.bg,
                                                      child: Text(
                                                        examInfo.shortLabel,
                                                        style: const TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w700,
                                                          color: ZenColors
                                                              .inkSub,
                                                          letterSpacing: 0.2,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Wrap(
                spacing: 14,
                runSpacing: 6,
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
                  _legend(
                    const Text(
                      '◎',
                      style: TextStyle(
                        color: ZenColors.gold,
                        fontSize: 14,
                        height: 1.0,
                      ),
                    ),
                    '満点(100%)',
                  ),
                  _legend(
                    Text(
                      '○',
                      style: TextStyle(
                        color: _tierColorFor('○'),
                        fontSize: 14,
                        height: 1.0,
                      ),
                    ),
                    '60%以上',
                  ),
                  _legend(
                    Text(
                      '△',
                      style: TextStyle(
                        color: _tierColorFor('△'),
                        fontSize: 14,
                        height: 1.0,
                      ),
                    ),
                    '40%以上',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(
                '※ 日付下の数字は正答率(%)を示します',
                style: TextStyle(fontSize: 10, color: ZenColors.inkMute),
              ),
            ),
            ZenBottomTab(active: 'calendar', onTap: _onTabTap),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, int? d, DateTime today) {
    if (d == null) return const SizedBox();
    final date = DateTime(viewMonth.year, viewMonth.month, d);
    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    final isFuture = date.isAfter(
      DateTime(today.year, today.month, today.day),
    );
    final isPast =
        !isToday &&
        date.isBefore(DateTime(today.year, today.month, today.day));
    final mark = marksByDate[DateFormat('yyyy-MM-dd').format(date)];
    final tier = _tierSymbolFor(mark);

    return Stack(
      alignment: Alignment.center,
      children: [
        if (isToday)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ZenColors.accentSoft,
              border: Border.all(color: ZenColors.accent, width: 1.5),
            ),
          ),
        if (tier == '◎')
          const EnsoCircle(size: 36, color: ZenColors.gold, strokeBase: 2.5),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$d',
              style: TextStyle(
                fontSize: 13,
                height: 1.0,
                letterSpacing: -0.3,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                color: isToday
                    ? ZenColors.accentDeep
                    : (isFuture || isPast)
                    ? ZenColors.inkMute
                    : ZenColors.ink,
              ),
            ),
            if (mark != null && tier != '◎')
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text.rich(
                  TextSpan(
                    children: [
                      if (tier != null)
                        TextSpan(
                          text: '$tier ',
                          style: TextStyle(
                            fontSize: 8,
                            height: 1.0,
                            color: _tierColorFor(tier),
                          ),
                        ),
                      TextSpan(
                        text: '${mark.score}%',
                        style: const TextStyle(
                          fontSize: 7,
                          height: 1.0,
                          color: ZenColors.inkMute,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
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
        SizedBox(height: 14, width: 14, child: Center(child: indicator)),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: ZenColors.inkMute),
        ),
      ],
    );
  }
}
