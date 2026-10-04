import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/domain/timer_logic.dart';

void main() {
  final start = DateTime(2026, 10, 5, 7, 0);
  final timer = TaskTimer(startedAt: start, target: const Duration(minutes: 4));

  test('starts full and shrinks linearly', () {
    expect(timer.fractionRemaining(start), 1.0);
    expect(
      timer.fractionRemaining(start.add(const Duration(minutes: 1))),
      closeTo(0.75, 1e-9),
    );
    expect(
      timer.fractionRemaining(start.add(const Duration(minutes: 2))),
      closeTo(0.5, 1e-9),
    );
  });

  test('time up empties the pie but never goes negative', () {
    final at = start.add(const Duration(minutes: 4));
    expect(timer.isTimeUp(at), isTrue);
    expect(timer.fractionRemaining(at), 0.0);
    final late = start.add(const Duration(hours: 3));
    expect(timer.fractionRemaining(late), 0.0);
    expect(timer.isTimeUp(late), isTrue);
  });

  test('not time up just before the target', () {
    expect(
      timer.isTimeUp(start.add(const Duration(minutes: 3, seconds: 59))),
      isFalse,
    );
  });

  test('a clock before startedAt counts as no time elapsed', () {
    final before = start.subtract(const Duration(minutes: 5));
    expect(timer.elapsed(before), Duration.zero);
    expect(timer.fractionRemaining(before), 1.0);
  });

  test('zero-minute target is immediately up', () {
    final zero = TaskTimer(startedAt: start, target: Duration.zero);
    expect(zero.fractionRemaining(start), 0.0);
    expect(zero.isTimeUp(start), isTrue);
  });
}
