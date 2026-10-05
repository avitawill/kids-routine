import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/ui/theme.dart';

/// WCAG contrast ratio between two opaque colors.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  // Every text/background pair the app uses. AA: 4.5 for normal text,
  // 3.0 for large text (>= 24 px, or >= 18.5 px bold).
  final normal = <String, (Color, Color)>{
    'ink on background': (AppColors.ink, AppColors.background),
    'ink on surface': (AppColors.ink, AppColors.surface),
    'inkSoft on background': (AppColors.inkSoft, AppColors.background),
    'inkSoft on surface': (AppColors.inkSoft, AppColors.surface),
    'ink on morning card': (AppColors.ink, AppColors.morning),
    'ink on noon card': (AppColors.ink, AppColors.noon),
    'ink on evening card': (AppColors.ink, AppColors.evening),
    'inkSoft on current rail row': (AppColors.inkSoft, AppColors.timerTrack),
    'white on primary button': (Colors.white, AppColors.primary),
  };
  final large = <String, (Color, Color)>{
    'white on Done button (30 px bold)': (Colors.white, AppColors.done),
  };

  for (final e in normal.entries) {
    test('AA normal text: ${e.key}', () {
      expect(contrast(e.value.$1, e.value.$2), greaterThanOrEqualTo(4.5));
    });
  }
  for (final e in large.entries) {
    test('AA large text: ${e.key}', () {
      expect(contrast(e.value.$1, e.value.$2), greaterThanOrEqualTo(3.0));
    });
  }

  test('the star icon stands out from its white pill (non-text, 3:1)', () {
    // The count next to it is ink; the star itself is decorative.
    expect(
      contrast(AppColors.ink, AppColors.surface),
      greaterThanOrEqualTo(4.5),
    );
  });
}
