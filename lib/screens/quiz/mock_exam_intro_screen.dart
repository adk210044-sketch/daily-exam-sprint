import 'package:flutter/material.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/database/app_database.dart';
import '../../data/services/diagnosis_service.dart';
import '../../providers/quiz_session_provider.dart';
import '../../widgets/zen_widgets.dart';
import 'mock_exam_question_screen.dart';

/// 模試試験の開始前説明画面。
/// 本番と同じ制限時間・全問出題であることを明示してから開始する。
class MockExamIntroScreen extends StatefulWidget {
  final ExamSession session;
  final QuizSessionProvider quiz;

  const MockExamIntroScreen({
    super.key,
    required this.session,
    required this.quiz,
  });

  @override
  State<MockExamIntroScreen> createState() => _MockExamIntroScreenState();
}

class _MockExamIntroScreenState extends State<MockExamIntroScreen> {
  bool _starting = false;

  Future<void> _start() async {
    setState(() => _starting = true);
    await widget.quiz.startMockExam(widget.session);
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MockExamQuestionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final hours = MockExamService.timeLimit.inHours;

    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 22,
                      color: ZenColors.inkSub,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MOCK EXAM',
                      style: ZenText.kicker(letterSpacing: 3.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      session.label,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: ZenColors.ink,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _infoRow(
                      icon: Icons.format_list_numbered,
                      label: '出題数',
                      value: '全 ${session.totalQ} 問 (本番と同じ構成)',
                    ),
                    _infoRow(
                      icon: Icons.timer_outlined,
                      label: '制限時間',
                      value: '$hours 時間',
                    ),
                    _infoRow(
                      icon: Icons.visibility_off_outlined,
                      label: '採点',
                      value: '全問回答後にまとめて採点 (即時フィードバックなし)',
                    ),
                    _infoRow(
                      icon: Icons.swap_horiz,
                      label: '進み方',
                      value: '前後の問題に自由に移動できます',
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ZenColors.bgSub,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '模試試験の結果は、ふだんの「今日のN問」の進捗(Day・カレンダー)には'
                        '一切影響しません。本番さながらの環境で、仕上がり具合を確認するための'
                        'モードです。',
                        style: TextStyle(
                          fontSize: 12,
                          color: ZenColors.inkSub,
                          height: 1.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
              child: ZenPrimaryButton(
                label: _starting ? '準備中…' : 'この回の模試をはじめる',
                onPressed: _starting ? null : _start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ZenColors.accentSoft,
            ),
            child: Icon(icon, size: 16, color: ZenColors.accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: ZenColors.inkMute,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, color: ZenColors.ink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
