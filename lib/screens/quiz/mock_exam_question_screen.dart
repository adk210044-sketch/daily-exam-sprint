import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/models/quiz_question.dart';
import '../../data/services/diagnosis_service.dart';
import '../../providers/quiz_session_provider.dart';
import '../../widgets/zen_widgets.dart';
import 'mock_exam_result_screen.dart';
import 'quit_confirm_sheet.dart';

/// 模試試験の出題画面。
/// 通常の QuestionScreen と異なり、
/// - 即時フィードバックは出さず、全問回答後にまとめて採点する
/// - 前後の問題に自由に移動できる (回答済み状況を一覧できる)
/// - 制限時間 (本番と同じ3時間) をカウントダウン表示し、0になったら自動提出
class MockExamQuestionScreen extends StatefulWidget {
  const MockExamQuestionScreen({super.key});

  @override
  State<MockExamQuestionScreen> createState() =>
      _MockExamQuestionScreenState();
}

class _MockExamQuestionScreenState extends State<MockExamQuestionScreen> {
  Timer? _timer;
  late Duration _remaining;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _remaining = MockExamService.timeLimit;
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    setState(() {
      _remaining -= const Duration(seconds: 1);
    });
    if (_remaining.inSeconds <= 0) {
      timer.cancel();
      _remaining = Duration.zero;
      _autoSubmit();
    }
  }

  Future<void> _autoSubmit() async {
    if (_submitting) return;
    await _submit(timeUp: true);
  }

  Future<void> _submit({bool timeUp = false}) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    _timer?.cancel();
    final quiz = context.read<QuizSessionProvider>();
    final result = await quiz.completeSession();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MockExamResultScreen(
          score: result.score,
          timeUp: timeUp,
        ),
      ),
    );
  }

  Future<void> _confirmSubmit() async {
    final quiz = context.read<QuizSessionProvider>();
    final unanswered = quiz.chosenAnswers.where((c) => c == null).length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ZenColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '採点しますか？',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: Text(
          unanswered > 0
              ? 'まだ $unanswered 問が未回答です。\nこのまま採点すると未回答は不正解扱いになります。'
              : '全問に回答済みです。採点して結果を見ますか？',
          style: const TextStyle(
            fontSize: 13,
            color: ZenColors.inkSub,
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'もう少し解く',
              style: TextStyle(color: ZenColors.inkMute),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              '採点する',
              style: TextStyle(
                color: ZenColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _submit();
    }
  }

  Future<void> _onQuit(BuildContext context) async {
    final result = await showQuitConfirmSheet(context);
    if (result == true && context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  void _showQuestionJumpSheet(QuizSessionProvider quiz) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ZenColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ZenColors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  '問題を選ぶ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ZenColors.ink,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(quiz.totalQuestions, (i) {
                    final answered = quiz.chosenAnswers[i] != null;
                    final isCurrent = i == quiz.currentIndex;
                    return GestureDetector(
                      onTap: () {
                        quiz.jumpTo(i);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrent
                              ? ZenColors.accent
                              : (answered
                                    ? ZenColors.accentSoft
                                    : Colors.transparent),
                          border: Border.all(
                            color: isCurrent
                                ? ZenColors.accent
                                : ZenColors.line,
                          ),
                        ),
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isCurrent
                                ? ZenColors.accentInk
                                : (answered
                                      ? ZenColors.accentDeep
                                      : ZenColors.inkSub),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        final chosen = quiz.chosenAnswers[quiz.currentIndex];
        final answeredCount = quiz.chosenAnswers
            .where((c) => c != null)
            .length;
        final isLowTime = _remaining.inMinutes < 10;

        return Scaffold(
          backgroundColor: ZenColors.bg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
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
                      GestureDetector(
                        onTap: () => _showQuestionJumpSheet(quiz),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$qNo',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: ZenColors.ink,
                                      fontWeight: FontWeight.w700,
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
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.grid_view_rounded,
                              size: 15,
                              color: ZenColors.accent,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 15,
                            color: isLowTime
                                ? ZenColors.wrong
                                : ZenColors.inkSub,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(_remaining),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isLowTime
                                  ? ZenColors.wrong
                                  : ZenColors.ink,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: answeredCount / total,
                      minHeight: 3,
                      backgroundColor: ZenColors.line,
                      valueColor: const AlwaysStoppedAnimation(
                        ZenColors.accent,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                          child: Row(
                            children: [
                              CategoryChip(category: q.categoryName),
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
                              final selected = chosen == i;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () => quiz.selectChoice(i),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? ZenColors.accentSoft
                                          : ZenColors.card,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: selected
                                            ? ZenColors.accent
                                            : ZenColors.line,
                                        width: selected ? 1.5 : 1,
                                      ),
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
                                            color: selected
                                                ? ZenColors.accent
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: selected
                                                  ? ZenColors.accent
                                                  : ZenColors.line,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            '${i + 1}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: selected
                                                  ? ZenColors.accentInk
                                                  : ZenColors.inkSub,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Text(
                                            QuizQuestion.displayChoice(
                                              q.choices[i],
                                            ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: quiz.currentIndex > 0
                                ? () => quiz.jumpTo(quiz.currentIndex - 1)
                                : null,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: ZenColors.line),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ZenColors.radiusBtn,
                                ),
                              ),
                            ),
                            child: const Text(
                              '前の問題',
                              style: TextStyle(
                                fontSize: 13,
                                color: ZenColors.inkSub,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: quiz.isLastQuestion
                              ? ElevatedButton(
                                  onPressed: _submitting
                                      ? null
                                      : _confirmSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ZenColors.accent,
                                    foregroundColor: ZenColors.accentInk,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        ZenColors.radiusBtn,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    '採点する',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () =>
                                      quiz.jumpTo(quiz.currentIndex + 1),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ZenColors.accent,
                                    foregroundColor: ZenColors.accentInk,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        ZenColors.radiusBtn,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    '次の問題',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
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
