import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/core/utils/date_format.dart';

void main() {
  group('formatDateTime', () {
    test('afternoon and morning', () {
      expect(
        formatDateTime(DateTime(2026, 10, 3, 14, 5)),
        'Oct 3, 2026 · 2:05 PM',
      );
      expect(
        formatDateTime(DateTime(2026, 10, 3, 9, 30)),
        'Oct 3, 2026 · 9:30 AM',
      );
    });

    test('midnight and noon read as 12, not 0', () {
      expect(
        formatDateTime(DateTime(2026, 1, 1, 0, 0)),
        'Jan 1, 2026 · 12:00 AM',
      );
      expect(
        formatDateTime(DateTime(2026, 1, 1, 12, 0)),
        'Jan 1, 2026 · 12:00 PM',
      );
    });

    test('from a stored timestamp, in local time', () {
      final when = DateTime(2026, 10, 3, 21, 45);
      expect(
        formatDateTimeMs(when.millisecondsSinceEpoch),
        'Oct 3, 2026 · 9:45 PM',
      );
    });
  });
}
