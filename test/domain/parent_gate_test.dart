import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/domain/parent_gate.dart';

void main() {
  test('factors are 3..9 and the answer is their product', () {
    final rng = Random(1);
    for (var i = 0; i < 500; i++) {
      final q = GateQuestion.random(rng);
      expect(q.a, inInclusiveRange(3, 9));
      expect(q.b, inInclusiveRange(3, 9));
      expect(q.check(q.a * q.b), isTrue);
      expect(q.check(q.a * q.b + 1), isFalse);
    }
  });

  test('a new question after a wrong answer is never the same one', () {
    final rng = Random(2);
    var q = GateQuestion.random(rng);
    for (var i = 0; i < 500; i++) {
      final next = GateQuestion.random(rng, notLike: q);
      expect((next.a, next.b), isNot((q.a, q.b)));
      q = next;
    }
  });

  test('hold time is 2 seconds', () {
    expect(gateHoldDuration, const Duration(seconds: 2));
  });
}
