import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/database/app_database.dart';
import '../../providers/app_state.dart';
import '../../providers/quiz_session_provider.dart';
import 'paywall_screen.dart';
import '../quiz/mock_exam_intro_screen.dart';

/// 模試試験モード · 試験回選択画面 (有料限定)。
/// 既存の14回の過去問から、ユーザーが好きな回を選んで模試形式
/// (全問・時間制限あり) で演習できる。
class MockExamSelectorScreen extends StatefulWidget {
  const MockExamSelectorScreen({super.key});

  @override
  State<MockExamSelectorScreen> createState() =>
      _MockExamSelectorScreenState();
}

class _MockExamSelectorScreenState extends State<MockExamSelectorScreen> {
  List<ExamSession> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final appState = context.read<AppState>();
    final all = await appState.examRepo.getAllSessions();
    final filtered = all.where((s) => s.examType == appState.examType).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (!mounted) return;
    setState(() {
      _sessions = filtered;
      _loading = false;
    });
  }

  void _goToPaywall() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PaywallScreen()));
  }

  Future<void> _selectSession(ExamSession session) async {
    final quiz = context.read<QuizSessionProvider>();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MockExamIntroScreen(session: session, quiz: quiz),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final hasFullAccess = appState.hasFullAccess;

    if (_loading) {
      return const Scaffold(
        backgroundColor: ZenColors.bg,
        body: Center(child: CircularProgressIndicator(color: ZenColors.accent)),
      );
    }

    return Scaffold(
      backgroundColor: ZenColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 20, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 2, right: 8),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: ZenColors.inkSub,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MOCK EXAM',
                          style: ZenText.kicker(letterSpacing: 3.2),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '模試試験 · 回を選ぶ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: ZenColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
              child: Text(
                '選んだ回の全問題を、本番と同じ構成・制限時間で解きます。',
                style: const TextStyle(
                  fontSize: 12,
                  color: ZenColors.inkSub,
                  height: 1.6,
                ),
              ),
            ),
            if (!hasFullAccess)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: _LockedBanner(onTap: _goToPaywall),
              ),
            Expanded(
              child: hasFullAccess
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _sessions.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.5,
                            ),
                        itemBuilder: (context, i) {
                          final session = _sessions[i];
                          return _MockExamCard(
                            session: session,
                            onTap: () => _selectSession(session),
                          );
                        },
                      ),
                    )
                  : Opacity(
                      opacity: 0.4,
                      child: IgnorePointer(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _sessions.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 1.5,
                                ),
                            itemBuilder: (context, i) {
                              final session = _sessions[i];
                              return _MockExamCard(
                                session: session,
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockedBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _LockedBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: ZenColors.card,
          border: Border.all(color: ZenColors.accent, width: 1.5),
          borderRadius: BorderRadius.circular(ZenColors.radiusCard),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ZenColors.accentSoft,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 18,
                color: ZenColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '模試試験モードは有料版限定です',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ZenColors.accentDeep,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'タップして詳細を見る',
                    style: TextStyle(fontSize: 11, color: ZenColors.inkSub),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: ZenColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}

class _MockExamCard extends StatelessWidget {
  final ExamSession session;
  final VoidCallback onTap;

  const _MockExamCard({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 12),
        decoration: BoxDecoration(
          color: ZenColors.card,
          borderRadius: BorderRadius.circular(ZenColors.radiusCard),
          border: Border.all(color: ZenColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              session.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ZenColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '全${session.totalQ}問 · 制限3時間',
              style: const TextStyle(fontSize: 10, color: ZenColors.inkMute),
            ),
          ],
        ),
      ),
    );
  }
}
