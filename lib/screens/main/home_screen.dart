import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/database/app_database.dart';
import '../../providers/app_state.dart';
import '../../providers/quiz_session_provider.dart';
import '../../widgets/enso_circle.dart';
import '../../widgets/zen_widgets.dart';
import '../quiz/question_screen.dart';
import 'calendar_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';
import 'review_day_home_screen.dart';

/// Home (ZenHome) — 1タップで「今日の9問」を開始
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ExamSession? _currentSession;
  List<CalendarMark> _recentMarks = [];
  int _streak = 0;
  bool _loading = true;
  bool _howOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final appState = context.read<AppState>();
    ExamSession? session;
    final currentId = appState.settings?.currentSessionId;

    if (currentId != null) {
      session = await appState.examRepo.getSession(currentId);
    }

    if (session == null) {
      // 直近試験 (isLatest かつ examType一致) から自動選択
      final all = await appState.examRepo.getAllSessions();
      final candidates =
          all
              .where((s) => s.examType == appState.examType && s.isLatest)
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      if (candidates.isNotEmpty) {
        session = candidates.first;
        await appState.setCurrentSession(session.id);
      }
    }

    final marks = await appState.examRepo.getRecentMarks(days: 7);
    final streak = await appState.examRepo.getStreakDays();

    if (!mounted) return;
    setState(() {
      _currentSession = session;
      _recentMarks = marks;
      _streak = streak;
      _loading = false;
    });
  }

  void _onTabTap(String key) {
    if (key == 'home') return;
    Widget screen;
    switch (key) {
      case 'calendar':
        screen = const CalendarScreen();
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
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _startToday() async {
    final session = _currentSession;
    if (session == null) return;

    final quiz = context.read<QuizSessionProvider>();
    await quiz.startDaily(session.id);
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const QuestionScreen()));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: ZenColors.bg,
        body: Center(child: CircularProgressIndicator(color: ZenColors.accent)),
      );
    }

    final session = _currentSession;
    if (session == null) {
      return Scaffold(
        backgroundColor: ZenColors.bg,
        body: const SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                '問題データを準備中です。しばらくお待ちください。',
                textAlign: TextAlign.center,
                style: TextStyle(color: ZenColors.inkSub),
              ),
            ),
          ),
        ),
      );
    }

    final day = session.day == 0 ? 1 : session.day;

    // Day 6-7 は復習日専用ホームへ
    if (day >= 6 && session.status != 'completed') {
      return ReviewDayHomeScreen(session: session, onReload: _load);
    }

    final today = DateTime.now();
    final dateStr = DateFormat('M月d日 E', 'ja_JP').format(today);
    final dailyN = context.read<AppState>().dailyQuestionCount;

    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _safeDailyLabel(dateStr),
                                style: ZenText.kicker(letterSpacing: 3.0),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '今日も、$dailyN問だけ。',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                  color: ZenColors.ink,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _onTabTap('settings'),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ZenColors.line,
                                  width: 0.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.settings_outlined,
                                size: 18,
                                color: ZenColors.inkSub,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Week progress
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _howOpen = !_howOpen),
                                child: Row(
                                  children: [
                                    Text(
                                      'WEEK 1  ·  DAY $day / 7',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        letterSpacing: 1.6,
                                        color: ZenColors.inkSub,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    AnimatedRotation(
                                      turns: _howOpen ? 0.5 : 0,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: const Icon(
                                        Icons.expand_more,
                                        size: 14,
                                        color: ZenColors.accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ZenTextLink(
                                label: 'カレンダーを見る',
                                color: ZenColors.accent,
                                onPressed: () => _onTabTap('calendar'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ProgressDotsRow(current: day, hanamaruDays: const []),
                          if (_howOpen)
                            Container(
                              margin: const EdgeInsets.only(top: 14),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: ZenColors.card,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: ZenColors.line),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(7, (i) {
                                      final d = i + 1;
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 3,
                                        ),
                                        width: 20,
                                        height: 20,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: d >= 6
                                              ? ZenColors.gold
                                              : ZenColors.accent,
                                        ),
                                        child: Text(
                                          '$d',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 12),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: const TextSpan(
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: ZenColors.ink,
                                        height: 1.75,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Day 1-5',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ZenColors.accent,
                                          ),
                                        ),
                                        TextSpan(text: ' は新しい問題 · '),
                                        TextSpan(
                                          text: 'Day 6-7',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ZenColors.gold,
                                          ),
                                        ),
                                        TextSpan(text: ' は弱点復習'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    '1週間で、試験1回分を完走します。',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: ZenColors.inkMute,
                                      height: 1.7,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Hero card
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                      child: GestureDetector(
                        onTap: _startToday,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(26, 28, 26, 24),
                          decoration: BoxDecoration(
                            color: ZenColors.card,
                            borderRadius: BorderRadius.circular(
                              ZenColors.radiusCard,
                            ),
                            boxShadow: ZenShadows.card,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -70,
                                top: -80,
                                child: Opacity(
                                  opacity: 0.18,
                                  child: const EnsoCircle(
                                    size: 220,
                                    color: ZenColors.accent,
                                    strokeBase: 6,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '本日 · ${session.attempt + 1}回目の挑戦',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: ZenColors.inkSub,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const Text(
                                        '約 5 分',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: ZenColors.inkMute,
                                          letterSpacing: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '$dailyN',
                                        style: ZenText.bigNumber(),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        '問',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: ZenColors.inkSub,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ZenPrimaryButton(
                                    label: '今日の $dailyN問 をはじめる',
                                    onPressed: _startToday,
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '前回 · ${session.avgScore ?? '-'} / 100',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: ZenColors.inkMute,
                                        ),
                                      ),
                                      Text(
                                        '◎ × ${session.hanamaruDays}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: ZenColors.inkMute,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Score history
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                      child: _ScoreHistoryRow(
                        marks: _recentMarks,
                        streak: _streak,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ZenBottomTab(active: 'home', onTap: _onTabTap),
          ],
        ),
      ),
    );
  }

  String _safeDailyLabel(String dateStr) {
    final n = context.read<AppState>().dailyQuestionCount;
    return 'DAILY $n  ·  $dateStr';
  }
}

class _ScoreHistoryRow extends StatelessWidget {
  final List<CalendarMark> marks;
  final int streak;

  const _ScoreHistoryRow({required this.marks, required this.streak});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final byDate = <String, CalendarMark>{};
    for (final m in marks) {
      byDate[DateFormat('yyyy-MM-dd').format(m.date)] = m;
    }
    final weekdayLabels = ['月', '火', '水', '木', '金', '土', '日'];
    final days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
    final avg = marks.isEmpty
        ? 0
        : (marks.map((m) => m.score).reduce((a, b) => a + b) / marks.length)
              .round();
    final hanamaruCount = marks.where((m) => m.hanamaru).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'この 7日 · 平均 $avg%',
              style: const TextStyle(
                fontSize: 11,
                letterSpacing: 1.6,
                color: ZenColors.inkSub,
              ),
            ),
            Text(
              '◎ × $hanamaruCount',
              style: const TextStyle(
                fontSize: 11,
                color: ZenColors.gold,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final d = days[i];
              final isToday =
                  DateFormat('yyyy-MM-dd').format(d) ==
                  DateFormat('yyyy-MM-dd').format(today);
              final mark = byDate[DateFormat('yyyy-MM-dd').format(d)];
              final score = mark?.score;
              final h = score != null ? (score / 100) * 40 : 6.0;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (score == 100)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            '◎',
                            style: TextStyle(
                              fontSize: 12,
                              color: ZenColors.gold,
                            ),
                          ),
                        ),
                      Container(
                        height: h,
                        decoration: BoxDecoration(
                          color: isToday && score == null
                              ? Colors.transparent
                              : (score == 100
                                    ? ZenColors.gold
                                    : ZenColors.accent),
                          borderRadius: BorderRadius.circular(2),
                          border: isToday && score == null
                              ? Border.all(color: ZenColors.line, width: 1.5)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weekdayLabels[i],
                        style: TextStyle(
                          fontSize: 9,
                          color: isToday ? ZenColors.accent : ZenColors.inkMute,
                          fontWeight: isToday
                              ? FontWeight.w700
                              : FontWeight.w400,
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
    );
  }
}
