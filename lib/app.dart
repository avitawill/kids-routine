import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/gen/app_localizations.dart';
import 'router.dart';
import 'state/providers.dart';
import 'ui/theme.dart';

class KidsRoutineApp extends ConsumerStatefulWidget {
  const KidsRoutineApp({super.key});

  @override
  ConsumerState<KidsRoutineApp> createState() => _KidsRoutineAppState();
}

class _KidsRoutineAppState extends ConsumerState<KidsRoutineApp> {
  // Parent mode never stays open in the background.
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onHide: () => ref.read(parentSessionProvider.notifier).onAppHidden(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
