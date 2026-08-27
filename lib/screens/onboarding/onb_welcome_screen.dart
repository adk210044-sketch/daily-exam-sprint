import 'package:flutter/material.dart';

import '../../core/theme/zen_tokens.dart';
import '../../widgets/enso_circle.dart';
import '../../widgets/zen_widgets.dart';
import 'onb_how_it_works_screen.dart';
import 'onb_steps.dart';

/// Welcome (ZenOnbWelcome) — Step 1/6
class OnbWelcomeScreen extends StatelessWidget {
  const OnbWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const OnbSteps(current: 0),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: EnsoCircle(
                        size: 120,
                        color: ZenColors.accent,
                        strokeBase: 5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text('STEP 1 OF 6', style: ZenText.kicker()),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 30,
                          height: 1.4,
                          letterSpacing: 0.6,
                          color: ZenColors.ink,
                        ),
                        children: const [
                          TextSpan(
                            text: 'ようこそ。\n',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: '1日、9問だけ。',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      '衛生管理者の過去問を、通勤の 5分で。\n迷わず、選ばず、リズムで解く。',
                      style: TextStyle(
                        fontSize: 14,
                        color: ZenColors.inkSub,
                        height: 1.9,
                      ),
                    ),
                    const Text(
                      'それだけで、合格に近づく設計です。',
                      style: TextStyle(
                        fontSize: 14,
                        color: ZenColors.inkMute,
                        height: 1.9,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: ZenColors.card,
                        borderRadius: BorderRadius.circular(
                          ZenColors.radiusCard,
                        ),
                        border: Border.all(color: ZenColors.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PROMISE',
                            style: ZenText.kicker(letterSpacing: 2.0),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '2週間 (14日) 無料。\n過去の試験2回分の全問題が使えます。',
                            style: TextStyle(
                              fontSize: 13,
                              color: ZenColors.ink,
                              height: 1.75,
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
                label: 'はじめる',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OnbHowItWorksScreen(),
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
}
