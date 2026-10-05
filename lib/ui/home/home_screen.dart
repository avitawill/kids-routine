import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/db/database.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../state/providers.dart';
import '../labels.dart';
import '../mascot/mascot.dart';
import '../parent/gate/gear_hold_button.dart';
import '../theme.dart';
import '../widgets/star_counter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final child = ref.watch(childProvider).value;
    final stars = ref.watch(starBalanceProvider).value ?? 0;
    final hour = ref.watch(clockProvider)().hour;
    final name = nameKey(child?.name);
    final greeting = hour < 12
        ? l.greetingMorning(name)
        : hour < 17
        ? l.greetingNoon(name)
        : l.greetingEvening(name);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                StarCounter(count: stars),
                const Spacer(),
                GearHoldButton(
                  tooltip: l.holdForParents,
                  onHeld: () => context.push('/gate'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Mascot(size: 120),
                const SizedBox(width: 12),
                Expanded(
                  child: _SpeechBubble(
                    lines: [greeting, l.letsStart(genderKey(child?.gender))],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            for (final type in RoutineType.values) ...[
              _RoutineCard(type: type),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lines.first, style: t.titleLarge),
          for (final line in lines.skip(1)) Text(line, style: t.titleMedium),
        ],
      ),
    );
  }
}

class _RoutineCard extends ConsumerWidget {
  const _RoutineCard({required this.type});

  final RoutineType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final progress = ref.watch(sessionProvider(type)).value?.progress;

    final String subtitle;
    if (progress == null) {
      subtitle = '';
    } else if (progress.isComplete) {
      subtitle = l.routineFinished;
    } else {
      subtitle = l.routineProgress(progress.doneCount, progress.total);
    }

    return Opacity(
      // An empty routine (all tasks removed) has nothing to start.
      opacity: progress != null && progress.total == 0 ? 0.5 : 1,
      child: Material(
        color: type.color,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: progress == null || progress.total == 0
              ? null
              : () => context.go(
                  progress.isComplete
                      ? '/celebrate/${type.name}'
                      : '/routine/${type.name}',
                ),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(20),
            child: Row(
              children: [
                Text(type.emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(type.label(l), style: t.headlineMedium),
                      const SizedBox(height: 4),
                      Text(subtitle, style: t.titleMedium),
                      if (progress != null && progress.total > 0) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress.doneCount / progress.total,
                            minHeight: 12,
                            color: AppColors.done,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ],
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
