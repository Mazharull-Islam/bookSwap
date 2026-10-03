import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/core/services/book_enrichment_service.dart';
import 'package:bookswap_login/core/services/google_books_service.dart' as gb;
import 'package:bookswap_login/core/services/open_library_service.dart' as ol;
import 'package:bookswap_login/core/utils/synopsis.dart';
import 'package:bookswap_login/shared/genre_normalizer.dart';
import 'support/fake_google_books.dart';

class _FakeOpenLibrary extends ol.OpenLibraryService {
  _FakeOpenLibrary({this.synopsis, this.fails = false}) : super(Dio());
  final String? synopsis;
  final bool fails;

  @override
  Future<String?> fetchSynopsis(ol.BookMetadata suggestion) async {
    if (fails) throw const ol.BookLookupFailure('offline');
    return synopsis;
  }
}

const _dune = ol.BookMetadata(
  title: 'Dune',
  author: 'Frank Herbert',
  genres: [
    'Science fiction',
    'Fiction',
    'Desert planets',
    'Accessible book',
    'Protected DAISY',
  ],
);

const _longGoogle =
    '<p>Set on the desert planet <b>Arrakis</b>, Dune is the story of the boy '
    'Paul Atreides, heir to a noble family tasked with ruling an inhospitable '
    'world where the only thing of value is the &quot;spice&quot; melange.</p>';

gb.BookMetadata _googleVolume({
  String title = 'Dune',
  String author = 'Frank Herbert',
  List<String> categories = const ['Fiction / Science Fiction / General'],
  String? synopsis = _longGoogle,
}) => gb.BookMetadata(
  title: title,
  author: author,
  genres: categories,
  synopsis: synopsis,
);

void main() {
  group('cleanSubjects', () {
    test('drops catalogue noise, years and duplicates', () {
      expect(
        cleanSubjects([
          'Science fiction',
          'science fiction',
          'Accessible book',
          'Protected DAISY',
          'New York Times bestseller',
          'Large type books',
          '1965',
          'Desert planets',
          '',
          'x' * 80,
        ]),
        ['Science fiction', 'Desert planets'],
      );
    });
  });

  group('standardGenres', () {
    test('reads real genres out of a noisy tag list', () {
      final genres = standardGenres(
        subjects: [
          'Science fiction',
          'Fiction',
          'Desert planets',
          'Accessible book',
          'Fantasy fiction',
        ],
        categories: ['Fiction / Science Fiction / General'],
      );
      expect(genres.first, 'Science fiction');
      expect(genres, isNot(contains('Accessible book')));
      expect(genres.length, lessThanOrEqualTo(3));
    });

    test('Google categories outweigh stray subject tags', () {
      final genres = standardGenres(
        subjects: ['Fantasy fiction'],
        categories: ['Fiction / Science Fiction / General'],
      );
      expect(genres.first, 'Science fiction');
    });

    test('nothing recognisable becomes Other', () {
      expect(standardGenres(subjects: ['Accessible book', 'Fiction']), [
        'Other',
      ]);
      expect(standardGenres(), ['Other']);
    });

    test('a blurb alone needs more than one signal word', () {
      expect(
        standardGenres(description: 'A fast-paced story with some action.'),
        ['Other'],
      );
      expect(
        standardGenres(
          description: 'A tense thriller of suspense and espionage.',
        ),
        ['Thriller'],
      );
    });

    test('keeps at most three, strongest first', () {
      final genres = standardGenres(
        subjects: [
          'Science fiction',
          'Science fiction adventure',
          'Adventure stories',
          'Fantasy',
          'Romance',
          'Thriller',
          'Humor',
        ],
      );
      expect(genres.length, 3);
    });

    test('standard names pass through unchanged', () {
      expect(
        standardGenres(subjects: ['Science fiction', 'Thriller']),
        containsAll(['Science fiction', 'Thriller']),
      );
    });

    test('matches word starts, not stray substrings', () {
      // "Romantic comedy" is two genres; "Poetry" must not come from "poet"
      // inside an unrelated word.
      expect(
        standardGenres(subjects: ['Romantic comedy']),
        containsAll(['Romance', 'Comedy']),
      );
      expect(standardGenres(subjects: ['Spaceship repair']), ['Other']);
    });
  });

  group('cleanSynopsis', () {
    test('strips HTML and decodes entities', () {
      final text = cleanSynopsis(_longGoogle)!;
      expect(text, isNot(contains('<')));
      expect(text, contains('"spice" melange'));
      expect(text, contains('Arrakis'));
    });

    test('too-short text is not a synopsis', () {
      expect(cleanSynopsis('Great book!'), isNull);
      expect(cleanSynopsis(null), isNull);
      expect(cleanSynopsis('<p></p>'), isNull);
    });

    test('long text is cut at a word with an ellipsis', () {
      final long = List.filled(400, 'word').join(' ');
      final cut = cleanSynopsis(long, maxLength: 100)!;
      expect(cut.length, lessThanOrEqualTo(101));
      expect(cut, endsWith('…'));
      expect(cut, isNot(contains('wor…')));
    });

    test('paragraphs and line breaks survive', () {
      expect(
        cleanSynopsis('<p>First paragraph here.</p><p>Second one here.</p>'),
        'First paragraph here.\n\nSecond one here.',
      );
    });
  });

  group('pickBestVolume', () {
    test('accepts the same book, tolerating subtitles and "The"', () {
      final volumes = [
        _googleVolume(title: 'Dune Messiah'),
        _googleVolume(title: 'Dune: Book One'),
      ];
      expect(
        gb
            .pickBestVolume(volumes, title: 'The Dune', author: 'Frank Herbert')
            ?.title,
        'Dune: Book One',
      );
    });

    test('rejects a different book or the wrong author', () {
      expect(
        gb.pickBestVolume(
          [_googleVolume(title: 'Dune Messiah')],
          title: 'Dune',
          author: 'Frank Herbert',
        ),
        isNull,
      );
      expect(
        gb.pickBestVolume(
          [_googleVolume(author: 'Someone Else')],
          title: 'Dune',
          author: 'Frank Herbert',
        ),
        isNull,
      );
    });

    test('a volume with no author listed still matches on title', () {
      expect(
        gb.pickBestVolume(
          [_googleVolume(author: '')],
          title: 'Dune',
          author: 'Frank Herbert',
        ),
        isNotNull,
      );
    });
  });

  group('BookEnrichmentService', () {
    BookEnrichmentService service({
      String? olSynopsis,
      bool olFails = false,
      gb.BookMetadata? match,
      bool googleFails = false,
    }) => BookEnrichmentService(
      openLibrary: _FakeOpenLibrary(synopsis: olSynopsis, fails: olFails),
      googleBooks: FakeGoogleBooks(match: match, fails: googleFails),
    );

    test('prefers the fuller Google synopsis and cleans it', () async {
      final details = await service(
        olSynopsis: 'A short Open Library line about a desert planet.',
        match: _googleVolume(),
      ).enrich(_dune);
      expect(details.synopsis, startsWith('Set on the desert planet Arrakis'));
      expect(details.synopsis, isNot(contains('<')));
      expect(details.genres.first, 'Science fiction');
    });

    test('falls back to Open Library when Google has only a teaser', () async {
      const olText =
          'Open Library description that is comfortably longer than the '
          'little Google teaser line.';
      final details = await service(
        olSynopsis: olText,
        match: _googleVolume(synopsis: 'A classic novel.'),
      ).enrich(_dune);
      expect(details.synopsis, olText);
    });

    test(
      'Google failing still yields clean genres and the OL synopsis',
      () async {
        const olText = 'A long enough description of the desert planet story.';
        final details = await service(
          olSynopsis: olText,
          googleFails: true,
        ).enrich(_dune);
        expect(details.synopsis, olText);
        expect(details.genres.first, 'Science fiction');
      },
    );

    test('both sources failing never throws', () async {
      final details = await service(
        olFails: true,
        googleFails: true,
      ).enrich(_dune);
      expect(details.synopsis, isNull);
      expect(details.genres.first, 'Science fiction');
    });

    test('genres combine tags, categories and the description', () async {
      final details =
          await service(
            match: _googleVolume(
              categories: ['Fiction / Thrillers / Suspense'],
            ),
          ).enrich(
            const ol.BookMetadata(
              title: 'Dune',
              author: 'Frank Herbert',
              genres: ['Accessible book'],
            ),
          );
      expect(details.genres, contains('Thriller'));
    });
  });
}
