import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/ui/task/pie_timer.dart';

void main() {
  test('the empty part grows clockwise from 12 o\'clock', () {
    // Full: wedge starts at 12 o'clock.
    expect(PiePainter.startAngle(1), closeTo(-math.pi / 2, 1e-9));
    // A quarter used: wedge starts at 3 o'clock (clockwise in canvas coords).
    expect(PiePainter.startAngle(0.75), closeTo(0, 1e-9));
    // Half used: wedge starts at 6 o'clock.
    expect(PiePainter.startAngle(0.5), closeTo(math.pi / 2, 1e-9));
  });

  testWidgets('is not mirrored in RTL', (tester) async {
    Future<PiePainter> paintedIn(TextDirection dir) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: dir,
          child: const PieTimer(
            fraction: 0.6,
            color: Colors.blue,
            trackColor: Colors.white,
            child: SizedBox.square(dimension: 100),
          ),
        ),
      );
      expect(find.byType(Transform), findsNothing);
      return tester.widget<CustomPaint>(find.byType(CustomPaint)).painter!
          as PiePainter;
    }

    final ltr = await paintedIn(TextDirection.ltr);
    final rtl = await paintedIn(TextDirection.rtl);
    expect(rtl.fraction, ltr.fraction);
  });
}
