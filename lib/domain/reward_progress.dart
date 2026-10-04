/// A reward the child is saving up for.
class RewardGoal {
  const RewardGoal({required this.id, required this.name, required this.cost});

  final int id;
  final String name;
  final int cost;
}

class RewardProgress {
  const RewardProgress(this.goal, this.balance);

  final RewardGoal goal;
  final int balance;

  double get fraction =>
      goal.cost <= 0 ? 1 : (balance / goal.cost).clamp(0.0, 1.0);
  bool get isReady => balance >= goal.cost;
  int get starsToGo => isReady ? 0 : goal.cost - balance;

  /// Progress toward the cheapest reward not redeemed yet (ties: lowest id),
  /// or null when there is nothing to save up for.
  static RewardProgress? next(int balance, Iterable<RewardGoal> unredeemed) {
    RewardGoal? best;
    for (final g in unredeemed) {
      if (best == null ||
          g.cost < best.cost ||
          (g.cost == best.cost && g.id < best.id)) {
        best = g;
      }
    }
    return best == null ? null : RewardProgress(best, balance);
  }
}
