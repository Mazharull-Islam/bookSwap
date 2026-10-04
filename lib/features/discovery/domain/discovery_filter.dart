import '../../../shared/genre_filter.dart';
import '../../books/domain/entities/book.dart';
import 'book_group.dart';

enum DiscoverySort { title, nearest, value }

/// Distance choices for the sheet's slider; the last one means "no limit".
const distanceSteps = [1.0, 5.0, 10.0, 25.0, 50.0, 100.0, double.infinity];

const _keep = Object();

class DiscoveryFilter {
  const DiscoveryFilter({
    this.genres = const {},
    this.conditions = const {},
    this.availableOnly = false,
    this.maxDistanceKm,
    this.valueRange,
    this.sort = DiscoverySort.title,
  });

  final Set<String> genres;
  final Set<String> conditions;
  final bool availableOnly;

  /// Null = defer to the Profile limit; double.infinity = explicitly no
  /// limit for this search.
  final double? maxDistanceKm;

  /// Null = any value.
  final ValueRange? valueRange;
  final DiscoverySort sort;

  int get activeCount =>
      (genres.isEmpty ? 0 : 1) +
      (conditions.isEmpty ? 0 : 1) +
      (availableOnly ? 1 : 0) +
      (maxDistanceKm == null ? 0 : 1) +
      (valueRange == null ? 0 : 1) +
      (sort == DiscoverySort.title ? 0 : 1);

  DiscoveryFilter copyWith({
    Set<String>? genres,
    Set<String>? conditions,
    bool? availableOnly,
    Object? maxDistanceKm = _keep,
    Object? valueRange = _keep,
    DiscoverySort? sort,
  }) => DiscoveryFilter(
    genres: genres ?? this.genres,
    conditions: conditions ?? this.conditions,
    availableOnly: availableOnly ?? this.availableOnly,
    maxDistanceKm: identical(maxDistanceKm, _keep)
        ? this.maxDistanceKm
        : maxDistanceKm as double?,
    valueRange: identical(valueRange, _keep)
        ? this.valueRange
        : valueRange as ValueRange?,
    sort: sort ?? this.sort,
  );
}

/// The non-distance criteria; distance needs location data, so Discovery's
/// provider applies it separately.
bool bookPassesDiscoveryFilter(Book book, DiscoveryFilter filter) {
  if (!genreMatchesAny(book.genre, filter.genres)) return false;
  if (filter.conditions.isNotEmpty &&
      !filter.conditions.contains(book.condition)) {
    return false;
  }
  if (filter.availableOnly && book.status != BookStatus.available) {
    return false;
  }
  final range = filter.valueRange;
  if (range != null &&
      (book.estimatedValue < range.start || book.estimatedValue > range.end)) {
    return false;
  }
  return true;
}

/// Groups arrive title-sorted from [groupBooksByWork]. [distanceOf] gives a
/// listing's distance in km, or null when either side has no location —
/// those sort last under "nearest".
List<BookGroup> sortDiscoveryGroups(
  List<BookGroup> groups,
  DiscoverySort sort,
  double? Function(Book) distanceOf,
) {
  final sorted = [...groups];
  final order = {for (var i = 0; i < groups.length; i++) groups[i]: i};
  int byThenTitle(num x, num y, BookGroup a, BookGroup b) {
    final c = x.compareTo(y);
    return c != 0 ? c : order[a]!.compareTo(order[b]!);
  }

  switch (sort) {
    case DiscoverySort.title:
      break;
    case DiscoverySort.value:
      double lowest(BookGroup g) => g.listings
          .map((b) => b.estimatedValue)
          .reduce((a, b) => a < b ? a : b);
      sorted.sort((a, b) => byThenTitle(lowest(a), lowest(b), a, b));
    case DiscoverySort.nearest:
      double nearest(BookGroup g) {
        final distances = g.listings
            .map(distanceOf)
            .whereType<double>()
            .toList();
        return distances.isEmpty
            ? double.infinity
            : distances.reduce((a, b) => a < b ? a : b);
      }

      sorted.sort((a, b) => byThenTitle(nearest(a), nearest(b), a, b));
  }
  return sorted;
}

/// An inclusive range of estimated values. Plain Dart so the domain doesn't
/// depend on Flutter's RangeValues (the filter sheet converts at the edge).
class ValueRange {
  const ValueRange(this.start, this.end);
  final double start;
  final double end;

  @override
  bool operator ==(Object other) =>
      other is ValueRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}
