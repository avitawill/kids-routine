import 'enums.dart';

/// One task's log for the parent's daily summary.
class TaskLogEntry {
  const TaskLogEntry({
    required this.routine,
    required this.taskId,
    required this.position,
    required this.targetMinutes,
    required this.startedAt,
    this.completedAt,
  });

  final RoutineType routine;
  final int taskId;

  /// Position in the routine, for ordering. Tasks no longer in the routine
  /// sort last.
  final int position;
  final int targetMinutes;
  final DateTime startedAt;
  final DateTime? completedAt;

  bool get isDone => completedAt != null;

  /// From when the task appeared on screen until Done.
  Duration? get taken => completedAt?.difference(startedAt);

  Duration get target => Duration(minutes: targetMinutes);
}

class RoutineSummary {
  RoutineSummary(
    this.routine,
    List<TaskLogEntry> tasks, {
    required this.taskCount,
  }) : tasks = List.unmodifiable(
         [...tasks]..sort((a, b) {
           final p = a.position.compareTo(b.position);
           return p != 0 ? p : a.startedAt.compareTo(b.startedAt);
         }),
       );

  final RoutineType routine;
  final List<TaskLogEntry> tasks;

  /// Tasks in the routine today (some may never have been reached).
  final int taskCount;

  int get doneCount => tasks.where((t) => t.isDone).length;
  bool get isComplete => taskCount > 0 && doneCount >= taskCount;

  DateTime get startedAt =>
      tasks.map((t) => t.startedAt).reduce((a, b) => a.isBefore(b) ? a : b);

  /// When the last task was done; null until the routine is complete.
  DateTime? get finishedAt {
    if (!isComplete) return null;
    return tasks
        .map((t) => t.completedAt!)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }

  Duration? get total => finishedAt?.difference(startedAt);
}

/// Groups a day's logs by routine, in morning → noon → evening order.
/// Routines with no logs that day are left out.
List<RoutineSummary> summarizeDay(
  Iterable<TaskLogEntry> logs,
  Map<RoutineType, int> taskCounts,
) => [
  for (final type in RoutineType.values)
    if (logs.any((l) => l.routine == type))
      RoutineSummary(
        type,
        logs.where((l) => l.routine == type).toList(),
        taskCount: taskCounts[type] ?? 0,
      ),
];
