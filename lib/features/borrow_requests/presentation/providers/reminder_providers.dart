import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../app/router.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/services/reminder_gateway.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../domain/loan_reminders.dart';
import 'request_providers.dart';

const _enabledKey = 'loanReminders';

/// The "Loan reminders" switch. On unless the member turned it off, and
/// remembered on this device like the theme choice.
class LoanRemindersEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    if (!Hive.isBoxOpen(HiveService.settingsBoxName)) return true;
    return Hive.box<String>(HiveService.settingsBoxName).get(_enabledKey) !=
        'off';
  }

  Future<void> set(bool enabled) async {
    state = enabled;
    if (Hive.isBoxOpen(HiveService.settingsBoxName)) {
      await Hive.box<String>(
        HiveService.settingsBoxName,
      ).put(_enabledKey, enabled ? 'on' : 'off');
    }
  }
}

final loanRemindersEnabledProvider =
    NotifierProvider<LoanRemindersEnabledNotifier, bool>(
      LoanRemindersEnabledNotifier.new,
    );

/// Brings what's scheduled on the device in line with what should be: adds
/// missing reminders, replaces ones whose date or wording changed, and cancels
/// ones that no longer apply (returned loans, other accounts, switched off).
/// Calls are queued so two reconciles never interleave.
class ReminderScheduler {
  ReminderScheduler(this._gateway);
  final ReminderGateway _gateway;

  Future<void> _tail = Future.value();
  bool? _permission;

  Future<void> _enqueue(Future<void> Function() job) {
    // A failure (plugin hiccup, revoked permission) must never break the queue
    // or surface in the UI: reminders are a convenience.
    _tail = _tail.then((_) => job()).catchError((_) {});
    return _tail;
  }

  Future<void> apply(List<PlannedReminder> wanted) => _enqueue(() async {
    if (!_gateway.supported) return;
    if (wanted.isNotEmpty) {
      _permission ??= await _gateway.requestPermission();
      if (_permission != true) return;
    }
    final pending = {for (final p in await _gateway.pending()) p.id: p.payload};
    final wantedIds = {for (final w in wanted) w.id};
    for (final id in pending.keys) {
      if (!wantedIds.contains(id)) await _gateway.cancel(id);
    }
    for (final w in wanted) {
      if (!pending.containsKey(w.id) || pending[w.id] != w.payload) {
        await _gateway.schedule(w);
      }
    }
  });

  /// Removes every reminder (sign-out, or the member turned them off).
  Future<void> clear() => _enqueue(() async {
    if (_gateway.supported) await _gateway.cancelAll();
  });
}

final reminderGatewayProvider = Provider<ReminderGateway>(
  (ref) => LocalNotificationsGateway(
    onTap: () => ref.read(routerProvider).go('/requests'),
  ),
);

final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => ReminderScheduler(ref.watch(reminderGatewayProvider)),
);

/// The clock, swappable in tests.
final reminderClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

/// Watched from the signed-in shell. Re-plans whenever the member's loans, the
/// switch or the account change.
final loanReminderSyncProvider = Provider<void>((ref) {
  final gateway = ref.watch(reminderGatewayProvider);
  if (!gateway.supported) return;
  final scheduler = ref.watch(reminderSchedulerProvider);
  final enabled = ref.watch(loanRemindersEnabledProvider);
  final auth = ref.watch(authControllerProvider);
  // Still working out who is signed in: touching nothing is safer than
  // cancelling reminders that are about to be needed again.
  if (auth.isLoading && !auth.hasValue) return;
  final user = auth.valueOrNull;
  if (user == null || !user.isMember || !enabled) {
    scheduler.clear();
    return;
  }
  final incoming = ref.watch(incomingRequestsProvider);
  final outgoing = ref.watch(outgoingRequestsProvider);
  // Wait for both lists; planning from half of them would cancel the rest.
  if (!incoming.hasValue || !outgoing.hasValue) return;
  scheduler.apply(
    planReminders(
      myId: user.id,
      requests: [...incoming.requireValue, ...outgoing.requireValue],
      now: ref.read(reminderClockProvider)(),
    ),
  );
});
