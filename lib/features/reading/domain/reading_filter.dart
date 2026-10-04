import '../../../shared/genre_filter.dart';
import 'entities/reading_entry.dart';

enum ReadingSort { recent, title, rating }

const _keep = Object();

class ReadingFilter {
  const ReadingFilter({
    this.query = '',
    this.genres = const {},
    this.minRating,
    this.sort = ReadingSort.recent,
  });

  /// Title, author or review text.
  final String query;
  final Set<String> genres;

  /// Only constrains books in the Read tab — to-read and in-progress books
  /// have no rating to compare against.
  final int? minRating;
  final ReadingSort sort;

  int get activeCount =>
      (query.trim().isEmpty ? 0 : 1) +
      (genres.isEmpty ? 0 : 1) +
      (minRating == null ? 0 : 1) +
      (sort == ReadingSort.recent ? 0 : 1);

  bool get isActive => activeCount > 0;

  ReadingFilter copyWith({
    String? query,
    Set<String>? genres,
    Object? minRating = _keep,
    ReadingSort? sort,
  }) => ReadingFilter(
    query: query ?? this.query,
    genres: genres ?? this.genres,
    minRating: identical(minRating, _keep) ? this.minRating : minRating as int?,
    sort: sort ?? this.sort,
  );
}

List<ReadingEntry> applyReadingFilter(
  List<ReadingEntry> entries,
  ReadingFilter filter,
) {
  final q = filter.query.trim().toLowerCase();
  final result = entries.where((e) {
    if (q.isNotEmpty &&
        !e.title.toLowerCase().contains(q) &&
        !e.author.toLowerCase().contains(q) &&
        !e.review.toLowerCase().contains(q)) {
      return false;
    }
    if (!genreMatchesAny(e.genre, filter.genres)) return false;
    final min = filter.minRating;
    if (min != null &&
        e.status == ReadingStatus.read &&
        (e.rating == null || e.rating! < min)) {
      return false;
    }
    return true;
  }).toList();
  switch (filter.sort) {
    case ReadingSort.recent:
      result.sort((a, b) => b.updatedAtMs.compareTo(a.updatedAtMs));
    case ReadingSort.title:
      result.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    case ReadingSort.rating:
      result.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
  }
  return result;
}
