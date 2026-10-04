/// A period is just a calendar month — "2026-09" — with no server-side
/// start/close step. The current month is always open; anything else is
/// implicitly frozen the moment it's no longer the current month.
String currentPeriodId() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
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
