import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/data/reward_repository.dart';
import 'package:kids_routine/data/routine_repository.dart';
import 'package:kids_routine/services/media_store.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late RoutineRepository routines;
  late RewardRepository rewards;
  late MediaStore media;
  final now = DateTime(2026, 10, 5, 8, 0);

  Future<void> earn(int stars) async {
    final s = await routines.watchSession(RoutineType.morning, now).first;
    for (final t in s.tasks.where((t) => !t.isDone).take(stars)) {
      await routines.completeTask(s.routine.id, t.task.id, now);
    }
  }

  setUp(() {
    db = makeTestDb();
    media = makeTestMedia();
    routines = RoutineRepository(db);
    rewards = RewardRepository(db, media);
  });
  tearDown(() => db.close());

  test('redeem spends exactly the cost as one negative entry', () async {
    await earn(5);
    final id = await rewards.createReward(
      RewardsCompanion.insert(name: 'גלידה', starCost: 3),
    );
    expect(await rewards.redeem(id, now), isTrue);
    expect(await routines.watchStarBalance().first, 2);

    final negatives = await (db.select(
      db.starLedger,
    )..where((e) => e.delta.isSmallerThanValue(0))).get();
    expect(negatives, hasLength(1));
    expect(negatives.single.delta, -3);
    expect(negatives.single.reason, StarReason.redemption);
    expect(negatives.single.refId, id);
    expect((await rewards.getReward(id))!.redeemedAt, now);
  });

  test('not enough stars: nothing changes, never below zero', () async {
    await earn(2);
    final id = await rewards.createReward(
      RewardsCompanion.insert(name: 'אופניים', starCost: 3),
    );
    expect(await rewards.redeem(id, now), isFalse);
    expect(await routines.watchStarBalance().first, 2);
    expect((await rewards.getReward(id))!.redeemedAt, isNull);
  });

  test('a reward is redeemed only once', () async {
    await earn(10);
    final id = await rewards.createReward(
      RewardsCompanion.insert(name: 'פארק', starCost: 2),
    );
    expect(await rewards.redeem(id, now), isTrue);
    expect(await rewards.redeem(id, now), isFalse);
    expect(await routines.watchStarBalance().first, 8);
  });

  test('offer again creates a fresh copy with its own photo file', () async {
    await earn(3);
    final photo = media.newPath('photos', 'jpg');
    media.resolve(photo).writeAsStringSync('img');
    final id = await rewards.createReward(
      RewardsCompanion.insert(
        name: 'סרט',
        starCost: 3,
        photoPath: Value(photo),
      ),
    );
    await rewards.redeem(id, now);

    final copyId = await rewards.offerAgain(id);
    final copy = (await rewards.getReward(copyId!))!;
    expect(copy.name, 'סרט');
    expect(copy.starCost, 3);
    expect(copy.redeemedAt, isNull);
    expect(copy.photoPath, isNot(photo));
    expect(media.existing(copy.photoPath), isNotNull);

    // Deleting the original doesn't take the copy's photo with it.
    await rewards.deleteReward(id);
    expect(media.existing(photo), isNull);
    expect(media.existing(copy.photoPath), isNotNull);
  });
}
