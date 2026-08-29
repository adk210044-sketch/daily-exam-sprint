import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/quiz_session_provider.dart';
import '../../widgets/zen_widgets.dart';
import 'question_review_sheet.dart';
import 'question_screen.dart';
import 'quit_confirm_sheet.dart';
import 'result_screen.dart';

/// Feedback (ZenFeedback) — 正誤判定 + 解説自動展開
class FeedbackScreen extends StatelessWidget {
  final int chosenIndex;

  const FeedbackScreen({super.key, required this.chosenIndex});

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
        final q = quiz.currentQuestion;
        final qNo = quiz.questionNumber;
        final total = quiz.totalQuestions;
        final correct = chosenIndex == q.correctIndex;
        final isLast = quiz.isLastQuestion;

        return Scaffold(
          backgroundColor: ZenColors.bg,
          body: SafeArea(
            child: Column(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 14),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          builder: (context, v, child) => Opacity(
                            opacity: v,
                            child: Transform.translate(
                              offset: Offset(0, (1 - v) * 8),
                              child: child,
                            ),
                          ),
                          child: Container(
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: correct
                                  ? ZenColors.accentSoft
                                  : ZenColors.wrongSoft,
                            ),
                            child: Icon(
                              correct ? Icons.check : Icons.close,
                              size: 44,
                              color: correct
                                  ? ZenColors.accent
                                  : ZenColors.wrong,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          correct ? '正解' : '不正解',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2.0,
                            color: ZenColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${q.year} · ${q.categoryName}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: ZenColors.inkMute,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: '正解は ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: ZenColors.inkSub,
                                ),
                              ),
                              TextSpan(
                                text: '${q.correctIndex + 1}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: ZenColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(
                                text: ' 番',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: ZenColors.inkSub,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (!correct)
                          _answerBox(
                            label: 'あなた',
                            text: q.choices[chosenIndex],
                            color: ZenColors.wrong,
                            bg: ZenColors.wrongSoft,
                          ),
                        _answerBox(
                          label: '正 解',
                          text: q.choices[q.correctIndex],
                          color: ZenColors.accentDeep,
                          bg: ZenColors.accentSoft,
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => showQuestionReviewSheet(
                            context,
                            q: q,
                            qNo: qNo,
                            totalQ: total,
                            chosen: chosenIndex,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.menu_book_outlined,
                                  size: 14,
                                  color: ZenColors.inkSub,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '問題文を見直す',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ZenColors.inkSub,
                                    letterSpacing: 0.8,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          builder: (context, v, child) =>
                              Opacity(opacity: v, child: child),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: ZenColors.card,
                              borderRadius: BorderRadius.circular(
                                ZenColors.radiusCard,
                              ),
                              border: Border.all(color: ZenColors.line),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '公 式  解 説',
                                  style: ZenText.kicker(letterSpacing: 2.0),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  q.officialExplanation,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.85,
                                    color: ZenColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: ZenPrimaryButton(
                    height: 54,
                    label: isLast ? '結果を見る' : '次の問題へ',
                    onPressed: () async {
                      if (isLast) {
                        try {
                          final result = await quiz.completeSession();
                          await quiz.maybeAdvanceDay(hanamaru: result.hanamaru);
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => ResultScreen(
                                  score: result.score,
                                  hanamaru: result.hanamaru,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (kDebugMode) {
                            debugPrint('結果を見る処理でエラー: $e');
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('結果の保存に失敗しました。もう一度お試しください。'),
                              ),
                            );
                          }
                        }
                      } else {
                        quiz.nextQuestion();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const QuestionScreen(),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _answerBox({
    required String label,
    required String text,
    required Color color,
    required Color bg,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.6,
                color: ZenColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
