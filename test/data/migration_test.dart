import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/data/db/database.dart';

void main() {
  test(
    'a v1 database (M1/M2 installs) upgrades to v3 keeping its data',
    () async {
      final db = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(
            setup: (raw) {
              // The v1 tables the upgrade touches, as M1 created them.
              raw.execute('''
              CREATE TABLE children (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL DEFAULT '',
                gender TEXT NOT NULL,
                language TEXT NOT NULL,
                mascot_name TEXT NOT NULL)''');
              raw.execute('''
              CREATE TABLE tasks (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                built_in_key TEXT NULL UNIQUE,
                name_he TEXT NOT NULL,
                name_es TEXT NULL,
                name_en TEXT NULL,
                emoji TEXT NULL,
                photo_path TEXT NULL,
                audio_path TEXT NULL,
                target_minutes INTEGER NOT NULL,
                pack TEXT NOT NULL,
                is_built_in INTEGER NOT NULL DEFAULT 0)''');
              // As M1 created it: started_at NOT NULL (nullable from v3).
              raw.execute('''
              CREATE TABLE run_logs (
                id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                date TEXT NOT NULL,
                routine_id INTEGER NOT NULL,
                task_id INTEGER NOT NULL,
                started_at INTEGER NOT NULL,
                completed_at INTEGER NULL,
                UNIQUE (date, routine_id, task_id))''');
              raw.execute(
                'INSERT INTO run_logs (date, routine_id, task_id, started_at, completed_at) '
                "VALUES ('2026-10-04', 1, 1, 1791100000, 1791100120)",
              );
              raw.execute(
                "INSERT INTO children (name, gender, language, mascot_name) "
                "VALUES ('נועה', 'female', 'he', 'פומי')",
              );
              raw.execute(
                "INSERT INTO tasks (built_in_key, name_he, target_minutes, pack, is_built_in) "
                "VALUES ('brush_teeth', 'צחצוח שיניים', 4, 'core', 1)",
              );
              // A parent already translated this one by hand: keep it.
              raw.execute(
                "INSERT INTO tasks (built_in_key, name_he, name_es, name_en, target_minutes, pack, is_built_in) "
                "VALUES ('shoes', 'נעליים', 'Zapatos', 'Shoes!', 3, 'core', 1)",
              );
              raw.execute('PRAGMA user_version = 1');
            },
          ),
          closeStreamsSynchronously: true,
        ),
      );
      addTearDown(db.close);

      final child = await db.select(db.children).getSingle();
      expect(child.name, 'נועה');
      expect(child.jewishPack, isFalse);

      final tasks = {
        for (final t in await db.select(db.tasks).get()) t.builtInKey: t,
      };
      expect(tasks['brush_teeth']!.nameEs, 'Cepillarse los dientes');
      expect(tasks['brush_teeth']!.nameEn, 'Brush teeth');
      expect(tasks['brush_teeth']!.targetMinutes, 4); // parent's edit kept
      expect(tasks['shoes']!.nameEn, 'Shoes!');

      // v3: history kept, and a paused task can now have no start time.
      final log = await db.select(db.runLogs).getSingle();
      expect(log.completedAt, isNotNull);
      await db
          .update(db.runLogs)
          .write(const RunLogsCompanion(startedAt: Value(null)));
      expect((await db.select(db.runLogs).getSingle()).startedAt, isNull);
    },
  );
}
