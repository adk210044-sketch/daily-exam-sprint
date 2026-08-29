import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/database/app_database.dart';
import '../../providers/app_state.dart';
import '../../providers/quiz_session_provider.dart';
import '../../widgets/ad_banner_widget.dart';
import '../../widgets/enso_circle.dart';
import '../../widgets/zen_widgets.dart';
import '../commerce/exam_selector_screen.dart';
import '../commerce/paywall_screen.dart';
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
  Map<int, int> _dayScores = {};
  Map<int, int> _dayAttempts = {};
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

    final dayScores = session != null
        ? await appState.examRepo.getBestScoresByDay(session.id)
        : <int, int>{};
    final dayAttempts = session != null
        ? await appState.examRepo.getAttemptCountsByDay(session.id)
        : <int, int>{};

    if (!mounted) return;
    setState(() {
      _currentSession = session;
      _dayScores = dayScores;
      _dayAttempts = dayAttempts;
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

  /// おかわり機能 (有料版限定): Day1-5の中から好きな回を選んで解き直せる。
  /// (Day6,7は弱点復習専用のため選択肢に出さない)
  /// 未購入ユーザーがタップした場合は購入誘導 (Paywall) を表示する。
  Future<void> _advanceEarly() async {
    final session = _currentSession;
    if (session == null) return;
    final appState = context.read<AppState>();

    if (!appState.purchased) {
      // 未購入ユーザー: 購入誘導としてPaywallへ
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const PaywallScreen()));
      if (!mounted) return;
      await _load();
      return;
    }

    // 購入済みユーザー: この試験回の Day1-5 (過去・未来問わず全て) から選んで解ける
    final availableDays = List.generate(5, (i) => i + 1);

    final selectedDay = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ZenColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'おかわり · どの回を解く?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'この試験回のDay1〜5から好きな回を選んで、\n(未挑戦の回も含めて)いつでも解けます。',
              style: TextStyle(
                fontSize: 12,
                color: ZenColors.inkSub,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableDays.map((d) {
                final score = _dayScores[d];
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(d),
                  child: Container(
                    width: 64,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: ZenColors.accentSoft,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ZenColors.accent, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Day$d',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ZenColors.accentDeep,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          score != null ? '$score%' : '-',
                          style: const TextStyle(
                            fontSize: 10,
                            color: ZenColors.inkSub,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'キャンセル',
              style: TextStyle(color: ZenColors.inkMute),
            ),
          ),
        ],
      ),
    );
    if (selectedDay == null) return;
    if (!mounted) return;

    final quiz = context.read<QuizSessionProvider>();
    await quiz.startReplay(examSessionId: session.id, replayDay: selectedDay);
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
                                  mainAxisSize: MainAxisSize.min,
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
                                label: '試験を選ぶ',
                                color: ZenColors.accent,
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ExamSelectorScreen(),
                                  ),
                                ),
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
                                  Builder(
                                    builder: (context) {
                                      final purchased = context
                                          .watch<AppState>()
                                          .purchased;
                                      return Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          GestureDetector(
                                            onTap: _advanceEarly,
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: purchased
                                                    ? ZenColors.accentSoft
                                                    : ZenColors.bgSub,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      ZenColors.radiusBtn,
                                                    ),
                                                border: purchased
                                                    ? null
                                                    : Border.all(
                                                        color: ZenColors.line,
                                                      ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    purchased
                                                        ? Icons.replay
                                                        : Icons.lock_outline,
                                                    size: 15,
                                                    color: purchased
                                                        ? ZenColors.accentDeep
                                                        : ZenColors.inkMute,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    purchased
                                                        ? 'おかわり · Day1〜5から好きな回を解く'
                                                        : 'おかわり · Day1〜5から好きな回を選べます(有料版)',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: purchased
                                                          ? ZenColors.accentDeep
                                                          : ZenColors.inkMute,
                                                      letterSpacing: 0.4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    '前回 · ${session.avgScore ?? '-'} / 100',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: ZenColors.inkMute,
                                    ),
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
                        dayScores: _dayScores,
                        dayAttempts: _dayAttempts,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const AdBannerWidget(),
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

/// 今回の試験サイクル (Day1-7) の各日スコアを表示する週間進捗バー。
/// 曜日 (月〜日) ではなく、試験開始日を起点とした Day1〜7 で表示する
/// (アプリはどの曜日からでも開始できるため)。
class _ScoreHistoryRow extends StatelessWidget {
  final Map<int, int> dayScores;
  final Map<int, int> dayAttempts;

  const _ScoreHistoryRow({
    required this.dayScores,
    this.dayAttempts = const {},
  });

  @override
  Widget build(BuildContext context) {
    final scored = dayScores.values.toList();
    final avg = scored.isEmpty
        ? 0
        : (scored.reduce((a, b) => a + b) / scored.length).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '今回の試験 · 平均 $avg%',
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 1.6,
            color: ZenColors.inkSub,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(7, (i) {
            final day = i + 1;
            final score = dayScores[day];
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 22,
                      child: Center(
                        child: Text(
                          score != null ? '$score%' : '-',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: score == null
                                ? ZenColors.inkMute
                                : (score == 100
                                      ? ZenColors.gold
                                      : ZenColors.ink),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 22,
                      child: Center(
                        child: Text(
                          'Day$day',
                          style: const TextStyle(
                            fontSize: 9,
                            color: ZenColors.inkMute,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      height: 14,
                      child: Center(
                        child: Text(
                          (dayAttempts[day] ?? 0) > 0
                              ? '${dayAttempts[day]}回挑戦'
                              : '',
                          style: const TextStyle(
                            fontSize: 8,
                            color: ZenColors.inkMute,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
