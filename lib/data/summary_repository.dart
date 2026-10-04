import 'package:drift/drift.dart';

import '../domain/daily_summary.dart';
import '../domain/date_key.dart';
import 'db/database.dart';

class DaySummary {
  const DaySummary({
    required this.routines,
    required this.tasks,
    required this.starsEarned,
  });

  final List<RoutineSummary> routines;

  /// Task rows by id, for names and pictures.
  final Map<int, Task> tasks;
  final int starsEarned;
}

class SummaryRepository {
  SummaryRepository(this.db);

  final AppDatabase db;

  Stream<DaySummary> watchDay(DateTime day) {
    final date = dateKey(day);
    final query = db.select(db.runLogs).join([
      innerJoin(db.tasks, db.tasks.id.equalsExp(db.runLogs.taskId)),
      innerJoin(db.routines, db.routines.id.equalsExp(db.runLogs.routineId)),
      leftOuterJoin(
        db.routineTasks,
        db.routineTasks.routineId.equalsExp(db.runLogs.routineId) &
            db.routineTasks.taskId.equalsExp(db.runLogs.taskId),
      ),
    ])..where(db.runLogs.date.equals(date));

    return query.watch().asyncMap((rows) async {
      final tasks = <int, Task>{};
      final entries = <int, TaskLogEntry>{}; // by RunLog id
      for (final row in rows) {
        final log = row.readTable(db.runLogs);
        final task = row.readTable(db.tasks);
        tasks[task.id] = task;
        final position =
            row.readTableOrNull(db.routineTasks)?.position ?? 1 << 30;
        final prev = entries[log.id];
        if (prev != null && prev.position <= position) continue;
        entries[log.id] = TaskLogEntry(
          routine: row.readTable(db.routines).type,
          taskId: task.id,
          position: position,
          targetMinutes: task.targetMinutes,
          startedAt: log.startedAt,
          completedAt: log.completedAt,
        );
      }

      final count = db.routineTasks.id.count();
      final counts = {
        for (final r
            in await (db.selectOnly(db.routineTasks).join([
                    innerJoin(
                      db.routines,
                      db.routines.id.equalsExp(db.routineTasks.routineId),
                    ),
                  ])
                  ..addColumns([db.routines.type, count])
                  ..groupBy([db.routines.type]))
                .get())
          RoutineType.values.byName(r.read(db.routines.type)!):
              r.read(count) ?? 0,
      };

      final earned = db.starLedger.delta.sum();
      final stars =
          await (db.selectOnly(db.starLedger)
                ..addColumns([earned])
                ..where(
                  db.starLedger.date.equals(date) &
                      db.starLedger.delta.isBiggerThanValue(0),
                ))
              .map((r) => r.read(earned) ?? 0)
              .getSingle();

      return DaySummary(
        routines: summarizeDay(entries.values, counts),
        tasks: tasks,
        starsEarned: stars,
      );
    });
  }
}
