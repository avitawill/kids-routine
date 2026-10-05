import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/enums.dart';
import '../domain/reminder_schedule.dart';

/// Localized text for reminder notifications.
class ReminderTexts {
  const ReminderTexts({
    required this.title,
    required this.body,
    required this.channelName,
  });

  final String Function(RoutineType) title;
  final String body;
  final String channelName;
}

/// Routine reminders. Abstract so tests can use a fake.
abstract class Reminders {
  /// Called with the routine when the parent/child taps a reminder.
  Future<void> init(void Function(RoutineType) onOpen);

  /// The routine whose reminder launched the app, if any.
  Future<RoutineType?> launchedFrom();

  /// Asks for the Android 13+ notification permission. True if allowed.
  Future<bool> requestPermission();

  /// Replaces every pending reminder with [slots].
  Future<void> replaceAll(List<ReminderSlot> slots, ReminderTexts texts);
}

class LocalReminders implements Reminders {
  final _plugin = FlutterLocalNotificationsPlugin();
  static const _channelId = 'routine_reminders';

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  static RoutineType? _parse(String? payload) =>
      RoutineType.values.where((t) => t.name == payload).firstOrNull;

  @override
  Future<void> init(void Function(RoutineType) onOpen) async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
      ),
      onDidReceiveNotificationResponse: (r) {
        final type = _parse(r.payload);
        if (type != null) onOpen(type);
      },
    );
  }

  @override
  Future<RoutineType?> launchedFrom() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return null;
    return _parse(details!.notificationResponse?.payload);
  }

  @override
  Future<bool> requestPermission() async =>
      await _android?.requestNotificationsPermission() ?? true;

  @override
  Future<void> replaceAll(List<ReminderSlot> slots, ReminderTexts texts) async {
    try {
      await _plugin.cancelAllPendingNotifications();
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          texts.channelName,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
        ),
      );
      for (final s in slots) {
        await _plugin.zonedSchedule(
          id: s.id,
          // An absolute instant: computed from the local wall-clock time, so
          // no time-zone database is needed.
          scheduledDate: tz.TZDateTime.from(s.at.toUtc(), tz.UTC),
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          title: texts.title(s.routine),
          body: texts.body,
          payload: s.routine.name,
        );
      }
    } catch (e) {
      // Reminders are a nice-to-have; never crash the app over them.
      debugPrint('reminders: $e');
    }
  }
}
