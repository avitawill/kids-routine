import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/data/routine_repository.dart';
import 'package:kids_routine/domain/routine_progress.dart';

import '../helpers.dart';

void main() {
  group('RoutineProgress with a chosen task', () {
    test('the chosen not-done task is current; next is the first other', () {
      final p = RoutineProgress([true, false, false, false]).withCurrent(3);
      expect(p.currentIndex, 3);
      expect(p.nextIndex, 1);
    });

    test('a done or invalid choice falls back to the first not done', () {
      expect(RoutineProgress([true, false]).withCurrent(0).currentIndex, 1);
      expect(RoutineProgress([false, false]).withCurrent(9).currentIndex, 0);
    });

    test('last one left has no next', () {
      final p = RoutineProgress([true, false, true]).withCurrent(1);
      expect(p.nextIndex, isNull);
    });
  });

  group('repository', () {
    late AppDatabase db;
    late RoutineRepository repo;
    final t0 = DateTime(2026, 10, 5, 7, 0);
    DateTime at(int min) => t0.add(Duration(minutes: min));

    setUp(() {
      db = makeTestDb();
      repo = RoutineRepository(db);
    });
    tearDown(() => db.close());

    Future<RoutineSession> session([DateTime? now]) =>
        repo.watchSession(RoutineType.morning, now ?? t0).first;

    test('tasks can be done in any order; each earns its star', () async {
      final s = await session();
      final third = s.tasks[2].task;
      expect(await repo.completeTask(s.routine.id, third.id, at(1)), isTrue);
      final after = await session();
      expect(after.tasks[2].isDone, isTrue);
      expect(after.current!.task.id, s.tasks[0].task.id);
      expect(await repo.watchStarBalance().first, 1);
    });

    test('a paused task starts its timer over when it comes back', () async {
      final s = await session();
      final first = s.tasks[0].task;
      await repo.ensureStarted(s.routine.id, first.id, t0);
      await repo.pauseTask(s.routine.id, first.id, at(1));
      expect((await session()).tasks[0].runLog!.startedAt, isNull);
      await repo.ensureStarted(s.routine.id, first.id, at(5));
      expect((await session()).tasks[0].runLog!.startedAt, at(5));
    });

    test('a running timer is kept (survives app restarts)', () async {
      final s = await session();
      final first = s.tasks[0].task;
      await repo.ensureStarted(s.routine.id, first.id, t0);
      await repo.ensureStarted(s.routine.id, first.id, at(3));
      expect((await session()).tasks[0].runLog!.startedAt, t0);
    });

    test('pausing never touches a done task', () async {
      final s = await session();
      final first = s.tasks[0].task;
      await repo.completeTask(s.routine.id, first.id, at(2));
      await repo.pauseTask(s.routine.id, first.id, at(3));
      expect((await session()).tasks[0].isDone, isTrue);
    });

    test('unchecking reopens a task, keeps the star, and redoing it '
        'earns no second star', () async {
      final s = await session();
      final first = s.tasks[0].task;
      await repo.completeTask(s.routine.id, first.id, at(2));
      expect(await repo.watchStarBalance().first, 1);

      await repo.uncheckTask(s.routine.id, first.id, t0);
      final reopened = await session();
      expect(reopened.tasks[0].isDone, isFalse);
      expect(reopened.current!.task.id, first.id);
      expect(await repo.watchStarBalance().first, 1);

      expect(await repo.completeTask(s.routine.id, first.id, at(9)), isTrue);
      expect((await session()).tasks[0].isDone, isTrue);
      expect(await repo.watchStarBalance().first, 1);
    });

    test(
      'restarting a routine for today reopens every task; stars stay',
      () async {
        final s = await session();
        for (final t in s.tasks.take(4)) {
          await repo.completeTask(s.routine.id, t.task.id, at(1));
        }
        await repo.resetRoutineToday(s.routine.id, t0);
        final again = await session();
        expect(again.progress.doneCount, 0);
        expect(again.current!.task.id, s.tasks[0].task.id);
        expect(await repo.watchStarBalance().first, 4);
      },
    );

    test('corrections only touch the given day', () async {
      final s = await session();
      final first = s.tasks[0].task;
      final yesterday = t0.subtract(const Duration(days: 1));
      await repo.completeTask(s.routine.id, first.id, yesterday);
      await repo.resetRoutineToday(s.routine.id, t0);
      expect((await session(yesterday)).tasks[0].isDone, isTrue);
    });
  });
}
