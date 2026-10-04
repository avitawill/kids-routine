import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/db/database.dart';
import '../../../domain/star_ledger.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../state/providers.dart';
import '../../theme.dart';
import '../../widgets/picture_circle.dart';
import '../../widgets/star_counter.dart';
import '../parent_scaffold.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final balance = ref.watch(starBalanceProvider).value ?? 0;
    final rewards = ref.watch(rewardsProvider).value ?? const <Reward>[];
    final open = rewards.where((r) => r.redeemedAt == null).toList();
    final redeemed = rewards.where((r) => r.redeemedAt != null).toList();
    final locale = Localizations.localeOf(context).toString();

    return ParentScaffold(
      title: l.parentRewards,
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: Center(child: StarCounter(count: balance)),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/parent/rewards/new'),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.addReward),
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.only(bottom: 96),
        children: [
          if (rewards.isEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.all(24),
              child: Center(
                child: Text(l.rewardsEmpty, textAlign: TextAlign.center),
              ),
            ),
          for (final r in open)
            _OpenReward(
              reward: r,
              balance: balance,
              onRedeem: () => _redeem(context, ref, r),
            ),
          if (redeemed.isNotEmpty) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 4),
              child: Text(
                l.redeemedSection,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final r in redeemed)
              ListTile(
                leading: PictureCircle(
                  size: 40,
                  photoPath: r.photoPath,
                  emoji: '🎁',
                ),
                title: Text(r.name),
                subtitle: Text(
                  l.redeemedOn(DateFormat.yMd(locale).format(r.redeemedAt!)),
                ),
                trailing: TextButton(
                  onPressed: () =>
                      ref.read(rewardRepositoryProvider).offerAgain(r.id),
                  child: Text(l.offerAgain),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _redeem(BuildContext context, WidgetRef ref, Reward r) async {
    final l = AppLocalizations.of(context);
    final ok = await confirm(
      context,
      title: l.redeemConfirmTitle(r.name),
      body: l.redeemConfirmBody(r.starCost),
      confirmLabel: l.redeem,
      cancelLabel: l.cancel,
    );
    if (!ok) return;
    final done = await ref
        .read(rewardRepositoryProvider)
        .redeem(r.id, ref.read(clockProvider)());
    if (done && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.redeemDone)));
    }
  }
}

class _OpenReward extends StatelessWidget {
  const _OpenReward({
    required this.reward,
    required this.balance,
    required this.onRedeem,
  });

  final Reward reward;
  final int balance;
  final VoidCallback onRedeem;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final r = reward;
    return InkWell(
      onTap: () => context.push('/parent/rewards/${r.id}'),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            PictureCircle(size: 48, photoPath: r.photoPath, emoji: '🎁'),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name, style: t.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    l.rewardStarsHave(balance.clamp(0, r.starCost), r.starCost),
                    style: t.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: (balance / r.starCost).clamp(0.0, 1.0),
                    color: AppColors.star,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: canRedeem(balance: balance, cost: r.starCost)
                  ? onRedeem
                  : null,
              child: Text(l.redeem),
            ),
          ],
        ),
      ),
    );
  }
}
