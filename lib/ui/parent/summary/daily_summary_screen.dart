import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/db/database.dart';
import '../../../data/summary_repository.dart';
import '../../../data/task_names.dart';
import '../../../domain/daily_summary.dart';
import '../../../domain/date_key.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../state/providers.dart';
import '../../labels.dart';
import '../../theme.dart';
import '../../widgets/picture_circle.dart';
import '../parent_scaffold.dart';

final _dayProvider = StreamProvider.family<DaySummary, String>((ref, date) {
  return ref.watch(summaryRepositoryProvider).watchDay(DateTime.parse(date));
});

/// What was done today (or another day) and how long each task took. Shown
/// neutrally: no red, no "late".
class DailySummaryScreen extends ConsumerStatefulWidget {
  const DailySummaryScreen({super.key});

  @override
  ConsumerState<DailySummaryScreen> createState() => _DailySummaryScreenState();
}

class _DailySummaryScreenState extends ConsumerState<DailySummaryScreen> {
  late DateTime _day = _dateOnly(ref.read(clockProvider)());

  static DateTime _dateOnly(DateTime t) => DateTime(t.year, t.month, t.day);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final today = _dateOnly(ref.watch(clockProvider)());
    final isToday = _day == today;
    final summary = ref.watch(_dayProvider(dateKey(_day))).value;

    return ParentScaffold(
      title: l.parentSummary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Row(
              children: [
                // arrow_back/forward follow text direction.
                IconButton(
                  tooltip: l.previousDay,
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => setState(
                    () => _day = _dateOnly(
                      _day.subtract(const Duration(hours: 12)),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    isToday ? l.today : DateFormat.MMMEd(locale).format(_day),
                    textAlign: TextAlign.center,
                    style: t.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: l.nextDay,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: isToday
                      ? null
                      : () => setState(
                          () => _day = _dateOnly(
                            _day.add(const Duration(hours: 36)),
                          ),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: summary == null
                ? const SizedBox.shrink()
                : _DayView(
                    summary: summary,
                    locale: locale,
                    day: _day,
                    isToday: isToday,
                  ),
          ),
        ],
      ),
    );
  }
}

class _DayView extends ConsumerWidget {
  const _DayView({
    required this.summary,
    required this.locale,
    required this.day,
    required this.isToday,
  });

  final DaySummary summary;
  final String locale;
  final DateTime day;

  /// Corrections (unchecking, restarting) are only offered for today.
  final bool isToday;

  Future<void> _uncheck(
    BuildContext context,
    WidgetRef ref,
    RoutineType type,
    Task task,
    AppLanguage lang,
  ) async {
    final l = AppLocalizations.of(context);
    final ok = await confirm(
      context,
      title: l.uncheckTask,
      body: l.uncheckConfirm(task.nameIn(lang)),
      confirmLabel: l.uncheckTask,
      cancelLabel: l.cancel,
    );
    if (!ok) return;
    final repo = ref.read(repositoryProvider);
    final routine = await repo.getRoutine(type);
    await repo.uncheckTask(routine.id, task.id, day);
  }

  Future<void> _reset(
    BuildContext context,
    WidgetRef ref,
    RoutineType type,
  ) async {
    final l = AppLocalizations.of(context);
    final ok = await confirm(
      context,
      title: l.resetRoutine,
      body: l.resetRoutineConfirm,
      confirmLabel: l.resetRoutine,
      cancelLabel: l.cancel,
    );
    if (!ok) return;
    final repo = ref.read(repositoryProvider);
    final routine = await repo.getRoutine(type);
    await repo.resetRoutineToday(routine.id, day);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final lang = ref.watch(childProvider).value?.language ?? AppLanguage.he;
    final hm = DateFormat.Hm(locale);

    String minutes(Duration d) => d.inSeconds < 60
        ? l.lessThanMinute
        : l.minutesShort((d.inSeconds / 60).round());

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      children: [
        Row(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.star),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                l.summaryStars(summary.starsEarned),
                style: t.titleMedium,
              ),
            ),
          ],
        ),
        if (isToday && summary.routines.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 4),
            child: Text(l.summaryTapHint, style: t.bodyMedium),
          ),
        const SizedBox(height: 12),
        if (summary.routines.isEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.all(24),
            child: Center(child: Text(l.summaryEmpty)),
          ),
        for (final r in summary.routines)
          Card(
            margin: const EdgeInsetsDirectional.only(bottom: 12),
            color: r.routine.color.withValues(alpha: 0.35),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsetsDirectional.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${r.routine.emoji} ${r.routine.label(l)}',
                    style: t.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    r.isComplete
                        ? l.summaryFinished(
                            hm.format(r.startedAt),
                            hm.format(r.finishedAt!),
                            minutes(r.total!),
                          )
                        : l.summaryInProgress(
                            hm.format(r.startedAt),
                            r.doneCount,
                            r.taskCount,
                          ),
                    style: t.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  for (final e in r.tasks)
                    _TaskRow(
                      entry: e,
                      task: summary.tasks[e.taskId]!,
                      lang: lang,
                      minutes: minutes,
                      onTap: isToday && e.isDone
                          ? () => _uncheck(
                              context,
                              ref,
                              r.routine,
                              summary.tasks[e.taskId]!,
                              lang,
                            )
                          : null,
                    ),
                  if (isToday && r.doneCount > 0)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        onPressed: () => _reset(context, ref, r.routine),
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: Text(l.resetRoutine),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.entry,
    required this.task,
    required this.lang,
    required this.minutes,
    this.onTap,
  });

  final VoidCallback? onTap;

  final TaskLogEntry entry;
  final Task task;
  final AppLanguage lang;
  final String Function(Duration) minutes;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final taken = entry.taken;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
        child: Row(
          children: [
            PictureCircle(
              size: 32,
              photoPath: task.photoPath,
              emoji: task.emoji,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(task.nameIn(lang), style: t.bodyLarge)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                taken == null
                    ? l.summaryNotDone
                    : l.summaryTaken(minutes(taken), minutes(entry.target)),
                style: t.bodyMedium,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
