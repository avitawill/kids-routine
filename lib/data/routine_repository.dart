import 'package:drift/drift.dart';

import '../domain/date_key.dart';
import '../domain/routine_progress.dart';
import '../domain/star_ledger.dart';
import 'db/database.dart';

/// One task in today's run of a routine.
class SessionTask {
  const SessionTask(this.task, this.runLog);

  final Task task;

  /// Today's log for this task, or null if it has not been shown yet.
  final RunLog? runLog;

  bool get isDone => runLog?.completedAt != null;
}

/// Today's state of one routine.
class RoutineSession {
  RoutineSession(this.routine, this.tasks)
    : progress = RoutineProgress([for (final t in tasks) t.isDone]);

  final Routine routine;
  final List<SessionTask> tasks;
  final RoutineProgress progress;

  SessionTask? get current =>
      progress.currentIndex == null ? null : tasks[progress.currentIndex!];
  SessionTask? get next =>
      progress.nextIndex == null ? null : tasks[progress.nextIndex!];
}

class RoutineRepository {
  RoutineRepository(this.db);

  final AppDatabase db;

  Stream<Child> watchChild() =>
      (db.select(db.children)..limit(1)).watchSingle();

  Stream<RoutineSession> watchSession(RoutineType type, DateTime day) {
    final date = dateKey(day);
    final query =
        db.select(db.routines).join([
            innerJoin(
              db.routineTasks,
              db.routineTasks.routineId.equalsExp(db.routines.id),
            ),
            innerJoin(db.tasks, db.tasks.id.equalsExp(db.routineTasks.taskId)),
            leftOuterJoin(
              db.runLogs,
              db.runLogs.routineId.equalsExp(db.routines.id) &
                  db.runLogs.taskId.equalsExp(db.tasks.id) &
                  db.runLogs.date.equals(date),
            ),
          ])
          ..where(db.routines.type.equalsValue(type))
          ..orderBy([OrderingTerm.asc(db.routineTasks.position)]);

    final routineQuery = db.select(db.routines)
      ..where((r) => r.type.equalsValue(type));

    return query.watch().asyncMap((rows) async {
      final routine = rows.isEmpty
          ? await routineQuery.getSingle()
          : rows.first.readTable(db.routines);
      return RoutineSession(routine, [
        for (final row in rows)
          SessionTask(row.readTable(db.tasks), row.readTableOrNull(db.runLogs)),
      ]);
    });
  }

  /// Starts the timer for a task the first time it appears today. Does
  /// nothing if it was already started, so the timer survives app restarts.
  Future<void> ensureStarted(int routineId, int taskId, DateTime now) => db
      .into(db.runLogs)
      .insert(
        RunLogsCompanion.insert(
          date: dateKey(now),
          routineId: routineId,
          taskId: taskId,
          startedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );

  /// Marks a task done and awards its star. Returns false (and awards
  /// nothing) if it was already done today.
  Future<bool> completeTask(int routineId, int taskId, DateTime now) =>
      db.transaction(() async {
        final date = dateKey(now);
        await ensureStarted(routineId, taskId, now);
        final log =
            await (db.select(db.runLogs)..where(
                  (l) =>
                      l.date.equals(date) &
                      l.routineId.equals(routineId) &
                      l.taskId.equals(taskId),
                ))
                .getSingle();
        if (log.completedAt != null) return false;

        await (db.update(db.runLogs)..where((l) => l.id.equals(log.id))).write(
          RunLogsCompanion(completedAt: Value(now)),
        );
        await db
            .into(db.starLedger)
            .insert(
              StarLedgerCompanion.insert(
                date: date,
                delta: StarRules.perTask,
                reason: StarReason.taskDone,
                refId: Value(log.id),
              ),
            );
        return true;
      });

  Stream<int> watchStarBalance() {
    final sum = db.starLedger.delta.sum();
    return (db.selectOnly(
      db.starLedger,
    )..addColumns([sum])).map((row) => row.read(sum) ?? 0).watchSingle();
  }
}
