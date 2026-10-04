import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/domain/reward_progress.dart';
import 'package:kids_routine/domain/star_ledger.dart';

void main() {
  const bike = RewardGoal(id: 1, name: 'אופניים', cost: 50);
  const icecream = RewardGoal(id: 2, name: 'גלידה', cost: 10);
  const park = RewardGoal(id: 3, name: 'פארק', cost: 10);

  test('targets the cheapest unredeemed reward, lowest id on ties', () {
    final p = RewardProgress.next(4, [bike, park, icecream])!;
    expect(p.goal, icecream);
    expect(p.starsToGo, 6);
    expect(p.fraction, closeTo(0.4, 1e-9));
    expect(p.isReady, isFalse);
  });

  test('ready when the balance covers it; fraction caps at 1', () {
    final p = RewardProgress.next(25, [bike, icecream])!;
    expect(p.isReady, isTrue);
    expect(p.starsToGo, 0);
    expect(p.fraction, 1.0);
  });

  test('no rewards means nothing to show', () {
    expect(RewardProgress.next(10, []), isNull);
  });

  test('canRedeem never allows going below zero', () {
    expect(canRedeem(balance: 10, cost: 10), isTrue);
    expect(canRedeem(balance: 9, cost: 10), isFalse);
    expect(canRedeem(balance: 10, cost: 0), isFalse);
  });
}
