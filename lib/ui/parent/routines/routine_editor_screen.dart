import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/db/database.dart';
import '../../../data/task_names.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../state/providers.dart';
import '../../labels.dart';
import '../../widgets/picture_circle.dart';
import '../parent_scaffold.dart';

final _routineProvider = StreamProvider.family<Routine, RoutineType>(
  (ref, type) => ref.watch(repositoryProvider).watchRoutine(type),
);

final _itemsProvider = StreamProvider.family<List<(RoutineTask, Task)>, int>(
  (ref, routineId) =>
      ref.watch(repositoryProvider).watchRoutineItems(routineId),
);

/// Weekdays in the order an Israeli calendar shows them, with their
/// [DateTime.weekday] numbers.
const _weekdays = [
  ('sun', DateTime.sunday),
  ('mon', DateTime.monday),
  ('tue', DateTime.tuesday),
  ('wed', DateTime.wednesday),
  ('thu', DateTime.thursday),
  ('fri', DateTime.friday),
  ('sat', DateTime.saturday),
];

int _bit(int weekday) => 1 << (weekday - 1);

class RoutineEditorScreen extends ConsumerStatefulWidget {
  const RoutineEditorScreen({super.key, required this.type});

  final RoutineType type;

  @override
  ConsumerState<RoutineEditorScreen> createState() =>
      _RoutineEditorScreenState();
}

class _RoutineEditorScreenState extends ConsumerState<RoutineEditorScreen> {
  /// Local order while dragging, so the list doesn't jump before the DB
  /// write comes back.
  List<(RoutineTask, Task)>? _optimistic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final routine = ref.watch(_routineProvider(widget.type)).value;
    if (routine == null) {
      return ParentScaffold(
        title: widget.type.label(l),
        body: const SizedBox.shrink(),
      );
    }
    final repo = ref.read(repositoryProvider);
    final lang = ref.watch(childProvider).value?.language ?? AppLanguage.he;
    final items = ref.watch(_itemsProvider(routine.id)).value ?? const [];
    final shown = _optimistic ?? items;

    return ParentScaffold(
      title: '${widget.type.emoji} ${widget.type.label(l)}',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(routine, items),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.addTask),
      ),
      body: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        padding: const EdgeInsets.only(bottom: 96),
        header: _Settings(routine: routine),
        footer: shown.isEmpty
            ? Padding(
                padding: const EdgeInsetsDirectional.all(24),
                child: Center(child: Text(l.routineEmpty)),
              )
            : null,
        itemCount: shown.length,
        onReorderItem: (from, to) {
          final list = [...shown];
          list.insert(to, list.removeAt(from));
          setState(() => _optimistic = list);
          repo
              .reorder(routine.id, [for (final (rt, _) in list) rt.id])
              .whenComplete(() {
                if (mounted) setState(() => _optimistic = null);
              });
        },
        itemBuilder: (context, i) {
          final (rt, task) = shown[i];
          return ListTile(
            key: ValueKey(rt.id),
            leading: PictureCircle(
              size: 44,
              photoPath: task.photoPath,
              emoji: task.emoji,
            ),
            title: Text(task.nameIn(lang)),
            subtitle: Text(l.minutesShort(task.targetMinutes)),
            onTap: () => context.push('/parent/tasks/${task.id}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: l.removeFromRoutine,
                  icon: const Icon(Icons.remove_circle_outline_rounded),
                  onPressed: () => repo.removeFromRoutine(rt.id),
                ),
                ReorderableDragStartListener(
                  index: i,
                  child: Tooltip(
                    message: l.dragToReorder,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.drag_handle_rounded),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAddSheet(
    Routine routine,
    List<(RoutineTask, Task)> items,
  ) async {
    final l = AppLocalizations.of(context);
    final lang = ref.read(childProvider).value?.language ?? AppLanguage.he;
    final inRoutine = {for (final (_, t) in items) t.id};
    // The Jewish pack is placed by its own switch (M3), not from here.
    final available = (await ref.read(taskRepositoryProvider).getLibrary())
        .where((t) => !inRoutine.contains(t.id) && t.pack != TaskPack.jewish)
        .toList();

    if (!mounted) return;
    final picked = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (context, scroll) => ListView(
          controller: scroll,
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle_rounded),
              title: Text(l.newTask),
              onTap: () => Navigator.pop(context, -1),
            ),
            const Divider(),
            for (final t in available)
              ListTile(
                leading: PictureCircle(
                  size: 40,
                  photoPath: t.photoPath,
                  emoji: t.emoji,
                ),
                title: Text(t.nameIn(lang)),
                subtitle: Text(l.minutesShort(t.targetMinutes)),
                onTap: () => Navigator.pop(context, t.id),
              ),
          ],
        ),
      ),
    );
    if (picked == null || !mounted) return;
    if (picked == -1) {
      context.push('/parent/tasks/new?routine=${widget.type.name}');
    } else {
      await ref.read(repositoryProvider).addToRoutine(routine.id, picked);
    }
  }
}

class _Settings extends ConsumerWidget {
  const _Settings({required this.routine});

  final Routine routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final repo = ref.read(repositoryProvider);
    final start = TimeOfDay(
      hour: routine.startMinutes ~/ 60,
      minute: routine.startMinutes % 60,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.schedule_rounded),
          title: Text(l.routineStartTime),
          trailing: Text(
            MaterialLocalizations.of(context)
                .formatTimeOfDay(start, alwaysUse24HourFormat: true),
            style: t.titleMedium,
          ),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: start,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              ),
            );
            if (picked != null) {
              await repo.updateRoutine(
                routine.id,
                startMinutes: picked.hour * 60 + picked.minute,
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 4),
          child: Text(l.routineDays, style: t.titleMedium),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final (key, weekday) in _weekdays)
                FilterChip(
                  label: Text(l.dayShort(key)),
                  showCheckmark: false,
                  selected: routine.daysOfWeek & _bit(weekday) != 0,
                  onSelected: (on) => repo.updateRoutine(
                    routine.id,
                    daysOfWeek: on
                        ? routine.daysOfWeek | _bit(weekday)
                        : routine.daysOfWeek & ~_bit(weekday),
                  ),
                ),
            ],
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications_rounded),
          title: Text(l.routineReminder),
          subtitle: Text(l.routineReminderLater),
          value: routine.reminderEnabled,
          onChanged: (on) =>
              repo.updateRoutine(routine.id, reminderEnabled: on),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 4),
          child: Text(l.routineTasks, style: t.titleMedium),
        ),
      ],
    );
  }
}
