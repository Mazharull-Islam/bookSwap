import 'models/book_review.dart';

class RatingSummary {
  const RatingSummary({required this.average, required this.count});
  final double average;
  final int count;

  /// "4.5" — one decimal, never "4.50".
  String get averageLabel => average.toStringAsFixed(1);

  String get spoken =>
      'Rated $averageLabel out of 5 from $count '
      '${count == 1 ? 'review' : 'reviews'}';
}

/// Average rating and review count per book (matchKey).
Map<String, RatingSummary> summarizeRatings(Iterable<BookReview> reviews) {
  final totals = <String, (int sum, int count)>{};
  for (final r in reviews) {
    final current = totals[r.matchKey] ?? (0, 0);
    totals[r.matchKey] = (current.$1 + r.rating, current.$2 + 1);
  }
  return {
    for (final e in totals.entries)
      e.key: RatingSummary(average: e.value.$1 / e.value.$2, count: e.value.$2),
  };
}

/// Newest first.
List<BookReview> reviewsForBook(
  Iterable<BookReview> reviews,
  String matchKey,
) =>
    reviews.where((r) => r.matchKey == matchKey).toList()
      ..sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs));
