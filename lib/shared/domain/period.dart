/// A period is just a calendar month — "2026-09" — with no server-side
/// start/close step. The current month is always open; anything else is
/// implicitly frozen the moment it's no longer the current month.
String _periodOf(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}';

String currentPeriodId() => _periodOf(DateTime.now());

/// How many months before the current one can still be looked at.
const previousPeriodsShown = 2;

/// The current month followed by the [previous] months before it, newest
/// first ("2026-10", "2026-09", "2026-08"). Counts back across year ends.
List<String> recentPeriodIds({
  int previous = previousPeriodsShown,
  DateTime? now,
}) {
  final base = now ?? DateTime.now();
  return [
    for (var back = 0; back <= previous; back++)
      _periodOf(DateTime(base.year, base.month - back)),
  ];
}

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String periodLabel(String periodId) {
  final parts = periodId.split('-');
  if (parts.length != 2) return periodId;
  final month = int.tryParse(parts[1]);
  if (month == null || month < 1 || month > 12) return periodId;
  return '${_monthNames[month - 1]} ${parts[0]}';
}
