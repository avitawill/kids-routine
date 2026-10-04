import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/gen/app_localizations.dart';
import '../widgets/picture_circle.dart';

/// Big preview plus buttons: emoji (optional), camera, gallery, remove photo.
class PictureEditor extends StatelessWidget {
  const PictureEditor({
    super.key,
    required this.photoPath,
    required this.emoji,
    required this.onPhoto,
    required this.onRemovePhoto,
    this.onPickEmoji,
  });

  final String? photoPath;
  final String emoji;
  final ValueChanged<ImageSource> onPhoto;
  final VoidCallback onRemovePhoto;
  final VoidCallback? onPickEmoji;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        PictureCircle(
          size: 140,
          photoPath: photoPath,
          emoji: emoji,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            if (onPickEmoji != null)
              OutlinedButton.icon(
                onPressed: onPickEmoji,
                icon: const Icon(Icons.emoji_emotions_outlined),
                label: Text(l.chooseEmoji),
              ),
            OutlinedButton.icon(
              onPressed: () => onPhoto(ImageSource.camera),
              icon: const Icon(Icons.photo_camera_outlined),
              label: Text(l.takePhoto),
            ),
            OutlinedButton.icon(
              onPressed: () => onPhoto(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(l.choosePhoto),
            ),
            if (photoPath != null)
              TextButton.icon(
                onPressed: onRemovePhoto,
                icon: const Icon(Icons.hide_image_outlined),
                label: Text(l.removePhoto),
              ),
          ],
        ),
      ],
    );
  }
}

/// − value + with a label. Directional, so − sits at the start in both
/// Hebrew and English.
class NumberStepper extends StatelessWidget {
  const NumberStepper({
    super.key,
    required this.label,
    required this.value,
    required this.display,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
  });

  final String label;
  final int value;
  final String display;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(child: Text(label, style: t.titleMedium)),
        IconButton.filledTonal(
          onPressed: value - step >= min ? () => onChanged(value - step) : null,
          icon: const Icon(Icons.remove_rounded),
        ),
        SizedBox(
          width: 88,
          child: Text(
            display,
            textAlign: TextAlign.center,
            style: t.titleLarge,
          ),
        ),
        IconButton.filledTonal(
          onPressed: value + step <= max ? () => onChanged(value + step) : null,
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }
}

const taskEmojis = [
  '🌅', '🛏️', '🚽', '🪥', '💦', '🚿', '🛁', '🧼', '👕', '👖', '👗', '🧦', //
  '👟', '🧥', '💇', '🎒', '🥣', '🍽️', '🥪', '🍎', '🍌', '🥛', '💧', '💊', //
  '📚', '✏️', '📖', '🎹', '🎨', '⚽', '🚲', '🧸', '🧹', '🗑️', '🐶', '🐱', //
  '🌱', '🌙', '💤', '🙏', '🍞', '✨', '⭐', '🎵', '🧘', '🏃', '🤸', '🦷',
];

Future<String?> pickEmoji(BuildContext context) => showModalBottomSheet<String>(
  context: context,
  showDragHandle: true,
  builder: (context) => SafeArea(
    child: GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      padding: const EdgeInsetsDirectional.all(12),
      children: [
        for (final e in taskEmojis)
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context, e),
            child: Center(child: Text(e, style: const TextStyle(fontSize: 32))),
          ),
      ],
    ),
  ),
);
