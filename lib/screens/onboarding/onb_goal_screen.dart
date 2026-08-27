import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/app_state.dart';
import '../../widgets/zen_widgets.dart';
import 'onb_notification_permission_screen.dart';
import 'onb_steps.dart';

/// 目標日設定 (ZenOnbGoal) — Step 5/6
class OnbGoalScreen extends StatefulWidget {
  const OnbGoalScreen({super.key});

  @override
  State<OnbGoalScreen> createState() => _OnbGoalScreenState();
}

class _OnbGoalScreenState extends State<OnbGoalScreen> {
  DateTime goalDate = DateTime.now().add(const Duration(days: 52));

  int get daysLeft => goalDate.difference(DateTime.now()).inDays.clamp(0, 9999);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: goalDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: ZenColors.accent,
            onPrimary: Colors.white,
            surface: ZenColors.card,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => goalDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final weekdayNames = ['月', '火', '水', '木', '金', '土', '日'];
    final dailyN = context.watch<AppState>().dailyQuestionCount;
    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const OnbSteps(current: 4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STEP 5 OF 6', style: ZenText.kicker()),
                    const SizedBox(height: 12),
                    const Text(
                      '試験日は、いつですか？',
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
                      '目標日を決めて、逆算しましょう。',
                      style: TextStyle(
                        fontSize: 13,
                        color: ZenColors.inkSub,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
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
                        child: Column(
                          children: [
                            Text(
                              '${goalDate.year}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: ZenColors.inkSub,
                                letterSpacing: 2.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${goalDate.month}',
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: -1.9,
                                    color: ZenColors.ink,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Text(
                                    '月',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: ZenColors.inkSub,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${goalDate.day}',
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: -1.9,
                                    color: ZenColors.ink,
                                  ),
                                ),
                                const Text(
                                  '日',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: ZenColors.inkSub,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${weekdayNames[goalDate.weekday - 1]} 曜 日',
                              style: const TextStyle(
                                fontSize: 12,
                                color: ZenColors.inkMute,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: ZenColors.accentSoft,
                        borderRadius: BorderRadius.circular(
                          ZenColors.radiusCard,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'あと',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: ZenColors.accentDeep,
                                  letterSpacing: 1.6,
                                ),
                              ),
                              const SizedBox(height: 3),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: -1,
                                    color: ZenColors.accentDeep,
                                  ),
                                  children: [
                                    TextSpan(text: '$daysLeft'),
                                    const TextSpan(
                                      text: '日',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: ZenColors.accent.withValues(alpha: 0.4),
                            margin: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          Column(
                            children: [
                              const Text(
                                '合計',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: ZenColors.accentDeep,
                                  letterSpacing: 1.6,
                                ),
                              ),
                              const SizedBox(height: 3),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: -1,
                                    color: ZenColors.accentDeep,
                                  ),
                                  children: [
                                    TextSpan(text: '${daysLeft * dailyN}'),
                                    const TextSpan(
                                      text: '問',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
              child: Column(
                children: [
                  ZenPrimaryButton(
                    label: 'この日を目標にする',
                    onPressed: () async {
                      await context.read<AppState>().setGoalDate(goalDate);
                      if (context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const OnbNotificationPermissionScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ZenTextLink(
                    label: 'まだ決めていない',
                    color: ZenColors.inkMute,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const OnbNotificationPermissionScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
