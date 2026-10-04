import 'package:drift/drift.dart';

import '../domain/date_key.dart';
import '../domain/star_ledger.dart';
import '../services/media_store.dart';
import 'db/database.dart';

class RewardRepository {
  RewardRepository(this.db, this.media);

  final AppDatabase db;
  final MediaStore media;

  /// Not yet redeemed first (cheapest first), then redeemed (newest first).
  Stream<List<Reward>> watchRewards() =>
      (db.select(db.rewards)..orderBy([
            (r) => OrderingTerm.asc(r.redeemedAt.isNotNull()),
            (r) => OrderingTerm.desc(r.redeemedAt),
            (r) => OrderingTerm.asc(r.starCost),
            (r) => OrderingTerm.asc(r.id),
          ]))
          .watch();

  Future<Reward?> getReward(int id) =>
      (db.select(db.rewards)..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<int> createReward(RewardsCompanion reward) =>
      db.into(db.rewards).insert(reward);

  Future<void> updateReward(int id, RewardsCompanion changes) =>
      (db.update(db.rewards)..where((r) => r.id.equals(id))).write(changes);

  Future<void> deleteReward(int id) async {
    final r = await getReward(id);
    if (r == null) return;
    await (db.delete(db.rewards)..where((x) => x.id.equals(id))).go();
    await media.delete(r.photoPath);
  }

  /// Spends the reward's stars. Returns false (and changes nothing) if it was
  /// already redeemed or there are not enough stars.
  Future<bool> redeem(int id, DateTime now) => db.transaction(() async {
    final reward = await getReward(id);
    if (reward == null || reward.redeemedAt != null) return false;
    final sum = db.starLedger.delta.sum();
    final balance = await (db.selectOnly(
      db.starLedger,
    )..addColumns([sum])).map((r) => r.read(sum) ?? 0).getSingle();
    if (!canRedeem(balance: balance, cost: reward.starCost)) return false;

    await db
        .into(db.starLedger)
        .insert(
          StarLedgerCompanion.insert(
            date: dateKey(now),
            delta: -reward.starCost,
            reason: StarReason.redemption,
            refId: Value(reward.id),
          ),
        );
    await updateReward(id, RewardsCompanion(redeemedAt: Value(now)));
    return true;
  });

  /// Rewards are one-time; this offers a redeemed one again as a fresh copy
  /// (with its own copy of the photo).
  Future<int?> offerAgain(int id) async {
    final r = await getReward(id);
    if (r == null) return null;
    return createReward(
      RewardsCompanion.insert(
        name: r.name,
        starCost: r.starCost,
        photoPath: Value(await media.duplicate(r.photoPath)),
      ),
    );
  }
}
