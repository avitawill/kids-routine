import 'dart:math' as math;

import 'package:flutter/material.dart';

enum MascotMood { idle, cheer, wave }

/// The app's own mascot: a round, mint-green cub drawn in code.
///
/// Each mood plays one short move (at most 1.5 s) and then rests, so it
/// never competes with the task for attention: idle blinks now and then, wave
/// waves once, cheer hops twice. With the system's "remove animations" setting
/// it holds still.
class Mascot extends StatefulWidget {
  const Mascot({super.key, this.mood = MascotMood.idle, this.size = 120});

  final MascotMood mood;
  final double size;

  @override
  State<Mascot> createState() => _MascotState();
}

class _MascotState extends State<Mascot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this);

  /// One cycle: the move plays at the start, the rest of the cycle is a rest.
  static Duration _cycle(MascotMood mood) => switch (mood) {
    MascotMood.idle => const Duration(seconds: 4),
    MascotMood.wave => const Duration(milliseconds: 3600),
    MascotMood.cheer => const Duration(milliseconds: 2400),
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restart();
  }

  @override
  void didUpdateWidget(Mascot old) {
    super.didUpdateWidget(old);
    if (old.mood != widget.mood) _restart();
  }

  void _restart() {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _c.stop();
      _c.value = 0;
      return;
    }
    _c
      ..duration = _cycle(widget.mood)
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => CustomPaint(
            size: Size.square(widget.size),
            painter: MascotPainter(widget.mood, phase: _c.value),
          ),
        ),
      ),
    );
  }
}

class MascotPainter extends CustomPainter {
  /// [phase] is the position in the mood's cycle, 0..1. At 0 every mood is in
  /// its resting pose.
  MascotPainter(this.mood, {this.phase = 0});

  final MascotMood mood;
  final double phase;

  static const _body = Color(0xFF7FD4B4);
  static const _bodyDark = Color(0xFF4DB38E);
  static const _belly = Color(0xFFE6FAF1);
  static const _cheek = Color(0xFFFFB3A7);
  static const _ink = Color(0xFF2D2A4A);

  /// 0..1 within the active part of a cycle, or null while resting.
  static double? _active(double phase, double fraction) =>
      phase < fraction ? phase / fraction : null;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    var c = Offset(s / 2, s * 0.56);
    final r = s * 0.36;
    final fill = Paint()..isAntiAlias = true;

    var (left, right) = switch (mood) {
      MascotMood.idle => (-2.3, 2.3),
      MascotMood.cheer => (-0.6, 0.6),
      MascotMood.wave => (-2.3, 0.45),
    };
    var blink = false;

    switch (mood) {
      case MascotMood.idle:
        blink = phase > 0.95 && phase < 0.99; // ~160 ms
      case MascotMood.wave:
        final a = _active(phase, 1.2 / 3.6); // 1.2 s of waving
        if (a != null) right += 0.4 * math.sin(a * 3 * 2 * math.pi);
      case MascotMood.cheer:
        final a = _active(phase, 1.2 / 2.4); // two hops in 1.2 s
        if (a != null) {
          final hop = math.sin(a * 2 * math.pi).abs();
          c = c.translate(0, -hop * s * 0.07);
          left -= hop * 0.25;
          right += hop * 0.25;
        }
    }

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

    // Eyes: happy arcs when cheering, a line when blinking, dots otherwise.
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
      } else if (blink) {
        canvas.drawLine(
          eye - Offset(s * 0.04, 0),
          eye + Offset(s * 0.04, 0),
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
  bool shouldRepaint(MascotPainter old) =>
      old.mood != mood || old.phase != phase;
}
