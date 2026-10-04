import 'package:bookswap_login/core/services/reminder_gateway.dart';
import 'package:bookswap_login/features/borrow_requests/domain/loan_reminders.dart';

/// In-memory stand-in for the phone's notification scheduler.
class FakeReminderGateway implements ReminderGateway {
  FakeReminderGateway({this.supported = true, this.allowed = true});

  @override
  final bool supported;

  /// What the permission prompt answers.
  bool allowed;

  int permissionRequests = 0;
  final scheduled = <int, PlannedReminder>{};
  final log = <String>[];

  /// The reminders currently waiting, soonest first.
  List<PlannedReminder> get waiting =>
      scheduled.values.toList()..sort((a, b) => a.at.compareTo(b.at));

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return allowed;
  }

  @override
  Future<List<ScheduledReminder>> pending() async => [
    for (final r in scheduled.values) ScheduledReminder(r.id, r.payload),
  ];

  @override
  Future<void> schedule(PlannedReminder reminder) async {
    log.add('schedule ${reminder.kind.name} ${reminder.requestId}');
    scheduled[reminder.id] = reminder;
  }

  @override
  Future<void> cancel(int id) async {
    log.add('cancel $id');
    scheduled.remove(id);
  }

  @override
  Future<void> cancelAll() async {
    log.add('cancelAll');
    scheduled.clear();
  }
}
