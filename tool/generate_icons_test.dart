// Generates the launcher icons from the app's own mascot painter.
//
// Run: flutter test tool/generate_icons_test.dart
// (A "test" only so it can use the Flutter engine to rasterize.)
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/ui/mascot/mascot.dart';
import 'package:kids_routine/ui/theme.dart';

const _res = 'android/app/src/main/res';
const _densities = {
  'mdpi': 1.0,
  'hdpi': 1.5,
  'xhdpi': 2.0,
  'xxhdpi': 3.0,
  'xxxhdpi': 4.0,
};

/// Draws the icon at [px] x [px]. [mascotScale] is the mascot's size relative
/// to the canvas; [background] null leaves it transparent (adaptive layer).
Future<List<int>> _render(
  int px, {
  required double mascotScale,
  Color? background,
  bool round = false,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final size = px.toDouble();
  if (background != null) {
    final paint = Paint()..color = background;
    if (round) {
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & Size.square(size),
          Radius.circular(size * 0.22),
        ),
        paint,
      );
    }
  }
  final m = size * mascotScale;
  canvas.translate((size - m) / 2, (size - m) / 2 - m * 0.04);
  MascotPainter(MascotMood.cheer).paint(canvas, Size.square(m));
  final image = await recorder.endRecording().toImage(px, px);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}

void main() {
  testWidgets('generate launcher icons', (tester) async {
    await tester.runAsync(() async {
      void write(String path, List<int> bytes) {
        File(path)
          ..parent.createSync(recursive: true)
          ..writeAsBytesSync(bytes);
      }

      for (final e in _densities.entries) {
        final legacy = (48 * e.value).round();
        final dir = '$_res/mipmap-${e.key}';
        write(
          '$dir/ic_launcher.png',
          await _render(
            legacy,
            mascotScale: 0.84,
            background: AppColors.background,
          ),
        );
        write(
          '$dir/ic_launcher_round.png',
          await _render(
            legacy,
            mascotScale: 0.8,
            background: AppColors.background,
            round: true,
          ),
        );
        // Adaptive foreground: 108dp canvas, keep the mascot inside the
        // 66dp safe zone.
        write(
          '$dir/ic_launcher_foreground.png',
          await _render((108 * e.value).round(), mascotScale: 0.58),
        );
      }
      // Play Store listing icon (512 x 512, full-bleed square).
      final store = ui.PictureRecorder();
      final canvas = Canvas(store);
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 512, 512),
        Paint()..color = AppColors.background,
      );
      canvas.translate(512 * 0.1, 512 * 0.08);
      MascotPainter(MascotMood.cheer).paint(canvas, const Size.square(512 * 0.8));
      final img = await store.endRecording().toImage(512, 512);
      final png = await img.toByteData(format: ui.ImageByteFormat.png);
      write('store/icon_512.png', png!.buffer.asUint8List());
    });
  });
}
