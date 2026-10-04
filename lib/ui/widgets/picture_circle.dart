import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../theme.dart';

/// A round picture: the stored photo if there is one, else the emoji.
class PictureCircle extends ConsumerWidget {
  const PictureCircle({
    super.key,
    required this.size,
    this.photoPath,
    this.emoji,
    this.fallbackEmoji = '⭐',
    this.color = AppColors.surface,
  });

  final double size;

  /// Relative to the media store.
  final String? photoPath;
  final String? emoji;
  final String fallbackEmoji;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(mediaStoreProvider).existing(photoPath);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: file != null
          ? Image.file(file, fit: BoxFit.cover, width: size, height: size)
          : ExcludeSemantics(
              child: Text(
                emoji ?? fallbackEmoji,
                style: TextStyle(fontSize: size * 0.5),
              ),
            ),
    );
  }
}
