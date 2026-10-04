import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/domain/daily_summary.dart';
import 'package:kids_routine/domain/enums.dart';

void main() {
  final t0 = DateTime(2026, 10, 5, 7, 0);
  DateTime at(int min, [int sec = 0]) =>
      t0.add(Duration(minutes: min, seconds: sec));

  TaskLogEntry log(
    RoutineType r,
    int id,
    int pos,
    DateTime start,
    DateTime? done, {
    int target = 3,
  }) => TaskLogEntry(
    routine: r,
    taskId: id,
    position: pos,
    targetMinutes: target,
    startedAt: start,
    completedAt: done,
  );

  test('complete routine: start, finish, total and per-task time', () {
    final s = summarizeDay(
      [
        log(RoutineType.morning, 2, 1, at(2), at(6)),
        log(RoutineType.morning, 1, 0, at(0), at(2)),
      ],
      {RoutineType.morning: 2},
    );

    expect(s, hasLength(1));
    final m = s.single;
    expect(m.tasks.map((t) => t.taskId), [1, 2]); // routine order
    expect(m.isComplete, isTrue);
    expect(m.startedAt, at(0));
    expect(m.finishedAt, at(6));
    expect(m.total, const Duration(minutes: 6));
    expect(m.tasks[1].taken, const Duration(minutes: 4));
    expect(m.tasks[1].target, const Duration(minutes: 3));
  });

  test('unfinished routine has no finish time', () {
    final m = summarizeDay(
      [
        log(RoutineType.morning, 1, 0, at(0), at(2)),
        log(RoutineType.morning, 2, 1, at(2), null),
      ],
      {RoutineType.morning: 10},
    ).single;
    expect(m.isComplete, isFalse);
    expect(m.doneCount, 1);
    expect(m.finishedAt, isNull);
    expect(m.total, isNull);
    expect(m.tasks[1].taken, isNull);
  });

  test('routines come out in day order and empty ones are skipped', () {
    final s = summarizeDay(
      [
        log(RoutineType.evening, 5, 0, at(600), at(605)),
        log(RoutineType.morning, 1, 0, at(0), at(2)),
      ],
      {RoutineType.morning: 1, RoutineType.evening: 1},
    );
    expect(s.map((r) => r.routine), [RoutineType.morning, RoutineType.evening]);
  });
}
