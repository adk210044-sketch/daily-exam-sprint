import 'package:flutter/material.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/models/quiz_question.dart';
import '../../widgets/zen_widgets.dart';

/// 問題文レビューモーダル (QuestionReviewSheet) — Feedback画面から呼び出し
void showQuestionReviewSheet(
  BuildContext context, {
  required QuizQuestion q,
  required int qNo,
  required int totalQ,
  required int? chosen,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: ZenColors.ink.withValues(alpha: 0.5),
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.82,
        maxChildSize: 0.82,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: ZenColors.bg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: ZenColors.line,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: ZenColors.line,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Q · $qNo OF $totalQ',
                                    style: ZenText.kicker(letterSpacing: 2.0),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      CategoryChip(category: q.categoryName),
                                      const SizedBox(width: 8),
                                      Text(
                                        q.year,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: ZenColors.inkMute,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ZenColors.card,
                                  border: Border.all(color: ZenColors.line),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: ZenColors.inkSub,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.text,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.85,
                            color: ZenColors.ink,
                            letterSpacing: 0.15,
                          ),
                        ),
                        const SizedBox(height: 22),
                        ...List.generate(q.choices.length, (i) {
                          final isCorrect = i == q.correctIndex;
                          final isChosen = i == chosen;
                          final isWrongChosen = isChosen && !isCorrect;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? ZenColors.accentSoft
                                  : (isWrongChosen
                                        ? ZenColors.wrongSoft
                                        : ZenColors.card),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCorrect
                                    ? ZenColors.accent
                                    : (isWrongChosen
                                          ? ZenColors.wrong
                                          : ZenColors.line),
                                width: isCorrect || isWrongChosen ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(top: 1),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isCorrect
                                        ? ZenColors.accent
                                        : (isWrongChosen
                                              ? ZenColors.wrong
                                              : Colors.transparent),
                                    border: isCorrect || isWrongChosen
                                        ? null
                                        : Border.all(color: ZenColors.line),
                                  ),
                                  child: Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isCorrect || isWrongChosen
                                          ? Colors.white
                                          : ZenColors.inkSub,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    q.choices[i],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.7,
                                      color: ZenColors.ink,
                                    ),
                                  ),
                                ),
                                if (isCorrect || isWrongChosen)
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 2,
                                      left: 6,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCorrect
                                          ? ZenColors.card
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isCorrect ? '正解' : 'あなた',
                                      style: TextStyle(
                                        fontSize: 9,
                                        letterSpacing: 1.4,
                                        fontWeight: FontWeight.w700,
                                        color: isCorrect
                                            ? ZenColors.accentDeep
                                            : ZenColors.wrong,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  decoration: const BoxDecoration(
                    color: ZenColors.bg,
                    border: Border(
                      top: BorderSide(color: ZenColors.line, width: 0.5),
                    ),
                  ),
                  child: ZenPrimaryButton(
                    height: 48,
                    label: '解説に戻る',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
