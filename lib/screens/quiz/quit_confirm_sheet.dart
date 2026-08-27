import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/app_state.dart';
import '../../widgets/zen_widgets.dart';

/// 中断確認 (ZenQuitConfirm) — ボトムシート形式
Future<bool?> showQuitConfirmSheet(BuildContext context) {
  final dailyN = context.read<AppState>().dailyQuestionCount;
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: ZenColors.ink.withValues(alpha: 0.5),
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: ZenColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: ZenColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              '今日の $dailyN問を中断しますか？',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ZenColors.ink,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '進捗は保存されないため、\nもう一度、1問目から解くことになります。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: ZenColors.inkSub,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 28),
            ZenPrimaryButton(
              label: '中断してホームへ',
              background: ZenColors.wrong,
              foreground: Colors.white,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ZenColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ZenColors.radiusBtn),
                  ),
                ),
                child: const Text(
                  '続ける',
                  style: TextStyle(fontSize: 14, color: ZenColors.ink),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
