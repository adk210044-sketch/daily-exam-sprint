import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/quiz_session_provider.dart';
import '../main/home_screen.dart';
import 'report_error_sheet.dart';

/// 解説閲覧 (ZenExplanation) — 全9問振り返り
class ExplanationScreen extends StatefulWidget {
  const ExplanationScreen({super.key});

  @override
  State<ExplanationScreen> createState() => _ExplanationScreenState();
}

class _ExplanationScreenState extends State<ExplanationScreen> {
  int qIdx = 0;

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizSessionProvider>();
    final questions = quiz.questions;
    if (questions.isEmpty) {
      return const Scaffold(backgroundColor: ZenColors.bg, body: SizedBox());
    }
    final q = questions[qIdx];

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
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: ZenColors.ink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '解 説',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ZenColors.ink,
                      ),
                    ),
                  ),
                  Text(
                    '${qIdx + 1} / ${questions.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: ZenColors.inkSub,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: questions.length,
                itemBuilder: (context, i) {
                  final active = i == qIdx;
                  return GestureDetector(
                    onTap: () => setState(() => qIdx = i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: active ? ZenColors.accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                        border: active
                            ? null
                            : Border.all(color: ZenColors.line),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '問${i + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? ZenColors.accentInk
                              : ZenColors.inkSub,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: ZenColors.accentSoft,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  q.categoryName,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: ZenColors.accentDeep,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                q.year,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: ZenColors.inkMute,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            q.text,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.7,
                              color: ZenColors.ink,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: ZenColors.accentSoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '正 解',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: ZenColors.accentDeep,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    q.choices[q.correctIndex],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      height: 1.6,
                                      color: ZenColors.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
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
                          const SizedBox(height: 12),
                          Text(
                            q.officialExplanation,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.9,
                              color: ZenColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () =>
                          showReportErrorSheet(context, question: q),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.flag_outlined,
                              size: 14,
                              color: ZenColors.inkMute,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '解説に誤りを見つけた',
                              style: TextStyle(
                                fontSize: 12,
                                color: ZenColors.inkMute,
                                letterSpacing: 0.4,
                                decoration: TextDecoration.underline,
                                decorationColor: ZenColors.inkMute,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: const BoxDecoration(
                color: ZenColors.card,
                border: Border(
                  top: BorderSide(color: ZenColors.line, width: 0.5),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: qIdx == 0
                                ? null
                                : () => setState(() => qIdx--),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: ZenColors.line),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: const Text(
                              '← 前の問題',
                              style: TextStyle(
                                fontSize: 13,
                                color: ZenColors.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (qIdx < questions.length - 1) {
                                setState(() => qIdx++);
                              } else {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const HomeScreen(),
                                  ),
                                  (r) => false,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ZenColors.accent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: Text(
                              qIdx < questions.length - 1 ? '次の問題 →' : 'ホームへ',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (r) => false,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'ホームに戻る',
                        style: TextStyle(
                          fontSize: 12,
                          color: ZenColors.inkSub,
                          decoration: TextDecoration.underline,
                          decorationColor: ZenColors.inkSub,
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
  }
}
