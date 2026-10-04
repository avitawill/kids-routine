import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/data/routine_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late RoutineRepository repo;
  final now = DateTime(2026, 10, 5, 7, 0);

  setUp(() {
    db = makeTestDb();
    repo = RoutineRepository(db);
  });
  tearDown(() => db.close());

  test('seeds a female, Hebrew child with a mascot', () async {
    final child = await repo.watchChild().first;
    expect(child.gender, Gender.female);
    expect(child.language, AppLanguage.he);
    expect(child.mascotName, isNotEmpty);
  });

  test('morning routine is seeded in order', () async {
    final s = await repo.watchSession(RoutineType.morning, now).first;
    expect(s.tasks.map((t) => t.task.builtInKey), [
      'wake_up', 'toilet', 'brush_teeth', 'wash_face', 'get_dressed', //
      'brush_hair', 'breakfast', 'pack_bag', 'shoes', 'coat',
    ]);
    expect(s.tasks.first.task.nameHe, 'קימה מהמיטה');
    expect(s.tasks.first.task.targetMinutes, 2);
    expect(s.current!.task.builtInKey, 'wake_up');
    expect(s.next!.task.builtInKey, 'toilet');
  });

  test('Jewish pack is seeded but not placed in any routine', () async {
    final jewish = await (db.select(
      db.tasks,
    )..where((t) => t.pack.equalsValue(TaskPack.jewish))).get();
    expect(jewish, hasLength(5));
    for (final type in RoutineType.values) {
      final s = await repo.watchSession(type, now).first;
      expect(s.tasks.map((t) => t.task.pack), everyElement(TaskPack.core));
    }
  });

  test(
    'ensureStarted keeps the first start time (timer survives restarts)',
    () async {
      final s = await repo.watchSession(RoutineType.morning, now).first;
      final task = s.current!.task;
      await repo.ensureStarted(s.routine.id, task.id, now);
      await repo.ensureStarted(
        s.routine.id,
        task.id,
        now.add(const Duration(minutes: 5)),
      );
      final after = await repo.watchSession(RoutineType.morning, now).first;
      expect(after.current!.runLog!.startedAt, now);
    },
  );

  test(
    'progression: completing tasks moves current and next until complete',
    () async {
      var s = await repo.watchSession(RoutineType.morning, now).first;
      final ids = [for (final t in s.tasks) t.task.id];
      for (var i = 0; i < ids.length; i++) {
        expect(s.current!.task.id, ids[i]);
        expect(s.next?.task.id, i + 1 < ids.length ? ids[i + 1] : null);
        await repo.completeTask(
          s.routine.id,
          ids[i],
          now.add(Duration(minutes: i)),
        );
        s = await repo.watchSession(RoutineType.morning, now).first;
      }
      expect(s.progress.isComplete, isTrue);
      expect(s.current, isNull);
    },
  );

  test('a task shared by two routines is tracked per routine', () async {
    final morning = await repo.watchSession(RoutineType.morning, now).first;
    final brush = morning.tasks.firstWhere(
      (t) => t.task.builtInKey == 'brush_teeth',
    );
    await repo.completeTask(morning.routine.id, brush.task.id, now);
    final evening = await repo.watchSession(RoutineType.evening, now).first;
    expect(
      evening.tasks
          .firstWhere((t) => t.task.builtInKey == 'brush_teeth')
          .isDone,
      isFalse,
    );
  });
}
