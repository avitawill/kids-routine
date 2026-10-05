import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/db/database.dart';
import 'l10n/gen/app_localizations.dart';
import 'router.dart';
import 'state/providers.dart';
import 'state/reminder_sync.dart';
import 'ui/theme.dart';

class KidsRoutineApp extends ConsumerStatefulWidget {
  const KidsRoutineApp({super.key});

  @override
  ConsumerState<KidsRoutineApp> createState() => _KidsRoutineAppState();
}

class _KidsRoutineAppState extends ConsumerState<KidsRoutineApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      // Parent mode never stays open in the background.
      onHide: () => ref.read(parentSessionProvider.notifier).onAppHidden(),
      onResume: () {
        // A new day may have started while the app was in the background.
        ref.invalidate(sessionProvider);
        _syncReminders();
      },
    );
    _initReminders();
  }

  Future<void> _initReminders() async {
    final reminders = ref.read(remindersProvider);
    void open(RoutineType type) {
      ref.read(parentSessionProvider.notifier).lock();
      ref.read(routerProvider).go('/routine/${type.name}');
    }

    await reminders.init(open);
    final launched = await reminders.launchedFrom();
    if (launched != null && mounted) open(launched);
  }

  void _syncReminders() {
    final routines = ref.read(routinesProvider).value;
    final child = ref.read(childProvider).value;
    if (routines == null || child == null) return;
    syncReminders(
      ref.read(remindersProvider),
      routines,
      child,
      ref.read(clockProvider)(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Re-arm reminders when start times, days, switches, language or gender
    // change (and once both have loaded on launch).
    ref.listen(routinesProvider, (_, _) => _syncReminders());
    ref.listen(childProvider, (_, _) => _syncReminders());

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      // Changing the child's language rebuilds here: no restart needed.
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
