const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// "Oct 3, 2026".
String formatDate(DateTime date) =>
    '${_months[date.month - 1]} ${date.day}, ${date.year}';

String formatDateMs(int ms) =>
    formatDate(DateTime.fromMillisecondsSinceEpoch(ms).toLocal());

/// "Oct 3, 2026 · 2:15 PM", in the viewer's own time zone.
String formatDateTime(DateTime when) {
  final hour = when.hour % 12 == 0 ? 12 : when.hour % 12;
  final minute = when.minute.toString().padLeft(2, '0');
  final half = when.hour < 12 ? 'AM' : 'PM';
  return '${formatDate(when)} · $hour:$minute $half';
}

String formatDateTimeMs(int ms) =>
    formatDateTime(DateTime.fromMillisecondsSinceEpoch(ms).toLocal());

/// Calendar-day wording for a return date: "due today", "due tomorrow",
/// "due in 5 days", "1 day overdue", "3 days overdue". Wording (not just
/// colour) carries the overdue state.
String dueText(DateTime due, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final days = DateTime(
    due.year,
    due.month,
    due.day,
  ).difference(DateTime(today.year, today.month, today.day)).inDays;
  if (days == 0) return 'due today';
  if (days == 1) return 'due tomorrow';
  if (days > 1) return 'due in $days days';
  final late = -days;
  return late == 1 ? '1 day overdue' : '$late days overdue';
}
