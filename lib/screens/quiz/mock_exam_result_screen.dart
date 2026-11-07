import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/services/diagnosis_service.dart';
import '../../providers/quiz_session_provider.dart';
import '../../widgets/ad_banner_widget.dart';
import '../../widgets/enso_circle.dart';
import '../../widgets/zen_widgets.dart';
import '../main/home_screen.dart';

/// 模試試験の結果画面。
/// 通常の ResultScreen と異なり、公式合格基準 (各科目40%以上・総合60%以上)
/// に沿った科目別の合否目安を表示する。
class MockExamResultScreen extends StatelessWidget {
  final int score; // 0-100
  final bool timeUp;

  const MockExamResultScreen({
    super.key,
    required this.score,
    this.timeUp = false,
  });

  @override
  Widget build(BuildContext context) {
    final quiz = context.read<QuizSessionProvider>();
    final session = quiz.mockExamSession;

    // 科目別集計 (今回の模試1回分のみ、合格可能性診断とは独立に算出)
    final totalBySubject = <ExamSubject, int>{};
    final correctBySubject = <ExamSubject, int>{};
    for (var i = 0; i < quiz.questions.length; i++) {
      final q = quiz.questions[i];
      final subject = subjectOfCategoryKey(q.categoryKey);
      totalBySubject[subject] = (totalBySubject[subject] ?? 0) + 1;
      final chosen = quiz.chosenAnswers[i];
      if (chosen != null && chosen == q.correctIndex) {
        correctBySubject[subject] = (correctBySubject[subject] ?? 0) + 1;
      }
    }
    final subjectScores = ExamSubject.values
        .map(
          (s) => SubjectScore(
            subject: s,
            correct: correctBySubject[s] ?? 0,
            total: totalBySubject[s] ?? 0,
          ),
        )
        .where((s) => s.total > 0)
        .toList();

    final overallPass = score >= 60;
    final allSubjectsPass = subjectScores.every((s) => s.passesSubjectMinimum);
    final isLikelyPass = overallPass && allSubjectsPass;

    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MOCK EXAM RESULT'
                    '${timeUp ? "  ·  時間切れ" : ""}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: ZenColors.inkMute,
                      letterSpacing: 1.6,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: ZenColors.inkSub,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  children: [
                    if (session != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          session.label,
                          style: const TextStyle(
                            fontSize: 13,
                            color: ZenColors.inkSub,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isLikelyPass)
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    ZenColors.gold.withValues(alpha: 0.13),
                                    ZenColors.gold.withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                            ),
                          EnsoCircle(
                            size: 240,
                            color: isLikelyPass
                                ? ZenColors.gold
                                : ZenColors.accent,
                            strokeBase: 12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '総合正答率',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: ZenColors.inkSub,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('$score', style: ZenText.heroNumber()),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '%',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: ZenColors.inkSub,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isLikelyPass
                            ? ZenColors.accentSoft
                            : ZenColors.wrongSoft,
                        borderRadius: BorderRadius.circular(
                          ZenColors.radiusCard,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isLikelyPass
                                ? Icons.check_circle
                                : Icons.info_outline,
                            color: isLikelyPass
                                ? ZenColors.accentDeep
                                : ZenColors.wrong,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isLikelyPass
                                  ? '合格基準(総合60%・各科目40%以上)を満たしています'
                                  : !overallPass
                                  ? '総合60%に届いていません。もう一歩です。'
                                  : '総合は60%以上ですが、40%未満の科目があります',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isLikelyPass
                                    ? ZenColors.accentDeep
                                    : ZenColors.wrong,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '科目別 正答率 (合格基準 各40%以上)',
                        style: const TextStyle(
                          fontSize: 11,
                          color: ZenColors.inkSub,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...subjectScores.map((s) => _SubjectRow(score: s)),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const AdBannerWidget(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: ZenPrimaryButton(
                label: 'ホームへ戻る',
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  final SubjectScore score;
  const _SubjectRow({required this.score});

  @override
  Widget build(BuildContext context) {
    final pass = score.passesSubjectMinimum;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ZenColors.card,
        border: Border.all(color: ZenColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              score.subject.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ZenColors.ink,
              ),
            ),
          ),
          Text(
            '${score.correct}/${score.total}',
            style: const TextStyle(fontSize: 12, color: ZenColors.inkSub),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 60,
            child: Text(
              '${score.ratePercent}%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: pass ? ZenColors.accent : ZenColors.wrong,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            pass ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: pass ? ZenColors.accent : ZenColors.wrong,
          ),
        ],
      ),
    );
  }
}
