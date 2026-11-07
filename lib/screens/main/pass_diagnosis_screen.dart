import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../data/services/diagnosis_service.dart';
import '../../providers/app_state.dart';
import '../../widgets/enso_circle.dart';
import '../../widgets/zen_widgets.dart';
import '../commerce/paywall_screen.dart';

/// 合格可能性診断画面 (有料限定)。
/// これまでの「今日のN問」「苦手復習」「模試試験」の全回答ログから、
/// 公式科目区分(関係法令・労働衛生・労働生理)ごとの正答率を集計し、
/// 公式合格基準 (各科目40%以上・総合60%以上) に対する達成度を表示する。
class PassDiagnosisScreen extends StatefulWidget {
  const PassDiagnosisScreen({super.key});

  @override
  State<PassDiagnosisScreen> createState() => _PassDiagnosisScreenState();
}

class _PassDiagnosisScreenState extends State<PassDiagnosisScreen> {
  PassDiagnosis? _diagnosis;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final appState = context.read<AppState>();
    final diagnosis = await appState.diagnosisService.diagnose(
      appState.examType,
    );
    if (!mounted) return;
    setState(() {
      _diagnosis = diagnosis;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final hasFullAccess = appState.hasFullAccess;

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
                          'PASS DIAGNOSIS',
                          style: ZenText.kicker(letterSpacing: 3.2),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '合格可能性診断',
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
            Expanded(
              child: !hasFullAccess
                  ? _LockedBody(onUpgrade: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PaywallScreen()),
                    ))
                  : _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ZenColors.accent,
                      ),
                    )
                  : _buildBody(context, _diagnosis!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PassDiagnosis diagnosis) {
    if (diagnosis.totalQuestions < DiagnosisService.minAnsweredForDiagnosis) {
      return _InsufficientDataBody(diagnosis: diagnosis);
    }

    final isLikelyPass = diagnosis.isLikelyPass;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isLikelyPass)
                  Container(
                    width: 190,
                    height: 190,
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
                  size: 220,
                  color: isLikelyPass ? ZenColors.gold : ZenColors.accent,
                  strokeBase: 11,
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
                        Text(
                          '${diagnosis.overallPercent}',
                          style: ZenText.bigNumber(),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '%',
                          style: TextStyle(
                            fontSize: 20,
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: isLikelyPass ? ZenColors.accentSoft : ZenColors.wrongSoft,
              borderRadius: BorderRadius.circular(ZenColors.radiusCard),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isLikelyPass ? Icons.check_circle : Icons.info_outline,
                  color: isLikelyPass ? ZenColors.accentDeep : ZenColors.wrong,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isLikelyPass
                        ? '現時点の正答傾向は、公式合格基準(総合60%・各科目40%以上)を満たしています。'
                        : diagnosis.overallRate < 0.6
                        ? '総合正答率が60%に届いていません。苦手復習や模試で底上げしましょう。'
                        : '総合は60%以上ですが、40%未満の科目(${diagnosis.failingSubjects.map((s) => s.subject.label).join('・')})があります。科目間のバランスが合格のカギです。',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isLikelyPass
                          ? ZenColors.accentDeep
                          : ZenColors.wrong,
                      height: 1.6,
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
          ...diagnosis.subjects.map((s) => _SubjectBar(score: s)),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ZenColors.bgSub,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'この診断は、これまでに解いた ${diagnosis.answeredQuestionCount} 問'
              '(今日のN問・苦手復習・模試試験の合計、同じ問題は最新の回答を採用)'
              'の正答傾向から算出した目安です。公式の合否判定を保証するものではありません。',
              style: const TextStyle(
                fontSize: 11,
                color: ZenColors.inkMute,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectBar extends StatelessWidget {
  final SubjectScore score;
  const _SubjectBar({required this.score});

  @override
  Widget build(BuildContext context) {
    final pass = score.passesSubjectMinimum;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ZenColors.card,
        border: Border.all(color: ZenColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                '${score.correct}/${score.total}問',
                style: const TextStyle(fontSize: 11, color: ZenColors.inkSub),
              ),
              const SizedBox(width: 10),
              Text(
                '${score.ratePercent}%',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: pass ? ZenColors.accent : ZenColors.wrong,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: score.rate.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: ZenColors.line,
                  valueColor: AlwaysStoppedAnimation(
                    pass ? ZenColors.accent : ZenColors.wrong,
                  ),
                ),
              ),
              // 合格ライン(40%)の目印
              Positioned(
                left: 0.4 *
                    (MediaQuery.of(context).size.width - 48 - 32),
                child: Container(width: 1.5, height: 6, color: ZenColors.ink),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '┆ 合格基準 40%',
              style: TextStyle(fontSize: 9, color: ZenColors.inkMute),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsufficientDataBody extends StatelessWidget {
  final PassDiagnosis diagnosis;
  const _InsufficientDataBody({required this.diagnosis});

  @override
  Widget build(BuildContext context) {
    final need = DiagnosisService.minAnsweredForDiagnosis;
    final have = diagnosis.answeredQuestionCount;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.query_stats,
              size: 56,
              color: ZenColors.inkMute,
            ),
            const SizedBox(height: 20),
            const Text(
              'もう少しデータが必要です',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ZenColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '診断には最低 $need 問の回答が必要です。\n(現在 $have 問)\n'
              '「今日のN問」や模試試験を進めると、\n正確な診断ができるようになります。',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: ZenColors.inkSub,
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LockedBody extends StatelessWidget {
  final VoidCallback onUpgrade;
  const _LockedBody({required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ZenColors.accentSoft,
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 32,
                color: ZenColors.accent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '合格可能性診断は有料版限定です',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: ZenColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '科目別の正答率から、公式合格基準\n(総合60%・各科目40%以上)への\n達成度を診断します。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: ZenColors.inkSub,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 28),
            ZenPrimaryButton(
              label: '有料版について見る',
              onPressed: onUpgrade,
            ),
          ],
        ),
      ),
    );
  }
}
