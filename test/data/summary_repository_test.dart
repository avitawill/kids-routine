import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/data/routine_repository.dart';
import 'package:kids_routine/data/summary_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late RoutineRepository repo;
  late SummaryRepository summary;
  final day = DateTime(2026, 10, 5, 7, 0);

  setUp(() {
    db = makeTestDb();
    repo = RoutineRepository(db);
    summary = SummaryRepository(db);
  });
  tearDown(() => db.close());

  test('per-task durations and stars for the day', () async {
    final s = await repo.watchSession(RoutineType.morning, day).first;
    final [first, second, ...] = s.tasks;
    await repo.ensureStarted(s.routine.id, first.task.id, day);
    await repo.completeTask(
      s.routine.id,
      first.task.id,
      day.add(const Duration(minutes: 3)),
    );
    await repo.ensureStarted(
      s.routine.id,
      second.task.id,
      day.add(const Duration(minutes: 3)),
    );

    final d = await summary.watchDay(day).first;
    expect(d.starsEarned, 1);
    final m = d.routines.single;
    expect(m.taskCount, 10);
    expect(m.doneCount, 1);
    expect(m.tasks.first.taken, const Duration(minutes: 3));
    expect(m.tasks[1].isDone, isFalse);
    expect(d.tasks[first.task.id]!.nameHe, 'קימה מהמיטה');
  });

  test('another day is empty', () async {
    final s = await repo.watchSession(RoutineType.morning, day).first;
    await repo.completeTask(s.routine.id, s.tasks.first.task.id, day);
    final d = await summary
        .watchDay(day.subtract(const Duration(days: 1)))
        .first;
    expect(d.routines, isEmpty);
    expect(d.starsEarned, 0);
  });
}
