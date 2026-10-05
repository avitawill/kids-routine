import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/db/database.dart';
import '../../../data/task_names.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../state/providers.dart';
import '../../widgets/picture_circle.dart';
import '../parent_scaffold.dart';

/// Every task (built-in and custom), for editing.
class TaskLibraryScreen extends ConsumerWidget {
  const TaskLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = ref.watch(childProvider).value?.language ?? AppLanguage.he;
    final jewishOn = ref.watch(childProvider).value?.jewishPack ?? false;
    final tasks = (ref.watch(libraryProvider).value ?? const <Task>[])
        .where((t) => t.pack != TaskPack.jewish || jewishOn)
        .toList();

    return ParentScaffold(
      title: l.parentTasks,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/parent/tasks/new'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.newTask),
      ),
      body: ListView.builder(
        padding: const EdgeInsetsDirectional.only(bottom: 96),
        itemCount: tasks.length,
        itemBuilder: (context, i) {
          final t = tasks[i];
          return ListTile(
            leading: PictureCircle(
              size: 44,
              photoPath: t.photoPath,
              emoji: t.emoji,
            ),
            title: Text(t.nameIn(lang)),
            subtitle: Text(
              t.isBuiltIn
                  ? '${l.minutesShort(t.targetMinutes)} · ${l.builtIn}'
                  : l.minutesShort(t.targetMinutes),
            ),
            trailing: t.audioPath != null
                ? const Icon(Icons.mic_rounded, size: 20)
                : null,
            onTap: () => context.push('/parent/tasks/${t.id}'),
          );
        },
      ),
    );
  }
}
