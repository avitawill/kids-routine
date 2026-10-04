import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A colored disc that shrinks clockwise from 12 o'clock as time passes,
/// with [child] (the task picture) in the middle.
///
/// Deliberately NOT mirrored in RTL: clocks run clockwise in every language.
/// CustomPaint ignores Directionality, so this stays correct as long as no
/// one wraps it in a flipping Transform.
class PieTimer extends StatelessWidget {
  const PieTimer({
    super.key,
    required this.fraction,
    required this.color,
    required this.trackColor,
    required this.child,
  });

  /// 1.0 = full, 0.0 = empty.
  final double fraction;
  final Color color;
  final Color trackColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PiePainter(
        fraction: fraction,
        color: color,
        trackColor: trackColor,
      ),
      child: child,
    );
  }
}

class PiePainter extends CustomPainter {
  PiePainter({
    required this.fraction,
    required this.color,
    required this.trackColor,
  });

  final double fraction;
  final Color color;
  final Color trackColor;

  /// Angle where the remaining wedge starts. The empty part grows clockwise
  /// from 12 o'clock, so the colored wedge always ends at 12 o'clock.
  static double startAngle(double fraction) =>
      -math.pi / 2 + (1 - fraction) * 2 * math.pi;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()..isAntiAlias = true;
    canvas.drawOval(rect, paint..color = trackColor);
    if (fraction > 0) {
      canvas.drawArc(
        rect,
        startAngle(fraction),
        fraction * 2 * math.pi,
        true,
        paint..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(PiePainter old) =>
      old.fraction != fraction ||
      old.color != color ||
      old.trackColor != trackColor;
}
