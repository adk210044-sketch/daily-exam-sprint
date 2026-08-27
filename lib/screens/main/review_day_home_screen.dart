import 'package:flutter/material.dart';
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

/// Home 復習日版 (ZenReviewDayHome) — Day 6/7 用
class ReviewDayHomeScreen extends StatelessWidget {
  final ExamSession session;
  final VoidCallback onReload;

  const ReviewDayHomeScreen({
    super.key,
    required this.session,
    required this.onReload,
  });

  void _onTabTap(BuildContext context, String key) {
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

  Future<void> _startReview(BuildContext context) async {
    final quiz = context.read<QuizSessionProvider>();
    await quiz.startDaily(session.id);
    if (!context.mounted) return;
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const QuestionScreen()));
    onReload();
  }

  @override
  Widget build(BuildContext context) {
    final day = session.day;
    final today = DateTime.now();
    final dateStr = '${today.month}月${today.day}日';
    final dailyN = context.watch<AppState>().dailyQuestionCount;

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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REVIEW DAY  ·  $dateStr',
                                style: const TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 3.2,
                                  color: ZenColors.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '今週のミスを、もう一度。',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: ZenColors.ink,
                                ),
                              ),
                            ],
                          ),
                          Container(
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'WEEK 1  ·  DAY $day / 7',
                                style: const TextStyle(
                                  fontSize: 11,
                                  letterSpacing: 1.6,
                                  color: ZenColors.inkSub,
                                ),
                              ),
                              Text(
                                '◎ ×${session.hanamaruDays} · 平均${session.avgScore ?? 0}%',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: ZenColors.gold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ProgressDotsRow(current: day, hanamaruDays: const []),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
                        decoration: BoxDecoration(
                          color: ZenColors.card,
                          borderRadius: BorderRadius.circular(
                            ZenColors.radiusCard,
                          ),
                          boxShadow: ZenShadows.card,
                          border: Border.all(color: ZenColors.gold, width: 1.5),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -80,
                              top: -70,
                              child: Opacity(
                                opacity: 0.14,
                                child: const EnsoCircle(
                                  size: 220,
                                  color: ZenColors.gold,
                                  strokeBase: 7,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ZenColors.gold,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'REVIEW DAY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text('$dailyN', style: ZenText.bigNumber()),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '問',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: ZenColors.inkSub,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'ミス率TOP',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: ZenColors.inkSub,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Day 1〜5 で間違えた問題のうち、\nミス率が高かった $dailyN問を選びました。',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: ZenColors.inkSub,
                                    height: 1.75,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                ZenPrimaryButton(
                                  label: '復習の $dailyN問をはじめる',
                                  onPressed: () => _startReview(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ZenBottomTab(
              active: 'home',
              onTap: (key) => _onTabTap(context, key),
            ),
          ],
        ),
      ),
    );
  }
}
