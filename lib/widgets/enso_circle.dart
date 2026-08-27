import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../core/theme/zen_tokens.dart';

/// 円相 (Enso) — 花丸のシンボル。
/// stroke-dasharray アニメーションで筆致を描く SVG 相当を CustomPainter で再現。
/// [animate]=true の場合、900ms cubic-bezier(0.25,0.5,0.3,1) で描画される。
class EnsoCircle extends StatefulWidget {
  final double size;
  final Color color;
  final double strokeBase;
  final bool animate;
  final bool pulse; // gentle-pulse loop (満点 Result 画面用)

  const EnsoCircle({
    super.key,
    this.size = 200,
    this.color = ZenColors.gold,
    this.strokeBase = 8,
    this.animate = false,
    this.pulse = false,
  });

  @override
  State<EnsoCircle> createState() => _EnsoCircleState();
}

class _EnsoCircleState extends State<EnsoCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawController;
  AnimationController? _pulseController;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      vsync: this,
      duration: ZenMotion.ceremony,
    );
    if (widget.animate) {
      _drawController.forward();
    } else {
      _drawController.value = 1.0;
    }

    if (widget.pulse) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _drawController.dispose();
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget painter = AnimatedBuilder(
      animation: _drawController,
      builder: (context, _) {
        final progress = ZenMotion.enso.transform(_drawController.value);
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _EnsoPainter(
            color: widget.color,
            strokeBase: widget.strokeBase,
            progress: progress,
          ),
        );
      },
    );

    if (_pulseController != null) {
      painter = AnimatedBuilder(
        animation: _pulseController!,
        builder: (context, child) {
          final scale =
              1.0 + (math.sin(_pulseController!.value * math.pi) * 0.02);
          return Transform.scale(scale: scale, child: child);
        },
        child: painter,
      );
    }

    return SizedBox(width: widget.size, height: widget.size, child: painter);
  }
}

class _EnsoPainter extends CustomPainter {
  final Color color;
  final double strokeBase;
  final double progress; // 0..1

  _EnsoPainter({
    required this.color,
    required this.strokeBase,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // 円相は一周をわずかに残して筆を離す(実物の円相らしさ)
    // 開始角度は -30deg 相当から時計回りに約332degまで描く
    const startAngle = -math.pi / 2 - math.pi / 6; // 上部よりやや左から開始
    const totalArc = math.pi * 2 * 0.94; // 340度程度描いて隙間を残す

    final sweep = totalArc * progress;
    if (sweep <= 0) return;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // dry-brush 風の薄いレイヤー (内側)
    final innerPaint = Paint()
      ..color = color.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeBase * 0.4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweep * 0.98, false, innerPaint);

    // メインの筆致 (グラデーションで先端が薄くなる)
    final mainPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeBase
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0,
        endAngle: math.pi * 2,
        transform: GradientRotation(startAngle),
        colors: [
          color,
          color,
          color.withValues(alpha: 0.5),
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.6, 0.85, 0.941, 1.0],
      ).createShader(rect);
    canvas.drawArc(rect, startAngle, sweep, false, mainPaint);
  }

  @override
  bool shouldRepaint(covariant _EnsoPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeBase != strokeBase;
  }
}
