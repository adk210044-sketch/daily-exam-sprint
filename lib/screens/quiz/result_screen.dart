import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/zen_tokens.dart';
import '../../providers/quiz_session_provider.dart';
import '../../widgets/ad_banner_widget.dart';
import '../../widgets/enso_circle.dart';
import '../../widgets/zen_widgets.dart';
import 'explanation_screen.dart';
import 'question_screen.dart';

/// 結果メッセージ (タイトル + サブテキスト) のペア。
class _ResultMessage {
  final String title;
  final String sub;
  const _ResultMessage(this.title, this.sub);
}

/// スコア帯 (カレンダーの ◎○△ と同じ閾値: 100 / 60 / 40) ごとに
/// 複数のメッセージパターンを用意し、ランダムに1つを選ぶ。
/// これにより同じスコア帯でも毎回同じ文言にならず、単調さを防ぐ。
const List<_ResultMessage> _tierHanamaru = [
  _ResultMessage('満点。お見事。', '本日のカレンダーに ◎ を刻みました。'),
  _ResultMessage('文句なしの満点。', '積み重ねが、いま結果になりました。'),
  _ResultMessage('完璧です。', 'この調子で、次のDayも。'),
  _ResultMessage('全問正解。', '迷いのない9問でした。'),
];

const List<_ResultMessage> _tierGood = [
  // 60%以上100%未満 (カレンダー○相当)
  _ResultMessage('いい調子です。', 'あと少しで満点。惜しい問題を見直しましょう。'),
  _ResultMessage('よく解けています。', '間違えた問題だけ、もう一度確認しておきましょう。'),
  _ResultMessage('順調です。', '着実に力がついています。'),
  _ResultMessage('good pace です。', '解説を見て、抜け漏れを埋めておきましょう。'),
];

const List<_ResultMessage> _tierOkay = [
  // 40%以上60%未満 (カレンダー△相当)
  _ResultMessage('あと少し。', '同じ問題、もう一度挑戦できます。'),
  _ResultMessage('伸びしろあり。', '解説を読んでから、もう一度挑んでみましょう。'),
  _ResultMessage('半分は掴めています。', '間違いは伸びる種。焦らず一つずつ。'),
  _ResultMessage('ここからが本番。', '苦手を知れたのは、今日の収穫です。'),
];

const List<_ResultMessage> _tierLow = [
  // 40%未満
  _ResultMessage('まずは一歩目。', '解説をじっくり読んで、もう一度挑戦しましょう。'),
  _ResultMessage('慣れていく途中です。', 'まだまだこれから。焦らず続けましょう。'),
  _ResultMessage('大丈夫、ここから。', '解説を読んで、同じ問題に再挑戦してみましょう。'),
  _ResultMessage('今日は種まきの日。', '繰り返すほど、選択肢の言い回しに慣れていきます。'),
];

_ResultMessage _pickResultMessage(int score, bool hanamaru) {
  final List<_ResultMessage> pool;
  if (hanamaru || score >= 100) {
    pool = _tierHanamaru;
  } else if (score >= 60) {
    pool = _tierGood;
  } else if (score >= 40) {
    pool = _tierOkay;
  } else {
    pool = _tierLow;
  }
  return pool[Random().nextInt(pool.length)];
}

/// Result (ZenResult) — スコア + 花丸 (円相ceremony)。体験のハイライト。
class ResultScreen extends StatefulWidget {
  final int score; // 0-100
  final bool hanamaru;

  const ResultScreen({super.key, required this.score, required this.hanamaru});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final _ResultMessage _message;

  @override
  void initState() {
    super.initState();
    // メッセージは画面表示時に1回だけ抽選し、以後の再ビルドでは固定する。
    _message = _pickResultMessage(widget.score, widget.hanamaru);
    if (widget.hanamaru) {
      // 満点時: heavy haptic (花丸描画開始と同時)
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hanamaru = widget.hanamaru;
    final quiz = context.read<QuizSessionProvider>();

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
                    'DAY ${quiz.day}  ·  ATTEMPT ${quiz.attempt}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: ZenColors.inkMute,
                      letterSpacing: 1.6,
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
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
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (hanamaru)
                            Container(
                              width: 240,
                              height: 240,
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
                          hanamaru
                              ? const EnsoCircle(
                                  size: 280,
                                  color: ZenColors.gold,
                                  strokeBase: 14,
                                  animate: true,
                                  pulse: true,
                                )
                              : CustomPaint(
                                  size: const Size(280, 280),
                                  painter: _PlainCirclePainter(),
                                ),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            builder: (context, v, child) =>
                                Opacity(opacity: v, child: child),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '正 答 率',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: ZenColors.inkSub,
                                    letterSpacing: 2.4,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${widget.score}',
                                      style: ZenText.heroNumber(),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '%',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w300,
                                        color: ZenColors.inkSub,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, v, child) =>
                          Opacity(opacity: v, child: child),
                      child: Column(
                        children: [
                          Text(
                            _message.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2.2,
                              color: ZenColors.ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _message.sub,
                            style: const TextStyle(
                              fontSize: 12,
                              color: ZenColors.inkSub,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _CategoryBreakdown(quiz: quiz),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const AdBannerWidget(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: Column(
                children: [
                  ZenPrimaryButton(
                    label: '解説をまとめて見る',
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const ExplanationScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  ZenTextLink(
                    label: 'もう一度、同じ問題に挑む',
                    onPressed: () async {
                      final sid = quiz.sessionId;
                      if (sid != null) {
                        await quiz.startDaily(sid);
                      }
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const QuestionScreen(),
                          ),
                        );
                      }
                    },
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

class _CategoryBreakdown extends StatelessWidget {
  final QuizSessionProvider quiz;
  const _CategoryBreakdown({required this.quiz});

  @override
  Widget build(BuildContext context) {
    // カテゴリ別の正解数を集計
    final totalByCategory = <String, int>{};
    final correctByCategory = <String, int>{};
    for (var i = 0; i < quiz.questions.length; i++) {
      final q = quiz.questions[i];
      final label = kCategoryShort[q.categoryName] ?? q.categoryName;
      totalByCategory[label] = (totalByCategory[label] ?? 0) + 1;
      final chosen = quiz.chosenAnswers[i];
      if (chosen != null && chosen == q.correctIndex) {
        correctByCategory[label] = (correctByCategory[label] ?? 0) + 1;
      }
    }
    final entries = totalByCategory.entries.toList();

    return Row(
      children: entries.map((e) {
        final correct = correctByCategory[e.key] ?? 0;
        final total = e.value;
        final full = correct == total;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: ZenColors.card,
              border: Border.all(color: ZenColors.line),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  e.key,
                  style: const TextStyle(
                    fontSize: 9,
                    color: ZenColors.inkMute,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$correct',
                        style: TextStyle(
                          fontSize: 15,
                          color: full ? ZenColors.accent : ZenColors.ink,
                          letterSpacing: -0.4,
                        ),
                      ),
                      TextSpan(
                        text: '/$total',
                        style: const TextStyle(
                          fontSize: 10,
                          color: ZenColors.inkMute,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PlainCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ZenColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.4,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
