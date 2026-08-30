import 'package:flutter/material.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/models/quiz_question.dart';
import '../../data/services/error_report_service.dart';
import '../../widgets/zen_widgets.dart';

/// 解説の誤り報告 (ZenReportError) — カテゴリ選択ボトムシート
///
/// 選択肢:
///  - 表記ゆれ・誤字
///  - 情報が古い
///  - 正解が違う気がする
///  - その他
///
/// ユーザーのメールアドレス等は収集せず、Firestoreへ直接送信する。
Future<void> showReportErrorSheet(
  BuildContext context, {
  required QuizQuestion question,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: ZenColors.ink.withValues(alpha: 0.5),
    isScrollControlled: true,
    builder: (context) => _ReportErrorSheetContent(question: question),
  );
}

class _ReportErrorSheetContent extends StatefulWidget {
  final QuizQuestion question;

  const _ReportErrorSheetContent({required this.question});

  @override
  State<_ReportErrorSheetContent> createState() =>
      _ReportErrorSheetContentState();
}

enum _SheetStatus { selecting, sending, sent, error }

class _ReportErrorSheetContentState extends State<_ReportErrorSheetContent> {
  static const categories = [
    ('表記ゆれ・誤字', Icons.spellcheck),
    ('情報が古い', Icons.update),
    ('正解が違う気がする', Icons.help_outline),
    ('その他', Icons.chat_bubble_outline),
  ];

  _SheetStatus _status = _SheetStatus.selecting;
  String? _selected;

  Future<void> _send(String category) async {
    setState(() {
      _selected = category;
      _status = _SheetStatus.sending;
    });
    try {
      await ErrorReportService.instance.submitReport(
        question: widget.question,
        category: category,
      );
      if (mounted) setState(() => _status = _SheetStatus.sent);
    } catch (_) {
      if (mounted) setState(() => _status = _SheetStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ZenColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        28,
        12,
        28,
        28 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: ZenColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _SheetStatus.sent:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ZenColors.accentSoft,
              ),
              child: const Icon(
                Icons.check,
                size: 34,
                color: ZenColors.accent,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ご報告ありがとうございます',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ZenColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '貴重なご指摘をお寄せいただき、\n誠にありがとうございます。\nサービス改善に努めてまいります。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: ZenColors.inkSub,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ZenColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ZenColors.radiusBtn),
                  ),
                ),
                child: const Text(
                  '閉じる',
                  style: TextStyle(fontSize: 14, color: ZenColors.ink),
                ),
              ),
            ),
          ],
        );

      case _SheetStatus.error:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ZenColors.wrongSoft,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 34,
                color: ZenColors.wrong,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '送信に失敗しました',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ZenColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '通信環境をご確認のうえ、\nもう一度お試しください。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: ZenColors.inkSub,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            ZenPrimaryButton(
              label: 'もう一度送信する',
              onPressed: () => _send(_selected!),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ZenColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ZenColors.radiusBtn),
                  ),
                ),
                child: const Text(
                  'キャンセル',
                  style: TextStyle(fontSize: 14, color: ZenColors.ink),
                ),
              ),
            ),
          ],
        );

      case _SheetStatus.sending:
        return const SizedBox(
          height: 160,
          child: Center(
            child: CircularProgressIndicator(color: ZenColors.accent),
          ),
        );

      case _SheetStatus.selecting:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '解説に誤りを見つけましたか？',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: ZenColors.ink,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '当てはまる項目を選んでください。\nメールアドレス等の情報は収集されません。',
              style: TextStyle(
                fontSize: 12,
                color: ZenColors.inkSub,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            ...categories.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => _send(c.$1),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ZenColors.line),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ZenColors.radiusBtn,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(c.$2, size: 18, color: ZenColors.accentDeep),
                        const SizedBox(width: 12),
                        Text(
                          c.$1,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ZenColors.ink,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'キャンセル',
                  style: TextStyle(fontSize: 13, color: ZenColors.inkMute),
                ),
              ),
            ),
          ],
        );
    }
  }
}
