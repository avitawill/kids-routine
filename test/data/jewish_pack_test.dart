import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/data/routine_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late RoutineRepository repo;
  final now = DateTime(2026, 10, 5, 7, 0);

  Future<List<String?>> keys(RoutineType type) async {
    final s = await repo.watchSession(type, now).first;
    return [for (final t in s.tasks) t.task.builtInKey];
  }

  setUp(() {
    db = makeTestDb();
    repo = RoutineRepository(db);
  });
  tearDown(() => db.close());

  test('off by default', () async {
    expect((await repo.watchChild().first).jewishPack, isFalse);
    expect(await keys(RoutineType.morning), isNot(contains('modeh_ani')));
  });

  test('turning it on places each task at a sensible position', () async {
    await repo.setJewishPack(true);
    expect((await repo.watchChild().first).jewishPack, isTrue);

    final morning = await keys(RoutineType.morning);
    expect(morning.take(3), ['modeh_ani', 'netilat_yadayim', 'wake_up']);
    expect(
      morning.indexOf('birchot_hashachar'),
      morning.indexOf('get_dressed') + 1,
    );
    expect(
      morning.indexOf('bracha_before_food'),
      morning.indexOf('breakfast') - 1,
    );

    final noon = await keys(RoutineType.noon);
    expect(noon.indexOf('bracha_before_food'), noon.indexOf('lunch') - 1);

    expect((await keys(RoutineType.evening)).last, 'shema_bedtime');
  });

  test('positions stay contiguous; turning on twice adds nothing', () async {
    await repo.setJewishPack(true);
    await repo.setJewishPack(true);
    final morning = await repo.getRoutine(RoutineType.morning);
    final items = await repo.watchRoutineItems(morning.id).first;
    expect([
      for (final (rt, _) in items) rt.position,
    ], List.generate(items.length, (i) => i));
    expect(items, hasLength(14));
  });

  test('works when the parent removed an anchor task', () async {
    final morning = await repo.getRoutine(RoutineType.morning);
    final items = await repo.watchRoutineItems(morning.id).first;
    final breakfast = items.firstWhere((i) => i.$2.builtInKey == 'breakfast');
    await repo.removeFromRoutine(breakfast.$1.id);
    await repo.setJewishPack(true);
    // No breakfast to go before: the blessing goes at the end.
    expect((await keys(RoutineType.morning)).last, 'bracha_before_food');
  });

  test('turning it off removes only the pack tasks; stars stay', () async {
    await repo.setJewishPack(true);
    final s = await repo.watchSession(RoutineType.morning, now).first;
    await repo.completeTask(s.routine.id, s.tasks.first.task.id, now);
    await repo.setJewishPack(false);
    final morning = await keys(RoutineType.morning);
    expect(morning, hasLength(10));
    expect(morning.first, 'wake_up');
    expect(await repo.watchStarBalance().first, 1);
  });

  test('seeded tasks have Spanish and English names', () async {
    final tasks = await db.select(db.tasks).get();
    for (final t in tasks) {
      expect(t.nameEs, isNotEmpty, reason: t.builtInKey);
      expect(t.nameEn, isNotEmpty, reason: t.builtInKey);
    }
  });

  test('language can be changed', () async {
    await repo.setLanguage(AppLanguage.es);
    expect((await repo.watchChild().first).language, AppLanguage.es);
  });
}
