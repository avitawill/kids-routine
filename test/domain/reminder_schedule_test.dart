import 'package:flutter_test/flutter_test.dart';
import 'package:kids_routine/domain/enums.dart';
import 'package:kids_routine/domain/reminder_schedule.dart';

void main() {
  // Monday 5 Oct 2026, 08:00.
  final now = DateTime(2026, 10, 5, 8, 0);
  const everyDay = 0x7f;
  int bit(int weekday) => 1 << (weekday - 1);

  test('one reminder per enabled routine per scheduled day, in order', () {
    final r = upcomingReminders(
      [
        const ReminderRule(RoutineType.morning, 7 * 60, everyDay, true),
        const ReminderRule(RoutineType.evening, 19 * 60, everyDay, true),
        const ReminderRule(RoutineType.noon, 13 * 60, everyDay, false),
      ],
      now,
      days: 3,
    );
    // Today's 07:00 has passed; 19:00 hasn't.
    expect(r.map((x) => (x.routine, x.at)), [
      (RoutineType.evening, DateTime(2026, 10, 5, 19)),
      (RoutineType.morning, DateTime(2026, 10, 6, 7)),
      (RoutineType.evening, DateTime(2026, 10, 6, 19)),
      (RoutineType.morning, DateTime(2026, 10, 7, 7)),
      (RoutineType.evening, DateTime(2026, 10, 7, 19)),
    ]);
  });

  test('respects the days of the week', () {
    final weekdaysOnly =
        bit(DateTime.monday) |
        bit(DateTime.tuesday) |
        bit(DateTime.wednesday) |
        bit(DateTime.thursday) |
        bit(DateTime.sunday);
    final r = upcomingReminders(
      [ReminderRule(RoutineType.morning, 7 * 60, weekdaysOnly, true)],
      now,
      days: 7,
    );
    expect(
      r.map((x) => x.at.weekday),
      everyElement(isNot(anyOf(DateTime.friday, DateTime.saturday))),
    );
    expect(r, hasLength(4)); // Tue, Wed, Thu, Sun (Monday's has passed)
  });

  test('ids are stable per routine and day, and unique', () {
    final r = upcomingReminders(
      [
        const ReminderRule(RoutineType.morning, 7 * 60, everyDay, true),
        const ReminderRule(RoutineType.noon, 13 * 60, everyDay, true),
      ],
      now,
      days: 14,
    );
    expect(r.map((x) => x.id).toSet(), hasLength(r.length));
    final again = upcomingReminders(
      [const ReminderRule(RoutineType.noon, 13 * 60, everyDay, true)],
      now,
      days: 14,
    );
    expect(
      again.first.id,
      r.firstWhere((x) => x.routine == RoutineType.noon).id,
    );
  });

  test('nothing when no reminder is on', () {
    expect(
      upcomingReminders([
        const ReminderRule(RoutineType.morning, 420, everyDay, false),
      ], now),
      isEmpty,
    );
  });
}
