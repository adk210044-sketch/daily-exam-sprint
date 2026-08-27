import 'package:flutter/material.dart';

import '../../core/theme/zen_tokens.dart';
import '../../widgets/enso_circle.dart';
import '../../widgets/zen_widgets.dart';
import '../main/home_screen.dart';

/// 購入完了 (ZenPurchased) — Thanks. 購入成功のcelebration。
class PurchasedScreen extends StatelessWidget {
  const PurchasedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 40, 28, 0),
                  child: Column(
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
                              strokeBase: 10,
                              animate: true,
                              pulse: true,
                            ),
                            Container(
                              width: 84,
                              height: 84,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ZenColors.card,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 44,
                                color: ZenColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'ありがとうございます',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                          color: ZenColors.ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '買い切り購入が完了しました。\n全11回分の過去問を、いつでも解けます。',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: ZenColors.inkSub,
                          height: 1.75,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          _statCard(value: '800', unit: '問', label: '解放'),
                          const SizedBox(width: 10),
                          _statCard(value: '7', unit: '年分', label: '対応'),
                          const SizedBox(width: 10),
                          _statCard(value: '∞', unit: '', label: '苦手復習 無料'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: ZenPrimaryButton(
                label: 'ホームに戻る',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String value,
    required String unit,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: ZenColors.card,
          border: Border.all(color: ZenColors.line),
          borderRadius: BorderRadius.circular(ZenColors.radiusCard),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                    color: ZenColors.accent,
                    letterSpacing: -0.5,
                  ),
                ),
                if (unit.isNotEmpty)
                  Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 11,
                      color: ZenColors.inkSub,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: ZenColors.inkMute,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
