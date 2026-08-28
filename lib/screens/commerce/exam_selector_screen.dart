import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/database/app_database.dart';
import '../../providers/app_state.dart';
import '../../widgets/progress_ring.dart';
import '../main/home_screen.dart';
import 'paywall_screen.dart';

enum _FilterTab { all, done, doing, notStarted, locked }

/// 試験選択画面 (ZenExamSelector) — 有料版: 全11回から選べる。
/// 無料版: 直近2回分のみ解放、残りはロック表示 + Paywall誘導。
class ExamSelectorScreen extends StatefulWidget {
  const ExamSelectorScreen({super.key});

  @override
  State<ExamSelectorScreen> createState() => _ExamSelectorScreenState();
}

class _ExamSelectorScreenState extends State<ExamSelectorScreen> {
  List<ExamSession> _sessions = [];
  bool _loading = true;
  _FilterTab _tab = _FilterTab.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final appState = context.read<AppState>();
    final all = await appState.examRepo.getAllSessions();
    final filtered =
        all.where((s) => s.examType == appState.examType).toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (!mounted) return;
    setState(() {
      _sessions = filtered;
      _loading = false;
    });
  }

  Future<void> _selectSession(ExamSession session) async {
    final appState = context.read<AppState>();
    await appState.setCurrentSession(session.id);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _goToPaywall() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PaywallScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final purchased = appState.purchased;

    if (_loading) {
      return const Scaffold(
        backgroundColor: ZenColors.bg,
        body: Center(child: CircularProgressIndicator(color: ZenColors.accent)),
      );
    }

    final doneCount = _sessions
        .where(
          (s) => s.status == 'completed' && (purchased || s.isLatest),
        )
        .length;
    final doingCount = _sessions
        .where(
          (s) => s.status == 'in_progress' && (purchased || s.isLatest),
        )
        .length;
    final newCount = _sessions
        .where(
          (s) => s.status == 'not_started' && (purchased || s.isLatest),
        )
        .length;
    final lockedCount = purchased
        ? 0
        : _sessions.where((s) => !s.isLatest).length;

    final filtered = _sessions.where((s) {
      final isLocked = !purchased && !s.isLatest;
      switch (_tab) {
        case _FilterTab.all:
          return true;
        case _FilterTab.doing:
          return !isLocked && s.status == 'in_progress';
        case _FilterTab.done:
          return !isLocked && s.status == 'completed';
        case _FilterTab.notStarted:
          return !isLocked && s.status == 'not_started';
        case _FilterTab.locked:
          return isLocked;
      }
    }).toList();

    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 20, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 2, right: 8),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: ZenColors.inkSub,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          purchased ? 'EXAM · ALL UNLOCKED' : 'EXAM · FREE',
                          style: ZenText.kicker(letterSpacing: 3.2),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '解く試験を選ぶ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: ZenColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Summary chips
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  if (purchased)
                    _chip(
                      label: '完走',
                      value: doneCount,
                      color: ZenColors.gold,
                      selected: _tab == _FilterTab.done,
                      onTap: () => setState(
                        () => _tab = _tab == _FilterTab.done
                            ? _FilterTab.all
                            : _FilterTab.done,
                      ),
                    ),
                  _chip(
                    label: '挑戦中',
                    value: doingCount,
                    color: ZenColors.accent,
                    selected: _tab == _FilterTab.doing,
                    onTap: () => setState(
                      () => _tab = _tab == _FilterTab.doing
                          ? _FilterTab.all
                          : _FilterTab.doing,
                    ),
                  ),
                  _chip(
                    label: '未着手',
                    value: newCount,
                    color: ZenColors.inkSub,
                    selected: _tab == _FilterTab.notStarted,
                    onTap: () => setState(
                      () => _tab = _tab == _FilterTab.notStarted
                          ? _FilterTab.all
                          : _FilterTab.notStarted,
                    ),
                  ),
                  if (!purchased)
                    _chip(
                      label: '有料で解放',
                      value: lockedCount,
                      color: ZenColors.gold,
                      selected: _tab == _FilterTab.locked,
                      onTap: () => setState(
                        () => _tab = _tab == _FilterTab.locked
                            ? _FilterTab.all
                            : _FilterTab.locked,
                      ),
                    ),
                ],
              ),
            ),
            // Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.35,
                          ),
                      itemBuilder: (context, i) {
                        final session = filtered[i];
                        final isLocked = !purchased && !session.isLatest;
                        return _ExamSessionCard(
                          session: session,
                          isLocked: isLocked,
                          onTap: isLocked
                              ? _goToPaywall
                              : () => _selectSession(session),
                        );
                      },
                    ),
                    if (filtered.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          '該当する試験がありません',
                          style: TextStyle(
                            fontSize: 12,
                            color: ZenColors.inkMute,
                          ),
                        ),
                      ),
                    if (!purchased && lockedCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _UpgradeBanner(
                          lockedCount: lockedCount,
                          onTap: _goToPaywall,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({
    required String label,
    required int value,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: selected ? ZenColors.card : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? color : ZenColors.line,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: color,
                    letterSpacing: -0.4,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    color: ZenColors.inkSub,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExamSessionCard extends StatelessWidget {
  final ExamSession session;
  final bool isLocked;
  final VoidCallback onTap;

  const _ExamSessionCard({
    required this.session,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = session;
    final isCurrent = s.status == 'in_progress' && s.isLatest;
    final progress = progressPctFor(status: s.status, day: s.day);

    Widget statusWidget;
    if (isLocked) {
      statusWidget = const Text(
        '有料版で解放',
        style: TextStyle(
          fontSize: 10,
          color: ZenColors.inkMute,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (s.status == 'completed') {
      statusWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('◎', style: TextStyle(color: ZenColors.gold, fontSize: 13)),
          SizedBox(width: 4),
          Text(
            '完走',
            style: TextStyle(
              fontSize: 10,
              color: ZenColors.gold,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else if (s.status == 'in_progress') {
      statusWidget = Text(
        'Day ${s.day == 0 ? 1 : s.day} / 7 挑戦中',
        style: const TextStyle(
          fontSize: 10,
          color: ZenColors.accent,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      statusWidget = const Text(
        '未着手',
        style: TextStyle(fontSize: 10, color: ZenColors.inkMute, letterSpacing: 1.0),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 12),
        decoration: BoxDecoration(
          color: isLocked
              ? ZenColors.bgSub
              : (isCurrent ? ZenColors.accentSoft : ZenColors.card),
          borderRadius: BorderRadius.circular(ZenColors.radiusCard),
          border: isCurrent
              ? Border.all(color: ZenColors.accent, width: 1.5)
              : (isLocked
                    ? Border.all(color: ZenColors.line)
                    : Border.all(color: ZenColors.line)),
        ),
        child: isLocked
            ? CustomPaint(
                painter: _StripePatternPainter(),
                child: _cardContent(statusWidget, isCurrent, progress),
              )
            : _cardContent(statusWidget, isCurrent, progress),
      ),
    );
  }

  Widget _cardContent(Widget statusWidget, bool isCurrent, double progress) {
    final s = session;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isLocked ? ZenColors.inkMute : ZenColors.ink,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked)
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ZenColors.bg,
                  border: Border.all(color: ZenColors.line),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: ZenColors.inkMute,
                ),
              )
            else
              ProgressRing(progress: progress, status: s.status, size: 34),
          ],
        ),
        const SizedBox(height: 8),
        statusWidget,
        const SizedBox(height: 8),
        if (!isLocked && s.status != 'not_started') ...[
          Wrap(
            spacing: 8,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: '正答率 ',
                      style: TextStyle(fontSize: 10, color: ZenColors.inkSub),
                    ),
                    TextSpan(
                      text: '${s.avgScore ?? '-'}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: ZenColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(
                      text: '%',
                      style: TextStyle(fontSize: 10, color: ZenColors.inkSub),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: '◎ ',
                      style: TextStyle(fontSize: 10, color: ZenColors.inkSub),
                    ),
                    TextSpan(
                      text: '${s.hanamaruDays}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: ZenColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(7, (i) {
              final d = i + 1;
              final filled = s.day >= d || s.status == 'completed';
              return Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsets.only(right: i == 6 ? 0 : 3),
                  decoration: BoxDecoration(
                    color: filled
                        ? (d >= 6 ? ZenColors.gold : ZenColors.accent)
                        : ZenColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ] else if (!isLocked && s.status == 'not_started')
          const Text(
            'タップで開始',
            style: TextStyle(
              fontSize: 10,
              color: ZenColors.inkMute,
              letterSpacing: 0.4,
            ),
          )
        else if (isLocked)
          const Opacity(
            opacity: 0.7,
            child: Text(
              'タップで詳細',
              style: TextStyle(
                fontSize: 10,
                color: ZenColors.inkMute,
                letterSpacing: 0.4,
              ),
            ),
          ),
      ],
    );
  }
}

/// ロック済みカードの斜線パターン背景
class _StripePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ZenColors.line.withValues(alpha: 0.35)
      ..strokeWidth = 6;
    const gap = 12.0;
    final diag = size.width + size.height;
    for (double x = -diag; x < diag; x += gap) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UpgradeBanner extends StatelessWidget {
  final int lockedCount;
  final VoidCallback onTap;

  const _UpgradeBanner({required this.lockedCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          color: ZenColors.card,
          border: Border.all(color: ZenColors.accent, width: 1.5),
          borderRadius: BorderRadius.circular(ZenColors.radiusCard),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ZenColors.accentSoft,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: ZenColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '残り $lockedCount 回分を、一度に解放',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ZenColors.accentDeep,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '過去 6年分の試験にアクセスできます',
                        style: TextStyle(
                          fontSize: 11,
                          color: ZenColors.inkSub,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: ZenColors.accent,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: ZenColors.accentSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¥780',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: ZenColors.accentDeep,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: ZenColors.accent.withValues(alpha: 0.3),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '買い切り・追加課金なし',
                        style: TextStyle(
                          fontSize: 11,
                          color: ZenColors.accentDeep,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'サブスクではありません',
                        style: TextStyle(
                          fontSize: 10,
                          color: ZenColors.accentDeep,
                        ),
                      ),
                    ],
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
