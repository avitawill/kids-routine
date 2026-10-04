import 'dart:math' as math;

import 'package:flutter/material.dart';

enum MascotMood { idle, cheer, wave }

/// The app's own mascot: a round, mint-green cub drawn in code.
/// Static poses for now; animations come in M4.
class Mascot extends StatelessWidget {
  const Mascot({super.key, this.mood = MascotMood.idle, this.size = 120});

  final MascotMood mood;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(size: Size.square(size), painter: MascotPainter(mood)),
    );
  }
}

class MascotPainter extends CustomPainter {
  MascotPainter(this.mood);

  final MascotMood mood;

  static const _body = Color(0xFF7FD4B4);
  static const _bodyDark = Color(0xFF4DB38E);
  static const _belly = Color(0xFFE6FAF1);
  static const _cheek = Color(0xFFFFB3A7);
  static const _ink = Color(0xFF2D2A4A);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final c = Offset(s / 2, s * 0.56);
    final r = s * 0.36;
    final fill = Paint()..isAntiAlias = true;

    // Arms behind the body.
    void arm(double angle) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(angle);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-s * 0.06, -r - s * 0.16, s * 0.12, s * 0.24),
          Radius.circular(s * 0.06),
        ),
        fill..color = _bodyDark,
      );
      canvas.restore();
    }

    final (left, right) = switch (mood) {
      MascotMood.idle => (-2.3, 2.3),
      MascotMood.cheer => (-0.6, 0.6),
      MascotMood.wave => (-2.3, 0.45),
    };
    arm(left);
    arm(right);

    // Ears.
    for (final dx in [-1, 1]) {
      final ear = c + Offset(dx * r * 0.68, -r * 0.82);
      canvas.drawCircle(ear, s * 0.11, fill..color = _bodyDark);
      canvas.drawCircle(ear, s * 0.06, fill..color = _belly);
    }

    // Body and belly.
    canvas.drawCircle(c, r, fill..color = _body);
    canvas.drawOval(
      Rect.fromCenter(
        center: c + Offset(0, r * 0.38),
        width: r * 1.1,
        height: r * 0.8,
      ),
      fill..color = _belly,
    );

    // Eyes: happy arcs when cheering, dots otherwise.
    final eyeY = c.dy - r * 0.18;
    final stroke = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.03
      ..strokeCap = StrokeCap.round;
    for (final dx in [-1, 1]) {
      final eye = Offset(c.dx + dx * r * 0.36, eyeY);
      if (mood == MascotMood.cheer) {
        canvas.drawArc(
          Rect.fromCircle(center: eye, radius: s * 0.05),
          math.pi,
          math.pi,
          false,
          stroke,
        );
      } else {
        canvas.drawCircle(eye, s * 0.04, fill..color = _ink);
        canvas.drawCircle(
          eye + Offset(s * 0.012, -s * 0.014),
          s * 0.012,
          fill..color = Colors.white,
        );
      }
      canvas.drawCircle(
        Offset(c.dx + dx * r * 0.62, eyeY + r * 0.28),
        s * 0.05,
        fill..color = _cheek.withValues(alpha: 0.8),
      );
    }

    // Nose and smile.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx, eyeY + r * 0.2),
        width: s * 0.07,
        height: s * 0.05,
      ),
      fill..color = _ink,
    );
    final smile = Rect.fromCircle(
      center: Offset(c.dx, eyeY + r * 0.24),
      radius: mood == MascotMood.cheer ? s * 0.09 : s * 0.07,
    );
    if (mood == MascotMood.cheer) {
      canvas.drawArc(smile, 0, math.pi, true, fill..color = _ink);
    } else {
      canvas.drawArc(smile, 0.3, math.pi - 0.6, false, stroke);
    }
  }

  @override
  bool shouldRepaint(MascotPainter old) => old.mood != mood;
}
