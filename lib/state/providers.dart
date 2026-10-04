import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database.dart';
import '../data/routine_repository.dart';
import '../services/audio_service.dart';

/// Overridden in tests with an in-memory database.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Overridden in tests with a controllable clock.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Overridden in tests with a silent fake.
final audioProvider = Provider<AudioCues>((ref) {
  final audio = AudioService();
  ref.onDispose(audio.dispose);
  return audio;
});

final repositoryProvider = Provider<RoutineRepository>(
  (ref) => RoutineRepository(ref.watch(databaseProvider)),
);

final childProvider = StreamProvider<Child>(
  (ref) => ref.watch(repositoryProvider).watchChild(),
);

final localeProvider = Provider<Locale>((ref) {
  final lang = ref.watch(childProvider).value?.language ?? AppLanguage.he;
  return Locale(lang.name);
});

final starBalanceProvider = StreamProvider<int>(
  (ref) => ref.watch(repositoryProvider).watchStarBalance(),
);

/// Today's run of one routine.
final sessionProvider = StreamProvider.family<RoutineSession, RoutineType>(
  (ref, type) => ref
      .watch(repositoryProvider)
      .watchSession(type, ref.watch(clockProvider)()),
);
