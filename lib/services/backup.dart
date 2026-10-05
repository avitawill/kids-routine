import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';

import '../data/db/database.dart';
import 'media_store.dart';

/// Thrown when a file is not a backup this app can restore.
class BackupFormatException implements Exception {
  const BackupFormatException(this.message);

  final String message;

  @override
  String toString() => 'BackupFormatException: $message';
}

/// Backup = one .zip: `backup.json` (every table) + `media/…` (photos and
/// recordings, at the same relative paths the database stores).
class BackupService {
  BackupService(this.db, this.media);

  final AppDatabase db;
  final MediaStore media;

  static const format = 'kids_routine_backup';
  static const formatVersion = 1;

  Future<Uint8List> export(DateTime now) async {
    final tables = {
      'children': await db.select(db.children).get(),
      'routines': await db.select(db.routines).get(),
      'tasks': await db.select(db.tasks).get(),
      'routineTasks': await db.select(db.routineTasks).get(),
      'runLogs': await db.select(db.runLogs).get(),
      'rewards': await db.select(db.rewards).get(),
      'starLedger': await db.select(db.starLedger).get(),
    };
    final json = {
      'format': format,
      'version': formatVersion,
      'schemaVersion': db.schemaVersion,
      'exportedAt': now.toIso8601String(),
      'tables': {
        for (final e in tables.entries)
          e.key: [for (final row in e.value) (row as dynamic).toJson()],
      },
    };

    final archive = Archive();
    final jsonBytes = utf8.encode(jsonEncode(json));
    archive.addFile(ArchiveFile('backup.json', jsonBytes.length, jsonBytes));
    final mediaDir = Directory('${media.root.path}/media');
    if (mediaDir.existsSync()) {
      for (final f in mediaDir.listSync(recursive: true).whereType<File>()) {
        final rel = f.path
            .substring(media.root.path.length + 1)
            .replaceAll('\\', '/');
        final bytes = f.readAsBytesSync();
        archive.addFile(ArchiveFile(rel, bytes.length, bytes));
      }
    }
    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  /// Replaces all app data with the backup's. Validates everything before
  /// touching anything; on a bad file nothing changes.
  Future<void> restore(Uint8List bytes) async {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      throw const BackupFormatException('not a zip file');
    }
    final jsonFile = archive.findFile('backup.json');
    if (jsonFile == null) {
      throw const BackupFormatException('backup.json missing');
    }
    final Map<String, dynamic> json;
    try {
      json = jsonDecode(utf8.decode(jsonFile.content)) as Map<String, dynamic>;
    } catch (_) {
      throw const BackupFormatException('backup.json is not valid JSON');
    }
    if (json['format'] != format || json['version'] != formatVersion) {
      throw const BackupFormatException('unknown backup format');
    }
    if ((json['schemaVersion'] as int? ?? 0) > db.schemaVersion) {
      throw const BackupFormatException('made by a newer app version');
    }

    final t = json['tables'] as Map<String, dynamic>;
    List<Map<String, dynamic>> rows(String name) => [
      for (final r in (t[name] as List? ?? const [])) r as Map<String, dynamic>,
    ];

    // Parse first, so a broken file fails before anything is deleted.
    final List<Child> children;
    final List<Routine> routines;
    final List<Task> tasks;
    final List<RoutineTask> routineTasks;
    final List<RunLog> runLogs;
    final List<Reward> rewards;
    final List<StarEntry> ledger;
    try {
      children = rows('children').map(Child.fromJson).toList();
      routines = rows('routines').map(Routine.fromJson).toList();
      tasks = rows('tasks').map(Task.fromJson).toList();
      routineTasks = rows('routineTasks').map(RoutineTask.fromJson).toList();
      runLogs = rows('runLogs').map(RunLog.fromJson).toList();
      rewards = rows('rewards').map(Reward.fromJson).toList();
      ledger = rows('starLedger').map(StarEntry.fromJson).toList();
    } catch (e) {
      throw BackupFormatException('bad data: $e');
    }
    if (children.isEmpty || routines.isEmpty) {
      throw const BackupFormatException('no child or routines');
    }

    await db.transaction(() async {
      // Children first in the delete order, parents last.
      await db.delete(db.starLedger).go();
      await db.delete(db.runLogs).go();
      await db.delete(db.routineTasks).go();
      await db.delete(db.rewards).go();
      await db.delete(db.tasks).go();
      await db.delete(db.routines).go();
      await db.delete(db.children).go();
      await db.batch((b) {
        b.insertAll(db.children, children);
        b.insertAll(db.routines, routines);
        b.insertAll(db.tasks, tasks);
        b.insertAll(db.routineTasks, routineTasks);
        b.insertAll(db.runLogs, runLogs);
        b.insertAll(db.rewards, rewards);
        b.insertAll(db.starLedger, ledger);
      });
    });

    // Media: replace the whole folder with the backup's files.
    final mediaDir = Directory('${media.root.path}/media');
    if (mediaDir.existsSync()) mediaDir.deleteSync(recursive: true);
    for (final f in archive.files) {
      if (!f.isFile || !f.name.startsWith('media/')) continue;
      // Never write outside the media folder.
      if (f.name.contains('..')) continue;
      final out = media.resolve(f.name);
      out.parent.createSync(recursive: true);
      out.writeAsBytesSync(f.content);
    }
  }
}

/// Where backups are written and read: the system file dialogs. Abstract so
/// tests can fake it.
abstract class BackupFiles {
  /// Lets the parent choose where to save. False if they cancelled.
  Future<bool> save(String fileName, Uint8List bytes);

  /// Lets the parent pick a backup file. Null if they cancelled.
  Future<Uint8List?> open();
}

class SystemBackupFiles implements BackupFiles {
  @override
  Future<bool> save(String fileName, Uint8List bytes) async =>
      await FilePicker.saveFile(
        fileName: fileName,
        bytes: bytes,
        mimeType: 'application/zip',
      ) !=
      null;

  @override
  Future<Uint8List?> open() async {
    final files = await FilePicker.pickFiles();
    if (files.isEmpty) return null;
    return files.first.xFile.readAsBytes();
  }
}
