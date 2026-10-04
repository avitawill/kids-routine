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
    final session = ref.watch(sessionProvider(widget.type)).value;
    if (session == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

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

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _audio.stop();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: l.goHome,
                      iconSize: 32,
                      icon: const Icon(
                        Icons.home_rounded,
                        color: AppColors.inkSoft,
                      ),
                      onPressed: () => context.go('/'),
                    ),
                    const Spacer(),
                    StarCounter(count: stars),
                    const Spacer(),
                    IconButton(
                      tooltip: l.replayAudio,
                      iconSize: 32,
                      icon: const Icon(
                        Icons.volume_up_rounded,
                        color: AppColors.primary,
                      ),
                      onPressed: () => _replay(current.task),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _ProgressDots(
                  session: session,
                  frozenDoneId: _frozen?.$1.task.id,
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, box) {
                      final size = math.min(box.maxWidth, box.maxHeight) * 0.92;
                      return Center(
                        child: SizedBox.square(
                          dimension: size,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              PieTimer(
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
                              PositionedDirectional(
                                end: -8,
                                bottom: -8,
                                child: Mascot(
                                  size: size * 0.32,
                                  mood: _frozen != null
                                      ? MascotMood.cheer
                                      : _timeUp
                                      ? MascotMood.wave
                                      : MascotMood.idle,
                                ),
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
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  current.task.nameIn(lang),
                  style: t.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (next != null) _NextPeek(task: next.task, lang: lang),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.done,
                      foregroundColor: Colors.white,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NextPeek extends StatelessWidget {
  const _NextPeek({required this.task, required this.lang});

  final Task task;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final style = Theme.of(context).textTheme.titleMedium
        ?.copyWith(color: AppColors.inkSoft);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l.nextUp, style: style),
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
          child: Text(
            task.nameIn(lang),
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.session, this.frozenDoneId});

  final RoutineSession session;
  final int? frozenDoneId;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final t in session.tasks)
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.isDone || t.task.id == frozenDoneId
                    ? AppColors.done
                    : AppColors.timerTrack,
              ),
            ),
        ],
      ),
    );
  }
}
