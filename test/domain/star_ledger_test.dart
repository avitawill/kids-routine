import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/data/routine_repository.dart';
import 'package:kids_routine/domain/star_ledger.dart';

import '../helpers.dart';

void main() {
  group('StarRules', () {
    test('balance is the sum of deltas', () {
      expect(StarRules.balance([]), 0);
      expect(StarRules.balance([1, 1, 1, -2, 1]), 2);
    });

    test('only redemptions may be negative', () {
      expect(StarRules.isValidEntry(1, StarReason.taskDone), isTrue);
      expect(StarRules.isValidEntry(-1, StarReason.taskDone), isFalse);
      expect(StarRules.isValidEntry(0, StarReason.taskDone), isFalse);
      expect(StarRules.isValidEntry(-5, StarReason.redemption), isTrue);
      expect(StarRules.isValidEntry(5, StarReason.redemption), isFalse);
    });
  });

  group('ledger in the database', () {
    late AppDatabase db;
    late RoutineRepository repo;
    final now = DateTime(2026, 10, 5, 7, 10);

    setUp(() {
      db = makeTestDb();
      repo = RoutineRepository(db);
    });
    tearDown(() => db.close());

    test(
      'each completed task adds exactly one star, linked to its run log',
      () async {
        final s = await repo.watchSession(RoutineType.morning, now).first;
        expect(await repo.watchStarBalance().first, 0);

        for (final t in s.tasks.take(3)) {
          expect(await repo.completeTask(s.routine.id, t.task.id, now), isTrue);
        }

        expect(await repo.watchStarBalance().first, 3);
        final entries = await db.select(db.starLedger).get();
        final logs = await db.select(db.runLogs).get();
        expect(entries.map((e) => e.delta), everyElement(1));
        expect(entries.map((e) => e.reason), everyElement(StarReason.taskDone));
        expect(
          entries.map((e) => e.refId).toSet(),
          logs.map((l) => l.id).toSet(),
        );
        expect(entries.map((e) => e.date), everyElement('2026-10-05'));
      },
    );

    test('completing the same task twice in a day awards once', () async {
      final s = await repo.watchSession(RoutineType.morning, now).first;
      final task = s.tasks.first.task;
      expect(await repo.completeTask(s.routine.id, task.id, now), isTrue);
      expect(await repo.completeTask(s.routine.id, task.id, now), isFalse);
      expect(await repo.watchStarBalance().first, 1);
    });

    test('stars are kept across days and the next day starts fresh', () async {
      final s = await repo.watchSession(RoutineType.morning, now).first;
      final task = s.tasks.first.task;
      final tomorrow = now.add(const Duration(days: 1));
      await repo.completeTask(s.routine.id, task.id, now);
      await repo.completeTask(s.routine.id, task.id, tomorrow);

      expect(await repo.watchStarBalance().first, 2);
      final next = await repo.watchSession(RoutineType.morning, tomorrow).first;
      expect(next.progress.doneCount, 1);
    });
  });
}
