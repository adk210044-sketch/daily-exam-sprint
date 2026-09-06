import 'package:flutter/material.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/database/app_database.dart';
import '../../widgets/enso_circle.dart';
import '../../widgets/zen_widgets.dart';
import '../commerce/exam_selector_screen.dart';
import 'calendar_screen.dart';
import 'review_screen.dart';
import 'settings_screen.dart';

/// 「2週目の初日 (Day8)」に表示するプロンプト画面 (ZenNextExamPrompt)。
///
/// 1つの試験回は Day1-7 (7日間) で完走する設計のため、完走した翌日に
/// アプリを開くと「Day8」に相当するタイミングになる。この時点では
/// 同じ試験回を繰り返すのではなく、ユーザー自身に次の試験回を選んで
/// もらう必要があるため、通常のホーム画面の代わりにこの画面を表示する。
class NextExamPromptScreen extends StatelessWidget {
  final ExamSession session;
  final VoidCallback onReload;

  const NextExamPromptScreen({
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

  Future<void> _goToExamSelector(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ExamSelectorScreen()));
    onReload();
  }

  @override
  Widget build(BuildContext context) {
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
                                'WEEK 1 完走',
                                style: ZenText.kicker(
                                  letterSpacing: 3.0,
                                  color: ZenColors.gold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '1週間、お疲れさまでした。',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
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
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
                        decoration: BoxDecoration(
                          color: ZenColors.card,
                          borderRadius: BorderRadius.circular(
                            ZenColors.radiusCard,
                          ),
                          boxShadow: ZenShadows.card,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const EnsoCircle(
                                    size: 140,
                                    color: ZenColors.gold,
                                    strokeBase: 8,
                                    animate: true,
                                  ),
                                  const Icon(
                                    Icons.emoji_events_outlined,
                                    size: 44,
                                    color: ZenColors.gold,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              session.label,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: ZenColors.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '平均${session.avgScore ?? 0}% · ◎ ×${session.hanamaruDays}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: ZenColors.inkSub,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'この試験回は完走しました。\n次の試験回を選んで、新しい1週間をはじめましょう。',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: ZenColors.inkSub,
                                height: 1.8,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ZenPrimaryButton(
                              label: '次の試験へ進む',
                              onPressed: () => _goToExamSelector(context),
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
