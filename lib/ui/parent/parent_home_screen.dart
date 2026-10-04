import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/db/database.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../state/providers.dart';
import '../labels.dart';
import 'parent_scaffold.dart';

class ParentHomeScreen extends ConsumerWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final stars = ref.watch(starBalanceProvider).value ?? 0;

    void exit() {
      ref.read(parentSessionProvider.notifier).lock();
      context.go('/');
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) exit();
      },
      child: ParentScaffold(
        title: l.parentMode,
        leading: IconButton(
          tooltip: l.exitParentMode,
          icon: const Icon(Icons.close_rounded),
          onPressed: exit,
        ),
        body: ListView(
          children: [
            _Header(l.parentRoutines),
            for (final type in RoutineType.values)
              ListTile(
                leading: Text(type.emoji, style: const TextStyle(fontSize: 28)),
                title: Text(type.label(l)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                onTap: () => context.go('/parent/routine/${type.name}'),
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.checklist_rounded),
              title: Text(l.parentTasks),
              onTap: () => context.go('/parent/tasks'),
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard_rounded),
              title: Text(l.parentRewards),
              subtitle: Text(l.starBalance(stars)),
              onTap: () => context.go('/parent/rewards'),
            ),
            ListTile(
              leading: const Icon(Icons.today_rounded),
              title: Text(l.parentSummary),
              onTap: () => context.go('/parent/summary'),
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: Text(l.parentSettings),
              onTap: () => context.go('/parent/settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}
