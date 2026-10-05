import 'enums.dart';

/// A routine's reminder settings, as the scheduler needs them.
class ReminderRule {
  const ReminderRule(
    this.routine,
    this.startMinutes,
    this.daysOfWeek,
    this.enabled,
  );

  final RoutineType routine;

  /// Minutes after local midnight.
  final int startMinutes;

  /// Bit (weekday - 1): Monday = bit 0 … Sunday = bit 6.
  final int daysOfWeek;
  final bool enabled;
}

/// One notification to schedule.
class ReminderSlot {
  const ReminderSlot(this.id, this.routine, this.at);

  /// Stable for the same routine and day, so rescheduling replaces it.
  final int id;
  final RoutineType routine;

  /// Local wall-clock time.
  final DateTime at;
}

/// Reminders for the next [days] days (starting today), soonest first.
///
/// Built from local calendar dates, so they stay at the right wall-clock time
/// across daylight-saving changes. Inexact on purpose: the app reschedules on
/// every launch and change, and never asks for exact alarms.
List<ReminderSlot> upcomingReminders(
  List<ReminderRule> rules,
  DateTime now, {
  int days = 14,
}) {
  final out = <ReminderSlot>[];
  for (var d = 0; d < days; d++) {
    final day = DateTime(now.year, now.month, now.day + d);
    for (final r in rules) {
      if (!r.enabled || r.daysOfWeek & (1 << (day.weekday - 1)) == 0) continue;
      final at = DateTime(
        day.year,
        day.month,
        day.day,
        r.startMinutes ~/ 60,
        r.startMinutes % 60,
      );
      if (!at.isAfter(now)) continue;
      // yyyymmdd * 10 + routine: unique, stable and fits in 32 bits.
      final id =
          (day.year % 100 * 10000 + day.month * 100 + day.day) * 10 +
          r.routine.index;
      out.add(ReminderSlot(id, r.routine, at));
    }
  }
  out.sort((a, b) => a.at.compareTo(b.at));
  return out;
}
