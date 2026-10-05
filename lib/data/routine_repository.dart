import 'package:drift/drift.dart';

import '../domain/date_key.dart';
import '../domain/pack_placement.dart';
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

  // ---- Parent mode: editing ----

  Future<void> updateChild({
    required String name,
    required Gender gender,
    required String mascotName,
  }) async {
    final child = await (db.select(db.children)..limit(1)).getSingle();
    await (db.update(db.children)..where((c) => c.id.equals(child.id))).write(
      ChildrenCompanion(
        name: Value(name.trim()),
        gender: Value(gender),
        mascotName: Value(mascotName.trim()),
      ),
    );
  }

  Future<Routine> getRoutine(RoutineType type) => (db.select(
    db.routines,
  )..where((r) => r.type.equalsValue(type))).getSingle();

  Stream<List<Routine>> watchRoutines() => db.select(db.routines).watch();

  Stream<Routine> watchRoutine(RoutineType type) => (db.select(
    db.routines,
  )..where((r) => r.type.equalsValue(type))).watchSingle();

  Future<void> updateRoutine(
    int routineId, {
    int? startMinutes,
    int? daysOfWeek,
    bool? reminderEnabled,
  }) => (db.update(db.routines)..where((r) => r.id.equals(routineId))).write(
    RoutinesCompanion(
      startMinutes: Value.absentIfNull(startMinutes),
      daysOfWeek: Value.absentIfNull(daysOfWeek),
      reminderEnabled: Value.absentIfNull(reminderEnabled),
    ),
  );

  /// The routine's tasks in order, with the link rows (needed to reorder and
  /// remove).
  Stream<List<(RoutineTask, Task)>> watchRoutineItems(int routineId) {
    final query =
        db.select(db.routineTasks).join([
            innerJoin(db.tasks, db.tasks.id.equalsExp(db.routineTasks.taskId)),
          ])
          ..where(db.routineTasks.routineId.equals(routineId))
          ..orderBy([OrderingTerm.asc(db.routineTasks.position)]);
    return query.watch().map(
      (rows) => [
        for (final r in rows)
          (r.readTable(db.routineTasks), r.readTable(db.tasks)),
      ],
    );
  }

  /// Rewrites positions 0..n-1 in the given order of RoutineTask ids.
  Future<void> reorder(int routineId, List<int> routineTaskIds) =>
      db.transaction(() async {
        for (final (i, id) in routineTaskIds.indexed) {
          await (db.update(db.routineTasks)..where(
                (rt) => rt.id.equals(id) & rt.routineId.equals(routineId),
              ))
              .write(RoutineTasksCompanion(position: Value(i)));
        }
      });

  /// Appends [taskId] to the end of the routine.
  Future<void> addToRoutine(int routineId, int taskId) =>
      db.transaction(() async {
        final max = db.routineTasks.position.max();
        final last =
            await (db.selectOnly(db.routineTasks)
                  ..addColumns([max])
                  ..where(db.routineTasks.routineId.equals(routineId)))
                .map((r) => r.read(max))
                .getSingle();
        await db
            .into(db.routineTasks)
            .insert(
              RoutineTasksCompanion.insert(
                routineId: routineId,
                taskId: taskId,
                position: (last ?? -1) + 1,
              ),
            );
      });

  /// Removes one task from a routine (the task itself stays in the library).
  Future<void> removeFromRoutine(int routineTaskId) => db.transaction(() async {
    final rt = await (db.select(
      db.routineTasks,
    )..where((r) => r.id.equals(routineTaskId))).getSingleOrNull();
    if (rt == null) return;
    await (db.delete(
      db.routineTasks,
    )..where((r) => r.id.equals(routineTaskId))).go();
    final rest =
        await (db.select(db.routineTasks)
              ..where((r) => r.routineId.equals(rt.routineId))
              ..orderBy([(r) => OrderingTerm.asc(r.position)]))
            .get();
    await reorder(rt.routineId, [for (final r in rest) r.id]);
  });

  Future<void> setLanguage(AppLanguage language) async {
    final child = await watchChild().first;
    await (db.update(db.children)..where((c) => c.id.equals(child.id))).write(
      ChildrenCompanion(language: Value(language)),
    );
  }

  /// Turns the Jewish pack on (placing its tasks, see [jewishPackPlacements])
  /// or off (removing them from every routine). Stars and history stay.
  Future<void> setJewishPack(bool on) => db.transaction(() async {
    final child = await watchChild().first;
    await (db.update(db.children)..where((c) => c.id.equals(child.id))).write(
      ChildrenCompanion(jewishPack: Value(on)),
    );
    final packTasks = await (db.select(
      db.tasks,
    )..where((t) => t.pack.equalsValue(TaskPack.jewish))).get();
    final idByKey = {for (final t in packTasks) t.builtInKey: t.id};

    if (!on) {
      final ids = idByKey.values.toList();
      final affected = await (db.select(
        db.routineTasks,
      )..where((rt) => rt.taskId.isIn(ids))).get();
      await (db.delete(
        db.routineTasks,
      )..where((rt) => rt.taskId.isIn(ids))).go();
      for (final routineId in {for (final rt in affected) rt.routineId}) {
        await _compact(routineId);
      }
      return;
    }

    for (final p in jewishPackPlacements) {
      final taskId = idByKey[p.key];
      if (taskId == null) continue;
      final routine = await getRoutine(p.routine);
      final items = await _items(routine.id);
      if (items.any((i) => i.$2.id == taskId)) continue;
      final keys = [for (final i in items) i.$2.builtInKey];
      final order = [for (final i in items) i.$1.id];
      // Insert at the end, then move into place.
      await addToRoutine(routine.id, taskId);
      final added = (await _items(routine.id)).last.$1.id;
      order.insert(p.indexIn(keys), added);
      await reorder(routine.id, order);
    }
  });

  Future<List<(RoutineTask, Task)>> _items(int routineId) async {
    final rows =
        await (db.select(db.routineTasks).join([
                innerJoin(
                  db.tasks,
                  db.tasks.id.equalsExp(db.routineTasks.taskId),
                ),
              ])
              ..where(db.routineTasks.routineId.equals(routineId))
              ..orderBy([OrderingTerm.asc(db.routineTasks.position)]))
            .get();
    return [
      for (final r in rows)
        (r.readTable(db.routineTasks), r.readTable(db.tasks)),
    ];
  }

  Future<void> _compact(int routineId) async => reorder(routineId, [
    for (final (rt, _) in await _items(routineId)) rt.id,
  ]);
}
