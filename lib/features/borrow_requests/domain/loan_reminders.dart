import 'entities/borrow_request.dart';

/// Local time of day the "due" reminders go out.
const reminderHour = 9;

enum ReminderKind { dayBefore, dueDay, overdue }

/// One notification the app wants scheduled.
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.requestId,
    required this.kind,
    required this.at,
    required this.title,
    required this.body,
  });

  /// Stable for a given loan and kind, so rescheduling replaces the old one.
  final int id;
  final String requestId;
  final ReminderKind kind;
  final DateTime at;
  final String title;
  final String body;

  /// What identifies this reminder's content. A reminder already scheduled
  /// with the same id and payload needs no work; a different payload (the due
  /// date moved, or the wording changed) means it must be rescheduled.
  String get payload => '${at.millisecondsSinceEpoch}|$title|$body';

  @override
  String toString() => 'PlannedReminder($kind $at "$body")';
}

/// FNV-1a. Dart's String.hashCode isn't stable between runs, and these ids
/// must still match after the app restarts.
int _stableHash(String s) {
  var h = 0x811C9DC5;
  for (final unit in s.codeUnits) {
    h = ((h ^ unit) * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

int reminderId(String requestId, ReminderKind kind) =>
    // 29 bits of hash, 2 for the kind: stays inside a 32-bit signed int,
    // which is all the platform notification ids allow.
    ((_stableHash(requestId) & 0x1FFFFFFF) << 2) | kind.index;

/// Active means accepted, not yet returned, with a return date.
bool isActiveLoan(BorrowRequest r) =>
    r.status == RequestStatus.accepted &&
    r.returnedAt == null &&
    r.expectedReturnDateMs != null;

/// What should be scheduled right now for [myId]'s loans.
///
/// A pure function of the loans and the clock: the scheduler diffs this
/// against what's already scheduled. Times already in the past are dropped,
/// so a loan that's long overdue produces nothing rather than a burst.
List<PlannedReminder> planReminders({
  required String myId,
  required List<BorrowRequest> requests,
  required DateTime now,
}) {
  final planned = <PlannedReminder>[];
  for (final r in requests) {
    if (!isActiveLoan(r)) continue;
    final borrowing = r.borrowerId == myId;
    final lending = r.lenderId == myId;
    if (!borrowing && !lending) continue;

    final due = DateTime.fromMillisecondsSinceEpoch(
      r.expectedReturnDateMs!,
    ).toLocal();
    DateTime day(int offset) =>
        DateTime(due.year, due.month, due.day + offset, reminderHour);
    final book = "'${r.bookTitle}'";

    final candidates = <(ReminderKind, DateTime, String, String)>[
      if (borrowing) ...[
        (
          ReminderKind.dayBefore,
          day(-1),
          'Return due tomorrow',
          '$book is due back tomorrow.',
        ),
        (
          ReminderKind.dueDay,
          day(0),
          'Return due today',
          '$book is due back today.',
        ),
        (
          ReminderKind.overdue,
          day(1),
          'Book overdue',
          '$book was due back yesterday. Arrange the return with the owner.',
        ),
      ] else ...[
        (
          ReminderKind.dayBefore,
          day(-1),
          'Book due back tomorrow',
          '$book is due back from the borrower tomorrow.',
        ),
        (
          ReminderKind.dueDay,
          day(0),
          'Book due back today',
          '$book is due back from the borrower today.',
        ),
        (
          ReminderKind.overdue,
          day(1),
          'Book overdue',
          "$book hasn't come back yet. It was due yesterday.",
        ),
      ],
    ];

    for (final (kind, at, title, body) in candidates) {
      if (!at.isAfter(now)) continue;
      planned.add(
        PlannedReminder(
          id: reminderId(r.id, kind),
          requestId: r.id,
          kind: kind,
          at: at,
          title: title,
          body: body,
        ),
      );
    }
  }
  planned.sort((a, b) => a.at.compareTo(b.at));
  return planned;
}
