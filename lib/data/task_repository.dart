import 'package:drift/drift.dart';

import '../services/media_store.dart';
import 'db/database.dart';

class TaskRepository {
  TaskRepository(this.db, this.media);

  final AppDatabase db;
  final MediaStore media;

  /// All tasks: built-in first (seed order), then custom ones.
  Stream<List<Task>> watchLibrary() => _library().watch();

  Future<List<Task>> getLibrary() => _library().get();

  SimpleSelectStatement<$TasksTable, Task> _library() => db.select(db.tasks)
    ..orderBy([
      (t) => OrderingTerm.desc(t.isBuiltIn),
      (t) => OrderingTerm.asc(t.id),
    ]);

  Future<Task?> getTask(int id) =>
      (db.select(db.tasks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> createTask(TasksCompanion task) => db
      .into(db.tasks)
      .insert(
        task.copyWith(
          pack: const Value(TaskPack.custom),
          isBuiltIn: const Value(false),
        ),
      );

  Future<void> updateTask(int id, TasksCompanion changes) =>
      (db.update(db.tasks)..where((t) => t.id.equals(id))).write(changes);

  /// Deletes a custom task, its routine links, its run history and its media.
  /// Built-in tasks can only be removed from routines, never deleted.
  Future<bool> deleteCustomTask(int id) async {
    final task = await getTask(id);
    if (task == null || task.isBuiltIn) return false;
    await (db.delete(db.tasks)..where((t) => t.id.equals(id))).go();
    await media.delete(task.photoPath);
    await media.delete(task.audioPath);
    return true;
  }
}
