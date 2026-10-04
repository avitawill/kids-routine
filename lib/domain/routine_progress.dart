/// Where the child is in a routine, from the ordered list of "done today"
/// flags (one per task, in routine order).
///
/// Tasks are done in order, but if one is somehow completed out of order the
/// current task is always the first one not done yet.
class RoutineProgress {
  RoutineProgress(List<bool> completed)
    : completed = List.unmodifiable(completed);

  final List<bool> completed;

  int get total => completed.length;
  int get doneCount => completed.where((c) => c).length;
  bool get isComplete => total > 0 && doneCount == total;
  bool get isStarted => doneCount > 0;

  /// Index of the task to show now, or null when the routine is complete
  /// (or empty).
  int? get currentIndex {
    final i = completed.indexOf(false);
    return i < 0 ? null : i;
  }

  /// Index of the task to peek at after the current one, or null if the
  /// current task is the last one left.
  int? get nextIndex {
    final cur = currentIndex;
    if (cur == null) return null;
    final i = completed.indexOf(false, cur + 1);
    return i < 0 ? null : i;
  }
}
