import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/domain/routine_progress.dart';

void main() {
  test('fresh routine starts at the first task with a peek at the second', () {
    final p = RoutineProgress([false, false, false]);
    expect(p.currentIndex, 0);
    expect(p.nextIndex, 1);
    expect(p.doneCount, 0);
    expect(p.isStarted, isFalse);
    expect(p.isComplete, isFalse);
  });

  test('advances past done tasks', () {
    final p = RoutineProgress([true, true, false, false]);
    expect(p.currentIndex, 2);
    expect(p.nextIndex, 3);
    expect(p.doneCount, 2);
    expect(p.isStarted, isTrue);
  });

  test('last task has no next', () {
    final p = RoutineProgress([true, true, false]);
    expect(p.currentIndex, 2);
    expect(p.nextIndex, isNull);
  });

  test('out-of-order completion: current is the first not done, next skips done ones', () {
    final p = RoutineProgress([false, true, false]);
    expect(p.currentIndex, 0);
    expect(p.nextIndex, 2);
  });

  test('all done is complete', () {
    final p = RoutineProgress([true, true]);
    expect(p.isComplete, isTrue);
    expect(p.currentIndex, isNull);
    expect(p.nextIndex, isNull);
  });

  test('empty routine is neither complete nor has a current task', () {
    final p = RoutineProgress([]);
    expect(p.isComplete, isFalse);
    expect(p.currentIndex, isNull);
  });
}
