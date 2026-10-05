import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database.dart';
import '../data/reward_repository.dart';
import '../data/routine_repository.dart';
import '../data/summary_repository.dart';
import '../data/task_repository.dart';
import '../domain/reward_progress.dart';
import '../services/audio_service.dart';
import '../services/media_store.dart';
import '../services/recorder.dart';
import '../services/reminders.dart';

/// Overridden in tests with an in-memory database.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Opened in main() before the app starts (needs an async lookup).
final mediaStoreProvider = Provider<MediaStore>(
  (ref) => throw UnimplementedError('Override mediaStoreProvider in main()'),
);

/// Overridden in tests with a controllable clock.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Overridden in tests with a silent fake.
final audioProvider = Provider<AudioCues>((ref) {
  final audio = AudioService(ref.watch(mediaStoreProvider));
  ref.onDispose(audio.dispose);
  return audio;
});

/// Overridden in tests with fakes.
final recorderProvider = Provider<VoiceRecorder>((ref) {
  final r = MicVoiceRecorder();
  ref.onDispose(r.dispose);
  return r;
});

/// Overridden in tests with a fake.
final remindersProvider = Provider<Reminders>((ref) => LocalReminders());

final photoPickerProvider = Provider<PhotoPicker>((ref) => pickPhoto);

final repositoryProvider = Provider<RoutineRepository>(
  (ref) => RoutineRepository(ref.watch(databaseProvider)),
);
final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepository(
    ref.watch(databaseProvider),
    ref.watch(mediaStoreProvider),
  ),
);
final rewardRepositoryProvider = Provider<RewardRepository>(
  (ref) => RewardRepository(
    ref.watch(databaseProvider),
    ref.watch(mediaStoreProvider),
  ),
);
final summaryRepositoryProvider = Provider<SummaryRepository>(
  (ref) => SummaryRepository(ref.watch(databaseProvider)),
);

final childProvider = StreamProvider<Child>(
  (ref) => ref.watch(repositoryProvider).watchChild(),
);

final localeProvider = Provider<Locale>((ref) {
  final lang = ref.watch(childProvider).value?.language ?? AppLanguage.he;
  return Locale(lang.name);
});

final routinesProvider = StreamProvider<List<Routine>>(
  (ref) => ref.watch(repositoryProvider).watchRoutines(),
);

final starBalanceProvider = StreamProvider<int>(
  (ref) => ref.watch(repositoryProvider).watchStarBalance(),
);

/// Today's run of one routine.
final sessionProvider = StreamProvider.family<RoutineSession, RoutineType>(
  (ref, type) => ref
      .watch(repositoryProvider)
      .watchSession(type, ref.watch(clockProvider)()),
);

final rewardsProvider = StreamProvider<List<Reward>>(
  (ref) => ref.watch(rewardRepositoryProvider).watchRewards(),
);

/// Progress toward the cheapest reward not redeemed yet (null if none).
final nextRewardProvider = Provider<RewardProgress?>((ref) {
  final balance = ref.watch(starBalanceProvider).value ?? 0;
  final rewards = ref.watch(rewardsProvider).value ?? const [];
  return RewardProgress.next(balance, [
    for (final r in rewards)
      if (r.redeemedAt == null)
        RewardGoal(id: r.id, name: r.name, cost: r.starCost),
  ]);
});

final libraryProvider = StreamProvider<List<Task>>(
  (ref) => ref.watch(taskRepositoryProvider).watchLibrary(),
);

/// Whether parent mode is unlocked. Locks again on Exit, or when the app
/// goes to the background (unless the parent is in the camera/gallery).
class ParentSession extends Notifier<bool> {
  int _external = 0;

  @override
  bool build() => false;

  void unlock() => state = true;

  void lock() => state = false;

  void onAppHidden() {
    if (_external == 0) lock();
  }

  /// Runs [action] (which leaves the app, e.g. the camera) without locking.
  Future<T> whileOutside<T>(Future<T> Function() action) async {
    _external++;
    try {
      return await action();
    } finally {
      _external--;
    }
  }
}

final parentSessionProvider = NotifierProvider<ParentSession, bool>(
  ParentSession.new,
);
