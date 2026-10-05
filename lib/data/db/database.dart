import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/enums.dart';
import 'seed.dart';
import 'tables.dart';

export '../../domain/enums.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Children,
    Routines,
    Tasks,
    RoutineTasks,
    RunLogs,
    Rewards,
    StarLedger,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'kids_routine'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 3 && from >= 1) {
        // v3: RunLogs.startedAt became nullable (tasks can be paused or
        // unchecked). Rebuilds the table, keeping every row.
        await m.alterTable(TableMigration(runLogs));
      }
      if (from < 2) {
        // M3: Jewish pack switch, and Spanish/English names for built-ins.
        await m.addColumn(children, children.jewishPack);
        for (final t in seedTasks) {
          await (update(tasks)..where(
                (x) =>
                    x.builtInKey.equals(t.key) &
                    x.nameEs.isNull() &
                    x.nameEn.isNull(),
              ))
              .write(
                TasksCompanion(
                  nameEs: Value(t.nameEs),
                  nameEn: Value(t.nameEn),
                ),
              );
        }
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) await _seed();
    },
  );

  Future<void> _seed() => transaction(() async {
    await into(children).insert(
      ChildrenCompanion.insert(
        gender: Gender.female,
        language: AppLanguage.he,
        mascotName: defaultMascotName,
      ),
    );

    final taskIds = <String, int>{};
    for (final t in seedTasks) {
      taskIds[t.key] = await into(tasks).insert(
        TasksCompanion.insert(
          builtInKey: Value(t.key),
          nameHe: t.nameHe,
          nameEs: Value(t.nameEs),
          nameEn: Value(t.nameEn),
          emoji: Value(t.emoji),
          targetMinutes: t.minutes,
          pack: t.pack,
          isBuiltIn: const Value(true),
        ),
      );
    }

    for (final r in seedRoutines) {
      final routineId = await into(routines).insert(
        RoutinesCompanion.insert(type: r.type, startMinutes: r.startMinutes),
      );
      for (final (i, key) in r.taskKeys.indexed) {
        await into(routineTasks).insert(
          RoutineTasksCompanion.insert(
            routineId: routineId,
            taskId: taskIds[key]!,
            position: i,
          ),
        );
      }
    }
  });
}
