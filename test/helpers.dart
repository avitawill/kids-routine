import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:kids_routine/data/db/database.dart';
import 'package:kids_routine/services/audio_service.dart';
import 'package:kids_routine/services/media_store.dart';
import 'package:kids_routine/services/recorder.dart';

AppDatabase makeTestDb() => AppDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);

/// A clock tests can move forward.
class FakeClock {
  FakeClock(this.now);

  DateTime now;

  DateTime call() => now;

  void advance(Duration d) => now = now.add(d);
}

/// Records what would have been played instead of making sound.
class FakeAudio implements AudioCues {
  final events = <String>[];

  @override
  Future<void> announceTask(Task task, AppLanguage lang) async =>
      events.add('announce:${task.builtInKey}');

  @override
  Future<void> playStar() async => events.add('star');

  @override
  Future<void> playTimeUp() async => events.add('timeUp');

  @override
  Future<void> playCelebration() async => events.add('celebration');

  @override
  Future<void> playFile(String relativePath) async =>
      events.add('play:$relativePath');

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

/// A media store in a fresh temp folder.
MediaStore makeTestMedia() => MediaStore(Directory.systemTemp.createTempSync('kids_routine_test'));

/// Writes a small file instead of using the microphone.
class FakeRecorder implements VoiceRecorder {
  bool allowed = true;
  String? recordingTo;

  @override
  Future<bool> start(String absolutePath) async {
    if (!allowed) return false;
    recordingTo = absolutePath;
    return true;
  }

  @override
  Future<void> stop() async {
    final path = recordingTo;
    if (path != null) File(path).writeAsStringSync('fake audio');
    recordingTo = null;
  }

  @override
  Future<void> dispose() async {}
}
