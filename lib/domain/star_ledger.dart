import 'enums.dart';

/// Rules for the append-only star ledger (see CLAUDE.md, behavior rule 4).
abstract final class StarRules {
  /// Stars for finishing one task.
  static const perTask = 1;

  static int balance(Iterable<int> deltas) => deltas.fold(0, (a, b) => a + b);

  /// Stars are never taken away: only a redemption may be negative, and it
  /// must be.
  static bool isValidEntry(int delta, StarReason reason) => switch (reason) {
    StarReason.taskDone => delta > 0,
    StarReason.redemption => delta < 0,
  };
}
