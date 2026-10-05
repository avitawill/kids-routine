import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/db/database.dart';
import '../../data/routine_repository.dart';
import '../../data/task_names.dart';
import '../../domain/timer_logic.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../services/audio_service.dart';
import '../../state/providers.dart';
import '../mascot/mascot.dart';
import '../theme.dart';
import '../widgets/child_text_scaling.dart';
import '../widgets/picture_circle.dart';
import '../widgets/star_burst.dart';
import '../widgets/star_counter.dart';
import 'pie_timer.dart';

/// One task at a time: picture inside a shrinking pie, the task name, a small
/// peek at the next task, and a big Done button.
class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key, required this.type});

  final RoutineType type;

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen>
    with SingleTickerProviderStateMixin {
  late final AudioCues _audio = ref.read(audioProvider);
  late final Ticker _ticker;

  /// Task whose timer and announcement have been started on this screen.
  int? _activeTaskId;
  TaskTimer? _timer;
  double _fraction = 1;
  bool _timeUp = false;

  /// True once the active task's timer was seen running, so the time-up
  /// chime only plays when time runs out while the child is watching.
  bool _sawRunning = false;

  /// The task the child picked to do now (any order is fine), if any.
  int? _chosenId;

  /// While the star burst plays, keep showing the task that was just done.
  (SessionTask, SessionTask?)? _frozen;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _audio.stop();
    super.dispose();
  }

  DateTime _now() => ref.read(clockProvider)();

  void _onTick(Duration _) {
    final timer = _timer;
    if (timer == null || _frozen != null) return;
    final now = _now();
    final fraction = timer.fractionRemaining(now);
    final up = timer.isTimeUp(now);
    if (!up) _sawRunning = true;
    if (up && !_timeUp && _sawRunning) _audio.playTimeUp();
    if (up != _timeUp || (fraction - _fraction).abs() > 0.002) {
      setState(() {
        _fraction = fraction;
        _timeUp = up;
      });
    }
  }

  void _activate(RoutineSession session, SessionTask current) {
    _activeTaskId = current.task.id;
    _sawRunning = false;
    _timeUp = false;
    _fraction = 1;
    final lang = ref.read(childProvider).value?.language ?? AppLanguage.he;
    ref
        .read(repositoryProvider)
        .ensureStarted(session.routine.id, current.task.id, _now());
    _audio.announceTask(current.task, lang);
  }

  void _onDone(RoutineSession session) {
    final current = session.current;
    if (current == null || _frozen != null) return;
    // Reward first, instantly; the DB write follows.
    HapticFeedback.lightImpact();
    _audio.playStar();
    setState(() => _frozen = (current, session.next));
    ref
        .read(repositoryProvider)
        .completeTask(session.routine.id, current.task.id, _now());
  }

  /// The child picked another task: the current one waits (its timer starts
  /// over when it comes back) and the picked one becomes current.
  void _choose(RoutineSession session, int taskId) {
    final current = session.current;
    if (_frozen != null || current == null || current.task.id == taskId) {
      return;
    }
    HapticFeedback.selectionClick();
    ref
        .read(repositoryProvider)
        .pauseTask(session.routine.id, current.task.id, _now());
    setState(() => _chosenId = taskId);
  }

  void _replay(Task task) {
    final lang = ref.read(childProvider).value?.language ?? AppLanguage.he;
    _audio.announceTask(task, lang);
  }

  void _leave(String location) {
    if (_leaving) return;
    _leaving = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    final raw = ref.watch(sessionProvider(widget.type)).value;
    if (raw == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final session = raw.choose(_chosenId);

    if (_frozen == null) {
      if (session.progress.isComplete) {
        _leave('/celebrate/${widget.type.name}');
      } else if (session.current == null) {
        _leave('/'); // Empty routine: nothing to do here.
      }
    }

    final (current, next) = _frozen ?? (session.current, session.next);
    if (current == null) return const Scaffold(body: SizedBox.shrink());

    if (_frozen == null && current.task.id != _activeTaskId) {
      _activate(session, current);
    }
    final startedAt = current.runLog?.startedAt;
    _timer = startedAt == null
        ? null
        : TaskTimer(
            startedAt: startedAt,
            target: Duration(minutes: current.task.targetMinutes),
          );

    final l = AppLocalizations.of(context);
    final lang = ref.watch(childProvider).value?.language ?? AppLanguage.he;
    final stars = ref.watch(starBalanceProvider).value ?? 0;
    final t = Theme.of(context).textTheme;

    final mood = _frozen != null
        ? MascotMood.cheer
        : _timeUp
        ? MascotMood.wave
        : MascotMood.idle;

    final topBar = Row(
      children: [
        IconButton(
          tooltip: l.goHome,
          iconSize: 32,
          icon: const Icon(Icons.home_rounded, color: AppColors.inkSoft),
          onPressed: () => context.go('/'),
        ),
        const Spacer(),
        StarCounter(count: stars),
        const Spacer(),
        IconButton(
          tooltip: l.replayAudio,
          iconSize: 32,
          icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
          onPressed: () => _replay(current.task),
        ),
      ],
    );

    final pie = LayoutBuilder(
      builder: (context, box) {
        final size = math.min(box.maxWidth, box.maxHeight) * 0.92;
        final minutesLeft = _timer == null
            ? current.task.targetMinutes
            : (_timer!.target.inSeconds * _fraction / 60).ceil();
        return Center(
          child: SizedBox.square(
            dimension: size,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Screen readers get the time left; it is never shown as a
                // number on screen (no clocks in child mode).
                Semantics(
                  label: l.taskTimeLeft(minutesLeft),
                  child: PieTimer(
                    fraction: _fraction,
                    color: AppColors.timer,
                    trackColor: AppColors.timerTrack,
                    child: Center(
                      child: PictureCircle(
                        size: size * 0.62,
                        photoPath: current.task.photoPath,
                        emoji: current.task.emoji,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  end: -8,
                  bottom: -8,
                  child: Mascot(size: size * 0.32, mood: mood),
                ),
                if (_frozen != null)
                  StarBurst(
                    key: ValueKey(_frozen!.$1.task.id),
                    size: size,
                    onDone: () {
                      if (mounted) setState(() => _frozen = null);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );

    final doneButton = ConstrainedBox(
      // Grows with large system text instead of clipping it.
      constraints: const BoxConstraints(
        minHeight: 80,
        minWidth: double.infinity,
      ),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.done,
          foregroundColor: Colors.white,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Fredoka',
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        // Stays enabled (and green) during the burst; _onDone ignores
        // repeat taps. A greyed-out button would read as "wrong".
        onPressed: () => _onDone(session),
        icon: const Icon(Icons.check_rounded, size: 40),
        label: Text(l.doneButton),
      ),
    );

    Widget taskColumn({required bool dots}) => Column(
      children: [
        topBar,
        if (dots)
          _ProgressDots(
            session: session,
            currentId: current.task.id,
            frozenDoneId: _frozen?.$1.task.id,
            onChoose: (id) => _choose(session, id),
          ),
        const SizedBox(height: 4),
        Expanded(child: pie),
        const SizedBox(height: 8),
        Text(
          current.task.nameIn(lang),
          style: t.displaySmall,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        if (next != null)
          _NextPeek(
            task: next.task,
            lang: lang,
            onTap: () => _choose(session, next.task.id),
          ),
        const SizedBox(height: 16),
        doneButton,
      ],
    );

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _audio.stop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
            child: childTextScaling(
              context,
              LayoutBuilder(
                builder: (context, box) {
                  // Tablet in landscape: the task beside a rail showing where
                  // the child is in the routine. Phones: one column.
                  final twoPane =
                      box.maxWidth >= 840 && box.maxWidth > box.maxHeight;
                  if (!twoPane) return taskColumn(dots: true);
                  return Row(
                    children: [
                      Expanded(child: taskColumn(dots: false)),
                      const SizedBox(width: 24),
                      SizedBox(
                        width: 280,
                        child: _ProgressRail(
                          session: session,
                          onChoose: (id) => _choose(session, id),
                          currentId: current.task.id,
                          frozenDoneId: _frozen?.$1.task.id,
                          lang: lang,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tablet only: the routine's tasks, done ones checked, the current one
/// highlighted. Small and quiet so the current task stays the focus.
class _ProgressRail extends StatelessWidget {
  const _ProgressRail({
    required this.session,
    required this.onChoose,
    required this.currentId,
    required this.frozenDoneId,
    required this.lang,
  });

  final RoutineSession session;
  final ValueChanged<int> onChoose;
  final int currentId;
  final int? frozenDoneId;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    return Semantics(
      label: l.progressRail,
      container: true,
      child: Container(
        padding: const EdgeInsetsDirectional.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: ListView(
          children: [
            for (final item in session.tasks)
              Builder(
                builder: (context) {
                  final done = item.isDone || item.task.id == frozenDoneId;
                  final isCurrent = item.task.id == currentId && !done;
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    // Any task not done yet can be picked to do now.
                    onTap: done || isCurrent
                        ? null
                        : () => onChoose(item.task.id),
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 6),
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.timerTrack
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Text(
                            item.task.emoji ?? '⭐',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.task.nameIn(lang),
                              style: (isCurrent ? t.titleMedium : t.bodyLarge)
                                  ?.copyWith(
                                    color: done ? AppColors.inkSoft : null,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (done)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.done,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _NextPeek extends StatelessWidget {
  const _NextPeek({
    required this.task,
    required this.lang,
    required this.onTap,
  });

  final Task task;
  final AppLanguage lang;

  /// Do this one now instead.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final style = Theme.of(context).textTheme.titleMedium
        ?.copyWith(color: AppColors.inkSoft);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Text(l.nextUp, style: style, maxLines: 1)),
            const SizedBox(width: 6),
            // arrow_forward follows text direction: points left in Hebrew.
            const Icon(
              Icons.arrow_forward_rounded,
              size: 20,
              color: AppColors.inkSoft,
            ),
            const SizedBox(width: 6),
            Text(task.emoji ?? '', style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 4),
            Flexible(
              flex: 2,
              child: Text(
                task.nameIn(lang),
                style: style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({
    required this.session,
    required this.currentId,
    required this.onChoose,
    this.frozenDoneId,
  });

  final RoutineSession session;
  final int currentId;
  final ValueChanged<int> onChoose;
  final int? frozenDoneId;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        for (final t in session.tasks)
          Builder(
            builder: (context) {
              final done = t.isDone || t.task.id == frozenDoneId;
              final isCurrent = t.task.id == currentId && !done;
              return Semantics(
                button: !done && !isCurrent,
                label: t.task.emoji,
                child: InkResponse(
                  radius: 18,
                  // A not-done task can be picked to do now.
                  onTap: done || isCurrent ? null : () => onChoose(t.task.id),
                  child: SizedBox.square(
                    dimension: 30,
                    child: Center(
                      child: Container(
                        width: isCurrent ? 20 : 14,
                        height: isCurrent ? 20 : 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done
                              ? AppColors.done
                              : isCurrent
                              ? AppColors.surface
                              : AppColors.timerTrack,
                          border: isCurrent
                              ? Border.all(color: AppColors.timer, width: 4)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
