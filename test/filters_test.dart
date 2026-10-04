import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/features/books/domain/entities/book.dart';
import 'package:bookswap_login/features/books/domain/shelf_filter.dart';
import 'package:bookswap_login/features/discovery/domain/book_group.dart';
import 'package:bookswap_login/features/discovery/domain/discovery_filter.dart';
import 'package:bookswap_login/features/reading/domain/entities/reading_entry.dart';
import 'package:bookswap_login/features/reading/domain/reading_filter.dart';
import 'package:bookswap_login/shared/genre_filter.dart';

Book book(
  String title, {
  String owner = 'o1',
  String author = 'Someone',
  String genre = '',
  String condition = 'Good',
  double value = 100,
  BookStatus status = BookStatus.available,
  int updated = 0,
}) => Book(
  id: title,
  ownerId: owner,
  title: title,
  author: author,
  genre: genre,
  condition: condition,
  estimatedValue: value,
  status: status,
  updatedAtMs: updated,
);

ReadingEntry entry(
  String title, {
  ReadingStatus status = ReadingStatus.read,
  String genre = '',
  int? rating,
  String review = '',
  int updated = 0,
}) => ReadingEntry(
  id: title,
  userId: 'u',
  title: title,
  genre: genre,
  status: status,
  rating: rating,
  review: review,
  updatedAtMs: updated,
);

void main() {
  group('genreMatchesAny', () {
    test('empty selection matches everything', () {
      expect(genreMatchesAny('', {}), isTrue);
    });
    test('matches Open Library style subjects by keyword', () {
      expect(genreMatchesAny('Fantasy fiction, Magic', {'Fantasy'}), isTrue);
      expect(
        genreMatchesAny('Detective and mystery stories', {'Mystery'}),
        isTrue,
      );
      expect(genreMatchesAny('Science fiction', {'Science fiction'}), isTrue);
      expect(genreMatchesAny('Cooking', {'Romance', 'Thriller'}), isFalse);
    });
    test('any of several selected genres is enough', () {
      expect(genreMatchesAny('Romance', {'Horror', 'Romance'}), isTrue);
    });
  });

  group('applyShelfFilter', () {
    final shelf = [
      book('A', genre: 'Fantasy', condition: 'New', updated: 1),
      book(
        'B',
        genre: 'Thriller',
        condition: 'Fair',
        status: BookStatus.lent,
        updated: 3,
      ),
      book('C', genre: 'Fantasy', condition: 'Fair', updated: 2, value: 500),
    ];
    List<String> titles(ShelfFilter f) =>
        applyShelfFilter(shelf, f).map((b) => b.title).toList();

    test('default sorts by most recently updated', () {
      expect(titles(const ShelfFilter()), ['B', 'C', 'A']);
    });
    test('genre, condition and status combine', () {
      expect(titles(const ShelfFilter(genres: {'Fantasy'})), ['C', 'A']);
      expect(
        titles(const ShelfFilter(genres: {'Fantasy'}, conditions: {'Fair'})),
        ['C'],
      );
      expect(titles(const ShelfFilter(statuses: {BookStatus.lent})), ['B']);
    });
    test('value sort is highest first', () {
      expect(titles(const ShelfFilter(sort: ShelfSort.value)).first, 'C');
    });
  });

  group('discovery filter', () {
    test('availability, condition, genre and value range', () {
      final lent = book('L', status: BookStatus.lent);
      expect(
        bookPassesDiscoveryFilter(
          lent,
          const DiscoveryFilter(availableOnly: true),
        ),
        isFalse,
      );
      expect(
        bookPassesDiscoveryFilter(
          book('X', condition: 'Worn'),
          const DiscoveryFilter(conditions: {'New', 'Good'}),
        ),
        isFalse,
      );
      expect(
        bookPassesDiscoveryFilter(
          book('Y', value: 250),
          const DiscoveryFilter(valueRange: ValueRange(100, 200)),
        ),
        isFalse,
      );
      expect(
        bookPassesDiscoveryFilter(
          book('Z', genre: 'Crime fiction', value: 150),
          const DiscoveryFilter(
            genres: {'Crime'},
            valueRange: ValueRange(100, 200),
          ),
        ),
        isTrue,
      );
    });

    test('copyWith can clear nullable fields', () {
      final f = const DiscoveryFilter(
        maxDistanceKm: 5,
        valueRange: ValueRange(1, 2),
      ).copyWith(maxDistanceKm: null, valueRange: null);
      expect(f.maxDistanceKm, isNull);
      expect(f.valueRange, isNull);
    });

    test('nearest sort puts unknown distances last, keeping title order', () {
      final groups = groupBooksByWork([
        book('Apple', owner: 'far'),
        book('Banana', owner: 'unknown'),
        book('Cherry', owner: 'near'),
        book('Date', owner: 'unknown'),
      ]);
      final distances = {'far': 20.0, 'near': 2.0};
      final sorted = sortDiscoveryGroups(
        groups,
        DiscoverySort.nearest,
        (b) => distances[b.ownerId],
      );
      expect(sorted.map((g) => g.representative.title).toList(), [
        'Cherry',
        'Apple',
        'Banana',
        'Date',
      ]);
    });
  });

  group('applyReadingFilter', () {
    final entries = [
      entry('Dune', genre: 'Science fiction', rating: 5, updated: 1),
      entry('Emma', genre: 'Romance', rating: 3, review: 'Witty', updated: 2),
      entry('Todo', status: ReadingStatus.planToRead, updated: 3),
    ];
    List<String> titles(ReadingFilter f) =>
        applyReadingFilter(entries, f).map((e) => e.title).toList();

    test('query searches title, author and review text', () {
      expect(titles(const ReadingFilter(query: 'witty')), ['Emma']);
      expect(titles(const ReadingFilter(query: 'dun')), ['Dune']);
    });
    test('min rating only constrains the Read tab', () {
      expect(titles(const ReadingFilter(minRating: 4)), ['Todo', 'Dune']);
    });
    test('genre filter and rating sort', () {
      expect(titles(const ReadingFilter(genres: {'Romance'})), ['Emma']);
      expect(
        titles(const ReadingFilter(sort: ReadingSort.rating)).first,
        'Dune',
      );
    });
  });
}
