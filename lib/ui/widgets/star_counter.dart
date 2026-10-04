import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';
import '../theme.dart';

class StarCounter extends StatelessWidget {
  const StarCounter({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).starCount(count),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: AppColors.star, size: 28),
            const SizedBox(width: 4),
            Text('$count', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
