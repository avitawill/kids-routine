import 'dart:math';

/// The grown-up check behind the gear: a times-table question a young child
/// can't answer but a parent can at a glance.
class GateQuestion {
  const GateQuestion(this.a, this.b);

  final int a;
  final int b;

  int get answer => a * b;

  bool check(int value) => value == answer;

  /// Factors from 3 to 9, never the same question twice in a row.
  static GateQuestion random(Random rng, {GateQuestion? notLike}) {
    while (true) {
      final q = GateQuestion(3 + rng.nextInt(7), 3 + rng.nextInt(7));
      if (notLike == null || q.a != notLike.a || q.b != notLike.b) return q;
    }
  }
}

/// How long the gear must be held before the question appears.
const gateHoldDuration = Duration(seconds: 2);
