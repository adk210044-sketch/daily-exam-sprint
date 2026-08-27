import 'package:flutter/material.dart';

import '../core/theme/zen_tokens.dart';

/// プライマリCTA — 高さ56px, pill, accent色
class ZenPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;
  final Color? background;
  final Color? foreground;

  const ZenPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 56,
    this.background,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background ?? ZenColors.accent,
          foregroundColor: foreground ?? ZenColors.accentInk,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ZenColors.radiusBtn),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: foreground ?? ZenColors.accentInk,
          ),
        ),
      ),
    );
  }
}

/// セカンダリテキストリンク (下線付き)
class ZenTextLink extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  const ZenTextLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = ZenColors.inkSub,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          decoration: TextDecoration.underline,
          decorationColor: color,
        ),
      ),
    );
  }
}

/// 週間進捗ドット (7個, 花丸表示対応)
class ProgressDotsRow extends StatelessWidget {
  final int current; // 1-7
  final int total;
  final double size;
  final double gap;
  final List<int> hanamaruDays;

  const ProgressDotsRow({
    super.key,
    required this.current,
    this.total = 7,
    this.size = 10,
    this.gap = 10,
    this.hanamaruDays = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final dayNum = i + 1;
        final isPast = dayNum < current;
        final isCurrent = dayNum == current;
        final isMaru = hanamaruDays.contains(dayNum);
        final dotSize = isCurrent ? size * 1.5 : size;
        return Padding(
          padding: EdgeInsets.only(right: i == total - 1 ? 0 : gap),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isPast || isCurrent)
                      ? ZenColors.accent
                      : Colors.transparent,
                  border: !isPast && !isCurrent
                      ? Border.all(color: ZenColors.line, width: 1.5)
                      : null,
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: ZenColors.accentSoft,
                            blurRadius: 0,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
              if (isMaru)
                Text(
                  '◎',
                  style: TextStyle(
                    color: ZenColors.gold,
                    fontSize: size * 1.6,
                    height: 1,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

/// ボトムタブ (ホーム / カレンダー / 苦手復習 / 設定)
class ZenBottomTab extends StatelessWidget {
  final String active;
  final ValueChanged<String> onTap;

  const ZenBottomTab({super.key, required this.active, required this.onTap});

  static const items = [
    (key: 'home', label: 'ホーム'),
    (key: 'calendar', label: 'カレンダー'),
    (key: 'review', label: '苦手復習'),
    (key: 'settings', label: '設定'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ZenColors.card,
        border: Border(top: BorderSide(color: ZenColors.line, width: 0.5)),
      ),
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: items.map((it) {
          final isActive = it.key == active;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(it.key),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? ZenColors.accent : Colors.transparent,
                      ),
                    ),
                    Text(
                      it.label,
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.6,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isActive ? ZenColors.accent : ZenColors.inkMute,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// カテゴリチップ (dot + ラベル)
class CategoryChip extends StatelessWidget {
  final String category;

  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final color = ZenColors.catDotColor(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ZenColors.accentSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            category,
            style: TextStyle(
              fontSize: 11,
              color: ZenColors.accentDeep,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
