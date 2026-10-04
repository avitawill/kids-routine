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
  final day = DateTime.parse(date);
  return ref.watch(summaryRepositoryProvider).watchDay(day);
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
                    () => _day = _day.subtract(const Duration(days: 1)),
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
                          () => _day = _day.add(const Duration(days: 1)),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: summary == null
                ? const SizedBox.shrink()
                : _DayView(summary: summary, locale: locale),
          ),
        ],
      ),
    );
  }
}

class _DayView extends ConsumerWidget {
  const _DayView({required this.summary, required this.locale});

  final DaySummary summary;
  final String locale;

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
            Text(l.summaryStars(summary.starsEarned), style: t.titleMedium),
          ],
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
  });

  final TaskLogEntry entry;
  final Task task;
  final AppLanguage lang;
  final String Function(Duration) minutes;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final taken = entry.taken;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
      child: Row(
        children: [
          PictureCircle(size: 32, photoPath: task.photoPath, emoji: task.emoji),
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
    );
  }
}
