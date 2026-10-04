import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../features/borrow_requests/domain/loan_reminders.dart';

/// A reminder already waiting on the device.
class ScheduledReminder {
  const ScheduledReminder(this.id, this.payload);
  final int id;
  final String? payload;
}

/// The device's notification scheduler, behind an interface so the logic that
/// decides what to schedule can be tested without a phone.
abstract interface class ReminderGateway {
  /// False where scheduled notifications can't work (web, desktop).
  bool get supported;

  /// Asks the system for permission; true if reminders can be shown.
  Future<bool> requestPermission();

  Future<List<ScheduledReminder>> pending();
  Future<void> schedule(PlannedReminder reminder);
  Future<void> cancel(int id);
  Future<void> cancelAll();
}

class LocalNotificationsGateway implements ReminderGateway {
  LocalNotificationsGateway({this.onTap});

  /// Called when the member taps a reminder.
  final void Function()? onTap;

  final _plugin = FlutterLocalNotificationsPlugin();
  Future<void>? _ready;

  @override
  bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> _init() => _ready ??= _plugin
      .initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          // Permission is asked for explicitly, when the member turns
          // reminders on or has a loan worth reminding about — not at launch.
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestSoundPermission: false,
            requestBadgePermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (_) => onTap?.call(),
      )
      .then((_) {});

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'loan_reminders',
      'Loan reminders',
      channelDescription: 'Reminders when a borrowed or lent book is due back',
    ),
    iOS: DarwinNotificationDetails(),
  );

  @override
  Future<bool> requestPermission() async {
    await _init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  @override
  Future<List<ScheduledReminder>> pending() async {
    await _init();
    final all = await _plugin.pendingNotificationRequests();
    return [for (final p in all) ScheduledReminder(p.id, p.payload)];
  }

  @override
  Future<void> schedule(PlannedReminder reminder) async {
    await _init();
    await _plugin.zonedSchedule(
      id: reminder.id,
      title: reminder.title,
      body: reminder.body,
      // An absolute instant, so no local time-zone database is needed: the
      // local 9:00 was already worked out in Dart and is passed as UTC.
      scheduledDate: tz.TZDateTime.from(reminder.at.toUtc(), tz.UTC),
      notificationDetails: _details,
      // Inexact: a few minutes' drift is fine for a day-level reminder, and it
      // avoids the exact-alarm permission.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: reminder.payload,
    );
  }

  @override
  Future<void> cancel(int id) async {
    await _init();
    await _plugin.cancel(id: id);
  }

  @override
  Future<void> cancelAll() async {
    await _init();
    await _plugin.cancelAll();
  }
}
