import 'package:flutter/material.dart';

import '../data/db/database.dart';
import '../l10n/gen/app_localizations.dart';
import 'theme.dart';

extension RoutineTypeLabels on RoutineType {
  String label(AppLocalizations l) => switch (this) {
    RoutineType.morning => l.routineMorning,
    RoutineType.noon => l.routineNoon,
    RoutineType.evening => l.routineEvening,
  };

  String get emoji => switch (this) {
    RoutineType.morning => '🌅',
    RoutineType.noon => '☀️',
    RoutineType.evening => '🌙',
  };

  Color get color => switch (this) {
    RoutineType.morning => AppColors.morning,
    RoutineType.noon => AppColors.noon,
    RoutineType.evening => AppColors.evening,
  };

  /// Only the morning routine is playable in M1.
  bool get isAvailable => this == RoutineType.morning;
}

/// Value for ICU `select` on gender: `female`, else `other`.
String genderKey(Gender? g) => g == Gender.male ? 'male' : 'female';

/// Value for the greeting's `name` select (`empty` when not set).
String nameKey(String? name) =>
    (name == null || name.trim().isEmpty) ? 'empty' : name.trim();
