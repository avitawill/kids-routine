/// Where the child is in a routine, from the ordered list of "done today"
/// flags (one per task, in routine order).
///
/// By default the current task is the first one not done yet; the child may
/// pick any other not-done task instead (order doesn't matter).
class RoutineProgress {
  RoutineProgress(List<bool> completed, [this._preferred])
    : completed = List.unmodifiable(completed);

  final List<bool> completed;

  int get total => completed.length;
  int get doneCount => completed.where((c) => c).length;
  bool get isComplete => total > 0 && doneCount == total;
  bool get isStarted => doneCount > 0;

  final int? _preferred;

  /// The same progress with the child's chosen task as current.
  RoutineProgress withCurrent(int index) => RoutineProgress(completed, index);

  /// Index of the task to show now: the one the child chose, else the first
  /// not done yet. Null when the routine is complete (or empty).
  int? get currentIndex {
    final p = _preferred;
    if (p != null && p >= 0 && p < total && !completed[p]) return p;
    final i = completed.indexOf(false);
    return i < 0 ? null : i;
  }

  /// Index of the task to peek at next: the first not-done task other than
  /// the current one, in routine order (that's where the app goes after
  /// Done), or null if none is left.
  int? get nextIndex {
    final cur = currentIndex;
    if (cur == null) return null;
    for (var i = 0; i < total; i++) {
      if (i != cur && !completed[i]) return i;
    }
    return null;
  }
}
