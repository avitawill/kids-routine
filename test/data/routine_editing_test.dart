import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/data/routine_repository.dart';
import 'package:kids_routine/data/task_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late RoutineRepository repo;
  late TaskRepository tasks;
  late Routine morning;
  final now = DateTime(2026, 10, 5, 7, 0);

  Future<List<String?>> keys() async => [
    for (final (_, t) in await repo.watchRoutineItems(morning.id).first)
      t.builtInKey ?? t.nameHe,
  ];

  setUp(() async {
    db = makeTestDb();
    repo = RoutineRepository(db);
    tasks = TaskRepository(db, makeTestMedia());
    morning = await repo.watchRoutine(RoutineType.morning).first;
  });
  tearDown(() => db.close());

  test('reorder rewrites positions in the given order', () async {
    final items = await repo.watchRoutineItems(morning.id).first;
    final ids = [for (final (rt, _) in items) rt.id];
    await repo.reorder(morning.id, [ids[2], ids[0], ids[1], ...ids.skip(3)]);
    expect((await keys()).take(3), ['brush_teeth', 'wake_up', 'toilet']);
    final positions = [
      for (final (rt, _) in await repo.watchRoutineItems(morning.id).first)
        rt.position,
    ];
    expect(positions, List.generate(10, (i) => i));
  });

  test(
    'remove keeps positions contiguous and the task in the library',
    () async {
      final items = await repo.watchRoutineItems(morning.id).first;
      await repo.removeFromRoutine(items[1].$1.id); // toilet
      expect(await keys(), isNot(contains('toilet')));
      final positions = [
        for (final (rt, _) in await repo.watchRoutineItems(morning.id).first)
          rt.position,
      ];
      expect(positions, List.generate(9, (i) => i));
      final library = await tasks.watchLibrary().first;
      expect(library.map((t) => t.builtInKey), contains('toilet'));
    },
  );

  test(
    'add appends a custom task at the end; it then shows in the session',
    () async {
      final id = await tasks.createTask(
        TasksCompanion.insert(
          nameHe: 'האכלת הכלב',
          targetMinutes: 2,
          pack: TaskPack.core,
        ),
      );
      await repo.addToRoutine(morning.id, id);
      expect((await keys()).last, 'האכלת הכלב');
      final created = await tasks.getTask(id);
      expect(created!.pack, TaskPack.custom); // forced, whatever was passed
      expect(created.isBuiltIn, isFalse);
      final s = await repo.watchSession(RoutineType.morning, now).first;
      expect(s.tasks.last.task.id, id);
    },
  );

  test('removing a done task mid-day keeps progress consistent', () async {
    var s = await repo.watchSession(RoutineType.morning, now).first;
    await repo.completeTask(morning.id, s.tasks[0].task.id, now);
    final items = await repo.watchRoutineItems(morning.id).first;
    await repo.removeFromRoutine(items[0].$1.id);
    s = await repo.watchSession(RoutineType.morning, now).first;
    expect(s.progress.doneCount, 0);
    expect(s.current!.task.builtInKey, 'toilet');
    expect(await repo.watchStarBalance().first, 1); // the star stays
  });

  test('routine settings update', () async {
    await repo.updateRoutine(
      morning.id,
      startMinutes: 6 * 60 + 45,
      daysOfWeek: 0x1f,
      reminderEnabled: true,
    );
    final r = await repo.watchRoutine(RoutineType.morning).first;
    expect(r.startMinutes, 405);
    expect(r.daysOfWeek, 0x1f);
    expect(r.reminderEnabled, isTrue);
  });

  test('built-in tasks cannot be deleted; custom ones can', () async {
    final library = await tasks.watchLibrary().first;
    expect(await tasks.deleteCustomTask(library.first.id), isFalse);
    final id = await tasks.createTask(
      TasksCompanion.insert(
        nameHe: 'x',
        targetMinutes: 1,
        pack: TaskPack.custom,
      ),
    );
    await repo.addToRoutine(morning.id, id);
    expect(await tasks.deleteCustomTask(id), isTrue);
    expect(await keys(), isNot(contains('x')));
  });

  test('child settings update', () async {
    await repo.updateChild(
      name: ' נועה ',
      gender: Gender.male,
      mascotName: 'בובו',
    );
    final c = await repo.watchChild().first;
    expect(c.name, 'נועה');
    expect(c.gender, Gender.male);
    expect(c.mascotName, 'בובו');
  });
}
