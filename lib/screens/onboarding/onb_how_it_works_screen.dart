import 'package:flutter/material.dart';

import '../../core/theme/zen_tokens.dart';
import '../../widgets/zen_widgets.dart';
import 'onb_exam_type_screen.dart';
import 'onb_steps.dart';

/// 1週間の使い方 (ZenOnbHowItWorks) — Step 2/6
class OnbHowItWorksScreen extends StatelessWidget {
  const OnbHowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const OnbSteps(current: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STEP 2 OF 6', style: ZenText.kicker()),
                    const SizedBox(height: 12),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 26,
                          height: 1.4,
                          letterSpacing: 0.5,
                          color: ZenColors.ink,
                        ),
                        children: [
                          TextSpan(
                            text: '1週間で、\n',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: '試験1回分を、完走する。',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Day 1-5 は新しい問題。\nDay 6-7 は、あなたが間違えた問題だけを復習。',
                      style: TextStyle(
                        fontSize: 13,
                        color: ZenColors.inkSub,
                        height: 1.75,
                      ),
                    ),
                    const SizedBox(height: 22),
                    // 7-dot rhythm visualization
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(7, (i) {
                        final d = i + 1;
                        final isReview = d >= 6;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isReview
                                      ? ZenColors.gold
                                      : ZenColors.accent,
                                ),
                                child: Text(
                                  '$d',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Day',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: ZenColors.inkMute,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _legendDot(ZenColors.accent, '新しい問題'),
                        const SizedBox(width: 20),
                        _legendDot(ZenColors.gold, '弱点復習'),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _scheduleCard(
                      dayLabel: '1-5',
                      badgeColor: ZenColors.accentSoft,
                      badgeTextColor: ZenColors.accentDeep,
                      title: '5日で、試験1回分を解く',
                      desc: '各分野からバランスよく 9問 / 日。\n満点まで、その日中は何度でも挑戦可。',
                      border: ZenColors.line,
                    ),
                    const SizedBox(height: 10),
                    _scheduleCard(
                      dayLabel: '6-7',
                      badgeColor: ZenColors.gold,
                      badgeTextColor: Colors.white,
                      title: '2日で、弱点を乗り越える',
                      desc: 'Day 1-5 のミス率TOP 9問を自動抽出。\n1周ごとに、確実に力がつく。',
                      border: ZenColors.gold.withValues(alpha: 0.27),
                      borderWidth: 1.5,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: ZenColors.accentSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '◎',
                            style: TextStyle(
                              fontSize: 16,
                              color: ZenColors.accent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 11,
                                  color: ZenColors.accentDeep,
                                  height: 1.7,
                                ),
                                children: [
                                  TextSpan(text: '満点を取れば、カレンダーに '),
                                  TextSpan(
                                    text: '花丸',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '。\n忙しくて解けない日があっても、いつでも取り戻せます。',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: ZenPrimaryButton(
                label: 'わかりました',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OnbExamTypeScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: ZenColors.inkSub,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  Widget _scheduleCard({
    required String dayLabel,
    required Color badgeColor,
    required Color badgeTextColor,
    required String title,
    required String desc,
    required Color border,
    double borderWidth = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: ZenColors.card,
        borderRadius: BorderRadius.circular(ZenColors.radiusCard),
        border: Border.all(color: border, width: borderWidth),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  'DAY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: badgeTextColor,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dayLabel,
                  style: TextStyle(
                    fontSize: 16,
                    color: badgeTextColor,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ZenColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11,
                    color: ZenColors.inkSub,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
