/// Visual timer state for one task. Wall-clock based, so it stays correct
/// after the app is paused or killed and reopened.
///
/// There is no failure state: when time runs out the pie is simply empty and
/// the task stays open until Done.
class TaskTimer {
  const TaskTimer({required this.startedAt, required this.target});

  final DateTime startedAt;
  final Duration target;

  Duration elapsed(DateTime now) {
    final e = now.difference(startedAt);
    return e.isNegative ? Duration.zero : e;
  }

  /// 1.0 = full pie, 0.0 = empty. Shrinks linearly.
  double fractionRemaining(DateTime now) {
    if (target <= Duration.zero) return 0;
    final f = 1 - elapsed(now).inMilliseconds / target.inMilliseconds;
    return f.clamp(0.0, 1.0);
  }

  bool isTimeUp(DateTime now) => elapsed(now) >= target;
}
