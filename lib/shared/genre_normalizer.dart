import 'genre_filter.dart';

/// Tags that describe a catalogue record rather than the book itself.
const _junkFragments = [
  'accessible book',
  'protected daisy',
  'large type',
  'large print',
  'open library',
  'new york times',
  'bestseller',
  'best seller',
  'reading level',
  'in library',
  'internet archive',
  'lending library',
  'staff picks',
  'print disabled',
  'translations into',
  'english language',
  'textbooks',
  'juvenile literature',
  'long now',
];

/// Open Library subject tags minus the catalogue noise ("Accessible book",
/// "Protected DAISY", "New York Times bestseller", …), de-duplicated.
List<String> cleanSubjects(Iterable<String> subjects) {
  final seen = <String>{};
  final result = <String>[];
  for (final raw in subjects) {
    final tag = raw.trim();
    final lower = tag.toLowerCase();
    if (tag.isEmpty || tag.length > 60) continue;
    if (RegExp(r'^[\d\s\-–.,]+$').hasMatch(tag)) continue;
    if (_junkFragments.any(lower.contains)) continue;
    if (seen.add(lower)) result.add(tag);
  }
  return result;
}

bool _hasStem(String text, String stem) =>
    RegExp(r'\b' + RegExp.escape(stem)).hasMatch(text);

/// What a book gets when no standard genre could be read from its data.
const unknownGenre = 'Other';

/// Up to [max] of [filterGenres] that best describe a book.
///
/// Evidence, strongest first:
///  - [categories] (Google Books, e.g. "Fiction / Science Fiction / General"):
///    3 points per matching segment.
///  - [subjects] (Open Library tags): 2 points per matching tag.
///  - [description] text: 1 point per keyword found, at most 2 per genre —
///    weak on purpose, since blurbs use words like "action" loosely.
///
/// A genre needs at least 2 points, so a lone word in a blurb never decides
/// anything, but a single real subject tag does. Returns [unknownGenre] when
/// nothing qualifies, so a book always has something to store.
List<String> standardGenres({
  Iterable<String> subjects = const [],
  Iterable<String> categories = const [],
  String? description,
  int max = 3,
}) {
  final tags = cleanSubjects(subjects).map((s) => s.toLowerCase()).toList();
  final segments = categories
      .expand((c) => c.split('/'))
      .map((s) => s.trim().toLowerCase())
      .where((s) => s.isNotEmpty)
      .toList();
  final blurb = (description ?? '').toLowerCase();

  final scores = <String, int>{};
  for (final genre in filterGenres) {
    final stems = genreKeywords[genre] ?? const <String>[];
    bool hit(String text) => stems.any((stem) => _hasStem(text, stem));
    final fromCategories = segments.where(hit).length.clamp(0, 2) * 3;
    final fromSubjects = tags.where(hit).length.clamp(0, 3) * 2;
    final fromBlurb = blurb.isEmpty
        ? 0
        : stems.where((stem) => _hasStem(blurb, stem)).length.clamp(0, 2);
    final score = fromCategories + fromSubjects + fromBlurb;
    if (score >= 2) scores[genre] = score;
  }
  final ranked = scores.keys.toList()
    ..sort((a, b) {
      final byScore = scores[b]!.compareTo(scores[a]!);
      return byScore != 0
          ? byScore
          : filterGenres.indexOf(a).compareTo(filterGenres.indexOf(b));
    });
  return ranked.isEmpty ? const [unknownGenre] : ranked.take(max).toList();
}
