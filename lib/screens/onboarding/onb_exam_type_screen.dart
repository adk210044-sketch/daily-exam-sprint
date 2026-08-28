import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/app_state.dart';
import '../../widgets/zen_widgets.dart';
import 'onb_reminder_screen.dart';
import 'onb_steps.dart';

/// 試験区分選択 (ZenOnbExamType) — Step 3/5
class OnbExamTypeScreen extends StatefulWidget {
  const OnbExamTypeScreen({super.key});

  @override
  State<OnbExamTypeScreen> createState() => _OnbExamTypeScreenState();
}

class _OnbExamTypeScreenState extends State<OnbExamTypeScreen> {
  String sel = 'type1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const OnbSteps(current: 2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 48, 32, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STEP 3 OF 5', style: ZenText.kicker()),
                    const SizedBox(height: 12),
                    const Text(
                      'どちらの\n試験を受けますか？',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        letterSpacing: 0.56,
                        color: ZenColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'あとで設定から変更できます。',
                      style: TextStyle(
                        fontSize: 13,
                        color: ZenColors.inkSub,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _examOption(
                      key: 'type1',
                      label: '第 1 種 衛生管理者',
                      sub: '有害業務あり · 44問 · 3時間',
                      dailyN: 9,
                    ),
                    const SizedBox(height: 12),
                    _examOption(
                      key: 'type2',
                      label: '第 2 種 衛生管理者',
                      sub: '有害業務なし · 30問 · 3時間',
                      dailyN: 6,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: ZenPrimaryButton(
                label: '次へ',
                onPressed: () async {
                  await context.read<AppState>().setExamType(sel);
                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const OnbReminderScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _examOption({
    required String key,
    required String label,
    required String sub,
    required int dailyN,
  }) {
    final isSel = sel == key;
    return GestureDetector(
      onTap: () => setState(() => sel = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        decoration: BoxDecoration(
          color: isSel ? ZenColors.accentSoft : ZenColors.card,
          borderRadius: BorderRadius.circular(ZenColors.radiusCard),
          border: Border.all(
            color: isSel ? ZenColors.accent : ZenColors.line,
            width: isSel ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSel ? ZenColors.accentDeep : ZenColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSel ? ZenColors.accentDeep : ZenColors.inkSub,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isSel ? ZenColors.accent : ZenColors.line,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '1日 $dailyN 問',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: isSel ? ZenColors.accentInk : ZenColors.inkSub,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSel ? ZenColors.accent : Colors.transparent,
                border: Border.all(
                  color: isSel ? ZenColors.accent : ZenColors.line,
                  width: 1.5,
                ),
              ),
              child: isSel
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: ZenColors.accentInk,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
