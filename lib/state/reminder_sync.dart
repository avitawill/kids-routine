import 'package:flutter/widgets.dart';

import '../data/db/database.dart';
import '../domain/reminder_schedule.dart';
import '../l10n/gen/app_localizations.dart';
import '../services/reminders.dart';
import '../ui/labels.dart';

/// Re-arms every routine reminder for the next two weeks, in the child's
/// language. Called on launch, on resume, and whenever routines or the
/// child's settings change.
Future<void> syncReminders(
  Reminders reminders,
  List<Routine> routines,
  Child child,
  DateTime now,
) {
  final l = lookupAppLocalizations(Locale(child.language.name));
  final slots = upcomingReminders([
    for (final r in routines)
      ReminderRule(r.type, r.startMinutes, r.daysOfWeek, r.reminderEnabled),
  ], now);
  return reminders.replaceAll(
    slots,
    ReminderTexts(
      title: (type) => l.notificationTitle(type.name),
      body: l.letsStart(genderKey(child.gender)),
      channelName: l.reminderChannelName,
    ),
  );
}
