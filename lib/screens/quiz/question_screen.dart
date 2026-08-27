import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/quiz_session_provider.dart';
import '../../widgets/zen_widgets.dart';
import 'feedback_screen.dart';
import 'quit_confirm_sheet.dart';

/// Question (ZenQuestion) — 5択出題
class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  Future<void> _onQuit(BuildContext context) async {
    final result = await showQuitConfirmSheet(context);
    if (result == true && context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizSessionProvider>(
      builder: (context, quiz, _) {
        if (quiz.isLoading || quiz.questions.isEmpty) {
          return const Scaffold(
            backgroundColor: ZenColors.bg,
            body: Center(
              child: CircularProgressIndicator(color: ZenColors.accent),
            ),
          );
        }

        final q = quiz.currentQuestion;
        final qNo = quiz.questionNumber;
        final total = quiz.totalQuestions;

        return Scaffold(
          backgroundColor: ZenColors.bg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _onQuit(context),
                        child: const Icon(
                          Icons.close,
                          size: 22,
                          color: ZenColors.inkSub,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: qNo / total,
                            minHeight: 3,
                            backgroundColor: ZenColors.line,
                            valueColor: const AlwaysStoppedAnimation(
                              ZenColors.accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$qNo',
                              style: const TextStyle(
                                fontSize: 12,
                                color: ZenColors.inkSub,
                              ),
                            ),
                            TextSpan(
                              text: ' / $total',
                              style: const TextStyle(
                                fontSize: 12,
                                color: ZenColors.inkMute,
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
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                          child: Row(
                            children: [
                              CategoryChip(category: q.categoryName),
                              const SizedBox(width: 8),
                              Text(
                                q.year,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: ZenColors.inkMute,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
                          child: Text(q.text, style: ZenText.questionText()),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: List.generate(q.choices.length, (i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    await quiz.answer(i);
                                    if (context.mounted) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              FeedbackScreen(chosenIndex: i),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ZenColors.card,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: ZenColors.line),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: ZenColors.line,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            '${i + 1}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: ZenColors.inkSub,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            q.choices[i],
                                            style: ZenText.choiceText(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
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
      },
    );
  }
}
