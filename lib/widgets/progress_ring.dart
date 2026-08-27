import 'package:flutter/material.dart';

import '../core/theme/zen_tokens.dart';

/// 試験選択カード用の円形プログレスリング。
/// completed → 金色 + ◎, in_progress/not_started → 深緑 + %数字
class ProgressRing extends StatelessWidget {
  final double progress; // 0.0-1.0
  final String status; // 'completed' | 'in_progress' | 'not_started'
  final double size;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.status,
    this.size = 34,
  });

  @override
  Widget build(BuildContext context) {
    final color = status == 'completed' ? ZenColors.gold : ZenColors.accent;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress,
              color: color,
              strokeWidth: size < 36 ? 2.5 : 3,
            ),
          ),
          Text(
            status == 'completed' ? '◎' : '${(progress * 100).round()}',
            style: TextStyle(
              fontSize: size < 36 ? 9 : 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = ZenColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, 3.14159 * 2, false, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    const startAngle = -3.14159 / 2;
    final sweep = 3.14159 * 2 * progress.clamp(0.0, 1.0);
    if (sweep > 0) {
      canvas.drawArc(rect, startAngle, sweep, false, fgPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// ExamSession の進捗状況から progress (0.0-1.0) を計算するヘルパー
double progressPctFor({required String status, required int day}) {
  if (status == 'completed') return 1.0;
  if (status == 'not_started') return 0.0;
  return (day / 7).clamp(0.0, 1.0);
}
