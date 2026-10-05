import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/data/reward_repository.dart';
import 'package:kids_routine/data/routine_repository.dart';
import 'package:kids_routine/data/task_repository.dart';
import 'package:kids_routine/services/backup.dart';
import 'package:kids_routine/services/media_store.dart';

import '../helpers.dart';

void main() {
  final now = DateTime(2026, 10, 5, 8, 0);

  /// A database with some of everything: a custom task with a photo and a
  /// recording, stars, a redeemed reward, the Jewish pack on.
  Future<(AppDatabase, MediaStore)> populated() async {
    final db = makeTestDb();
    final media = makeTestMedia();
    final routines = RoutineRepository(db);
    final tasks = TaskRepository(db, media);
    final rewards = RewardRepository(db, media);

    await routines.updateChild(
      name: 'נועה',
      gender: Gender.female,
      mascotName: 'פומי',
    );
    await routines.setJewishPack(true);
    final photo = media.newPath('photos', 'jpg');
    media.resolve(photo).writeAsBytesSync([1, 2, 3]);
    final audio = media.newPath('audio', 'm4a');
    media.resolve(audio).writeAsBytesSync([4, 5, 6, 7]);
    final id = await tasks.createTask(
      TasksCompanion.insert(
        nameHe: 'האכלת הכלב',
        targetMinutes: 2,
        pack: TaskPack.custom,
        photoPath: Value(photo),
        audioPath: Value(audio),
      ),
    );
    final morning = await routines.getRoutine(RoutineType.morning);
    await routines.addToRoutine(morning.id, id);
    final s = await routines.watchSession(RoutineType.morning, now).first;
    for (final t in s.tasks.take(4)) {
      await routines.completeTask(morning.id, t.task.id, now);
    }
    final reward = await rewards.createReward(
      RewardsCompanion.insert(name: 'גלידה', starCost: 3),
    );
    await rewards.redeem(reward, now);
    return (db, media);
  }

  test(
    'export then restore into a fresh install gives the same data',
    () async {
      final (src, srcMedia) = await populated();
      addTearDown(src.close);
      final bytes = await BackupService(src, srcMedia).export(now);

      final dst = makeTestDb();
      addTearDown(dst.close);
      final dstMedia = makeTestMedia();
      await BackupService(dst, dstMedia).restore(bytes);

      Future<List<Map<String, dynamic>>> dump(
        AppDatabase db,
        String table,
      ) async {
        final rows = switch (table) {
          'children' => await db.select(db.children).get(),
          'routines' => await db.select(db.routines).get(),
          'tasks' => await db.select(db.tasks).get(),
          'routineTasks' => await db.select(db.routineTasks).get(),
          'runLogs' => await db.select(db.runLogs).get(),
          'rewards' => await db.select(db.rewards).get(),
          _ => await db.select(db.starLedger).get(),
        };
        return [
          for (final r in rows) (r as dynamic).toJson() as Map<String, dynamic>,
        ];
      }

      for (final table in [
        'children', 'routines', 'tasks', 'routineTasks', 'runLogs', //
        'rewards', 'starLedger',
      ]) {
        expect(await dump(dst, table), await dump(src, table), reason: table);
      }
      expect(await RoutineRepository(dst).watchStarBalance().first, 1);

      final task = await (dst.select(
        dst.tasks,
      )..where((t) => t.nameHe.equals('האכלת הכלב'))).getSingle();
      expect(dstMedia.existing(task.photoPath)!.readAsBytesSync(), [1, 2, 3]);
      expect(dstMedia.existing(task.audioPath)!.readAsBytesSync(), [
        4,
        5,
        6,
        7,
      ]);
    },
  );

  test('restore replaces what was there', () async {
    final (src, srcMedia) = await populated();
    addTearDown(src.close);
    final bytes = await BackupService(src, srcMedia).export(now);

    final dst = makeTestDb();
    addTearDown(dst.close);
    final dstMedia = makeTestMedia();
    final stray = dstMedia.newPath('photos', 'jpg');
    dstMedia.resolve(stray).writeAsBytesSync([9]);
    await RewardRepository(
      dst,
      dstMedia,
    ).createReward(RewardsCompanion.insert(name: 'old', starCost: 1));

    await BackupService(dst, dstMedia).restore(bytes);
    final names = [for (final r in await dst.select(dst.rewards).get()) r.name];
    expect(names, ['גלידה']);
    expect(dstMedia.existing(stray), isNull);
  });

  test('a bad file is rejected and changes nothing', () async {
    final db = makeTestDb();
    addTearDown(db.close);
    final media = makeTestMedia();
    final service = BackupService(db, media);
    final before = await db.select(db.tasks).get();

    await expectLater(
      service.restore(Uint8List.fromList(utf8.encode('hello'))),
      throwsA(isA<BackupFormatException>()),
    );

    final wrong = Archive();
    final json = utf8.encode(jsonEncode({'format': 'something_else'}));
    wrong.addFile(ArchiveFile('backup.json', json.length, json));
    await expectLater(
      service.restore(Uint8List.fromList(ZipEncoder().encode(wrong))),
      throwsA(isA<BackupFormatException>()),
    );

    final broken = Archive();
    final bad = utf8.encode(
      jsonEncode({
        'format': BackupService.format,
        'version': BackupService.formatVersion,
        'schemaVersion': 2,
        'tables': {
          'children': [
            {'id': 'x'},
          ],
        },
      }),
    );
    broken.addFile(ArchiveFile('backup.json', bad.length, bad));
    await expectLater(
      service.restore(Uint8List.fromList(ZipEncoder().encode(broken))),
      throwsA(isA<BackupFormatException>()),
    );

    expect(await db.select(db.tasks).get(), before);
  });

  test('media paths in the backup cannot escape the media folder', () async {
    final (src, srcMedia) = await populated();
    addTearDown(src.close);
    final good = ZipDecoder().decodeBytes(
      await BackupService(src, srcMedia).export(now),
    );
    good.addFile(ArchiveFile('media/../../evil.txt', 1, [1]));
    final dst = makeTestDb();
    addTearDown(dst.close);
    final dstMedia = makeTestMedia();
    await BackupService(
      dst,
      dstMedia,
    ).restore(Uint8List.fromList(ZipEncoder().encode(good)));
    expect(
      dstMedia.root.parent.listSync().map((e) => e.path),
      isNot(contains(endsWith('evil.txt'))),
    );
  });
}
