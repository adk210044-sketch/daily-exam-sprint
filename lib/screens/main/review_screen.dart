import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/app_state.dart';
import '../../providers/quiz_session_provider.dart';
import '../../widgets/enso_circle.dart';
import '../../widgets/zen_widgets.dart';
import '../quiz/question_screen.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

/// 苦手復習 (ZenReview / ZenReviewEmpty) — 永久無料
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int missedCount = 0;
  Map<String, int> byCategory = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final appState = context.read<AppState>();
    final count = await appState.reviewRepo.getMissedCount();
    final byCat = await appState.reviewRepo.getMissedByCategory();
    if (!mounted) return;
    setState(() {
      missedCount = count;
      byCategory = byCat;
      loading = false;
    });
  }

  void _onTabTap(String key) {
    if (key == 'review') return;
    Widget screen;
    switch (key) {
      case 'home':
        screen = const HomeScreen();
        break;
      case 'calendar':
        screen = const CalendarScreen();
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

  Future<void> _startReview() async {
    final appState = context.read<AppState>();
    final quiz = context.read<QuizSessionProvider>();
    await quiz.startReview(purchased: appState.purchased);
    if (!mounted) return;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const QuestionScreen()));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: ZenColors.bg,
        body: Center(child: CircularProgressIndicator(color: ZenColors.accent)),
      );
    }

    if (missedCount == 0) {
      return Scaffold(
        backgroundColor: ZenColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REVIEW  ·  FOREVER FREE',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 3.2,
                        color: ZenColors.inkMute,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '苦手だけを、9問',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: ZenColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const EnsoCircle(
                                size: 180,
                                color: ZenColors.gold,
                                strokeBase: 9,
                              ),
                              const Text(
                                '◎',
                                style: TextStyle(
                                  fontSize: 48,
                                  color: ZenColors.gold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'お見事です',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2.0,
                            color: ZenColors.ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '今のところ、取りこぼしはありません。\n今日の9問に集中しましょう。',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: ZenColors.inkSub,
                            height: 1.9,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ZenPrimaryButton(
                          height: 52,
                          label: '今日の 9問へ',
                          onPressed: () => _onTabTap('home'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ZenBottomTab(active: 'review', onTap: _onTabTap),
            ],
          ),
        ),
      );
    }

    final categories = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REVIEW  ·  FOREVER FREE',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 3.2,
                              color: ZenColors.inkMute,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '苦手だけを、9問',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: ZenColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 28,
                        ),
                        decoration: BoxDecoration(
                          color: ZenColors.card,
                          borderRadius: BorderRadius.circular(
                            ZenColors.radiusCard,
                          ),
                          border: Border.all(color: ZenColors.line),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -40,
                              right: -40,
                              child: Opacity(
                                opacity: 0.4,
                                child: const EnsoCircle(
                                  size: 140,
                                  color: ZenColors.accent,
                                  strokeBase: 4,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'あなたが取りこぼした',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: ZenColors.inkSub,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$missedCount',
                                        style: const TextStyle(
                                          fontSize: 52,
                                          fontWeight: FontWeight.w200,
                                          letterSpacing: -1.5,
                                          color: ZenColors.ink,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '問',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: ZenColors.inkSub,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'この中から、あなたに合わせて 9問を\nランダムに選んで出題します。',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ZenColors.inkSub,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                ZenPrimaryButton(
                                  height: 52,
                                  label: '苦手 9問をはじめる',
                                  onPressed: _startReview,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                      child: Text(
                        '取りこぼしの内訳',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.6,
                          color: ZenColors.inkSub,
                        ),
                      ),
                    ),
                    ...categories.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ZenColors.catDotColor(e.key),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                e.key,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: ZenColors.ink,
                                ),
                              ),
                            ),
                            Text(
                              '${e.value} 問',
                              style: const TextStyle(
                                fontSize: 13,
                                color: ZenColors.inkSub,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            ZenBottomTab(active: 'review', onTap: _onTabTap),
          ],
        ),
      ),
    );
  }
}
