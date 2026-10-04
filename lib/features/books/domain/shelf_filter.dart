import '../../../shared/genre_filter.dart';
import 'models/book.dart';

enum ShelfSort { recent, title, author, value }

class ShelfFilter {
  const ShelfFilter({
    this.genres = const {},
    this.conditions = const {},
    this.statuses = const {},
    this.sort = ShelfSort.recent,
  });

  final Set<String> genres;
  final Set<String> conditions;
  final Set<BookStatus> statuses;
  final ShelfSort sort;

  int get activeCount =>
      (genres.isEmpty ? 0 : 1) +
      (conditions.isEmpty ? 0 : 1) +
      (statuses.isEmpty ? 0 : 1) +
      (sort == ShelfSort.recent ? 0 : 1);

  ShelfFilter copyWith({
    Set<String>? genres,
    Set<String>? conditions,
    Set<BookStatus>? statuses,
    ShelfSort? sort,
  }) => ShelfFilter(
    genres: genres ?? this.genres,
    conditions: conditions ?? this.conditions,
    statuses: statuses ?? this.statuses,
    sort: sort ?? this.sort,
  );
}

List<Book> applyShelfFilter(List<Book> books, ShelfFilter filter) {
  final result = books.where((book) {
    if (!genreMatchesAny(book.genre, filter.genres)) return false;
    if (filter.conditions.isNotEmpty &&
        !filter.conditions.contains(book.condition)) {
      return false;
    }
    if (filter.statuses.isNotEmpty && !filter.statuses.contains(book.status)) {
      return false;
    }
    return true;
  }).toList();
  switch (filter.sort) {
    case ShelfSort.recent:
      result.sort((a, b) => b.updatedAtMs.compareTo(a.updatedAtMs));
    case ShelfSort.title:
      result.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    case ShelfSort.author:
      result.sort(
        (a, b) => a.author.toLowerCase().compareTo(b.author.toLowerCase()),
      );
    case ShelfSort.value:
      result.sort((a, b) => b.estimatedValue.compareTo(a.estimatedValue));
  }
  return result;
}
