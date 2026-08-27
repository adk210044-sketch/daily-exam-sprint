import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/app_state.dart';
import '../../widgets/zen_widgets.dart';
import 'onb_goal_screen.dart';
import 'onb_steps.dart';

/// リマインダー設定 (ZenOnboarding) — Step 4/6 (プリセット4択 + カスタム時刻)
class OnbReminderScreen extends StatefulWidget {
  const OnbReminderScreen({super.key});

  @override
  State<OnbReminderScreen> createState() => _OnbReminderScreenState();
}

class _OnbReminderScreenState extends State<OnbReminderScreen> {
  static const presets = [
    (time: '07:00', label: '通勤前 · 朝の目覚めに'),
    (time: '08:15', label: '通勤中 · 満員電車のお供に'),
    (time: '12:30', label: 'ランチ後 · 3分の休憩に'),
    (time: '22:00', label: '就寝前 · 一日のしめくくりに'),
  ];

  String selected = '08:15';
  bool customOpen = false;
  int customH = 19;
  int customM = 30;

  bool get isPreset => presets.any((p) => p.time == selected);
  String get customTime =>
      '${customH.toString().padLeft(2, '0')}:${customM.toString().padLeft(2, '0')}';

  void pickPreset(String t) {
    setState(() {
      selected = t;
      customOpen = false;
    });
  }

  void commitCustom() {
    setState(() {
      selected = customTime;
      customOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const OnbSteps(current: 3),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('STEP 4 OF 6', style: ZenText.kicker()),
                    const SizedBox(height: 12),
                    const Text(
                      'いつ、9問を\n解きますか？',
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
                      'リマインダーで習慣化します。\nあとで変更できます。',
                      style: TextStyle(
                        fontSize: 13,
                        color: ZenColors.inkSub,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ...presets.map((opt) {
                      final isSel = opt.time == selected;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => pickPreset(opt.time),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? ZenColors.accentSoft
                                  : ZenColors.card,
                              border: Border.all(
                                color: isSel
                                    ? ZenColors.accent
                                    : ZenColors.line,
                                width: isSel ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                ZenColors.radiusCard,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  opt.time,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: isSel
                                        ? ZenColors.accentDeep
                                        : ZenColors.ink,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    opt.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSel
                                          ? ZenColors.accentDeep
                                          : ZenColors.inkSub,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSel
                                        ? ZenColors.accent
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSel
                                          ? ZenColors.accent
                                          : ZenColors.line,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: isSel
                                      ? const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: ZenColors.accentInk,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    // カスタム時刻セクション
                    Container(
                      decoration: BoxDecoration(
                        color: !isPreset
                            ? ZenColors.accentSoft
                            : ZenColors.card,
                        border: Border.all(
                          color: !isPreset ? ZenColors.accent : ZenColors.line,
                          width: !isPreset ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          ZenColors.radiusCard,
                        ),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                setState(() => customOpen = !customOpen),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    !isPreset ? selected : '--:--',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                      color: !isPreset
                                          ? ZenColors.accentDeep
                                          : ZenColors.ink,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '自分で時刻を決める',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: !isPreset
                                                ? ZenColors.accentDeep
                                                : ZenColors.inkSub,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          customOpen ? '下のダイヤルで設定' : 'タップして設定',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: ZenColors.inkMute,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: !isPreset
                                          ? ZenColors.accent
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: !isPreset
                                            ? ZenColors.accent
                                            : ZenColors.line,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: !isPreset
                                        ? const Icon(
                                            Icons.check,
                                            size: 12,
                                            color: ZenColors.accentInk,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (customOpen)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
                              child: Column(
                                children: [
                                  Container(height: 0.5, color: ZenColors.line),
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _TimeSpinner(
                                        value: customH,
                                        min: 0,
                                        max: 23,
                                        unit: '時',
                                        onChanged: (v) =>
                                            setState(() => customH = v),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 22),
                                        child: Text(
                                          ':',
                                          style: TextStyle(
                                            fontSize: 34,
                                            fontWeight: FontWeight.w200,
                                            color: ZenColors.inkMute,
                                          ),
                                        ),
                                      ),
                                      _TimeSpinner(
                                        value: customM,
                                        min: 0,
                                        max: 59,
                                        step: 5,
                                        unit: '分',
                                        onChanged: (v) =>
                                            setState(() => customM = v),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ZenPrimaryButton(
                                      height: 40,
                                      label: 'この時刻に設定する',
                                      onPressed: commitCustom,
                                    ),
                                  ),
                                ],
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
              child: Column(
                children: [
                  ZenPrimaryButton(
                    label: '次へ · $selected に通知',
                    onPressed: () async {
                      await context.read<AppState>().setReminderTime(selected);
                      if (context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const OnbGoalScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ZenTextLink(
                    label: 'スキップして開始',
                    color: ZenColors.inkMute,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const OnbGoalScreen(),
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

class _TimeSpinner extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final int step;
  final String unit;
  final ValueChanged<int> onChanged;

  const _TimeSpinner({
    required this.value,
    required this.min,
    required this.max,
    this.step = 1,
    required this.unit,
    required this.onChanged,
  });

  int _clamp(int v) {
    if (v < min) return max;
    if (v > max) return min;
    return v;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 78),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: ZenColors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZenColors.line),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => onChanged(_clamp(value + step)),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              child: Text(
                '▲',
                style: TextStyle(fontSize: 14, color: ZenColors.accent),
              ),
            ),
          ),
          Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w200,
              color: ZenColors.ink,
              letterSpacing: -1,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 9,
              color: ZenColors.inkMute,
              letterSpacing: 1.4,
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(_clamp(value - step)),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              child: Text(
                '▼',
                style: TextStyle(fontSize: 14, color: ZenColors.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
