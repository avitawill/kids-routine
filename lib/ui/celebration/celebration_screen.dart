import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/db/database.dart';
import '../../domain/star_ledger.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../services/audio_service.dart';
import '../../state/providers.dart';
import '../labels.dart';
import '../mascot/mascot.dart';
import '../theme.dart';
import '../widgets/star_burst.dart';

/// End of a routine: the mascot cheers and shows the stars earned.
class CelebrationScreen extends ConsumerStatefulWidget {
  const CelebrationScreen({super.key, required this.type});

  final RoutineType type;

  @override
  ConsumerState<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends ConsumerState<CelebrationScreen> {
  late final AudioCues _audio = ref.read(audioProvider);

  @override
  void initState() {
    super.initState();
    _audio.playCelebration();
  }

  @override
  void dispose() {
    _audio.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final child = ref.watch(childProvider).value;
    final session = ref.watch(sessionProvider(widget.type)).value;
    final earned = (session?.progress.doneCount ?? 0) * StarRules.perTask;
    final total = ref.watch(starBalanceProvider).value ?? 0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Stack(
                alignment: Alignment.center,
                children: [
                  Mascot(mood: MascotMood.cheer, size: 200),
                  StarBurst(size: 320),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l.celebrationTitle(genderKey(child?.gender)),
                style: t.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l.celebrationRoutineDone(widget.type.label(l)),
                style: t.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (earned > 0)
                Text(
                  l.starsEarned(earned),
                  style: t.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 8),
              Text(
                l.starsTotal(total),
                style: t.titleLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 72,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Fredoka',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home_rounded, size: 32),
                  label: Text(l.goHome),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
