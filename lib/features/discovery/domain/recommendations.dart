import '../../../shared/genre_filter.dart';
import '../../books/domain/entities/book.dart';
import '../../reading/domain/entities/reading_entry.dart';
import '../../reviews/domain/rating_summary.dart';
import 'book_group.dart';
import '../../../shared/domain/match_key.dart';

/// Where a recommendation's score came from, strongest story first.
enum RecommendationSignal { wishlist, taste, rating, preference, nearby }

class Recommendation {
  const Recommendation({
    required this.group,
    required this.score,
    required this.signal,
    required this.reason,
  });

  final BookGroup group;
  final double score;
  final RecommendationSignal signal;

  /// One honest line saying why this is here.
  final String reason;
}

/// Wishlisted books beat everything: the member asked for that exact book.
const wishlistWeight = 10.0;

/// The most a member's reading history can add (and the most it can take
/// away) for one book, however many of its genres they've read.
const maxTasteBonus = 6.0;
const maxTastePenalty = 2.0;

/// Reading history outranks the genres ticked at registration.
const preferenceWeight = 1.5;

/// How many reviews before a community rating is trusted at all.
const minReviewsForRating = 2;

/// A book needs at least this to be shown: one finished book in its genre is
/// enough (1.33), a plan-to-read or half-read one on its own is not.
const minRecommendationScore = 1.0;

/// Genres too broad to say anything about taste.
const _genericTags = {'fiction', 'other'};

String _titleCase(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

/// The genre labels a piece of genre text stands for: each comma-separated
/// token, plus every standard genre whose keywords it contains ("Dystopian
/// fiction" → science fiction). Lower-case, so tags from a book, a reading
/// entry and a registration preference can be compared directly.
Set<String> genreTags(String text) {
  final tags = <String>{};
  for (final raw in text.split(RegExp(r'[,;/]'))) {
    final token = raw.trim().toLowerCase();
    if (token.isNotEmpty) tags.add(token);
  }
  for (final genre in filterGenres) {
    if (genreMatchesAny(text, {genre})) tags.add(genre.toLowerCase());
  }
  return tags;
}

/// How much each genre has meant to this member, from what they read and how
/// they rated it. Positive means they like it; negative means they didn't.
Map<String, double> tasteProfile(Iterable<ReadingEntry> reading) {
  final taste = <String, double>{};
  for (final entry in reading) {
    final rating = entry.rating;
    final double weight;
    if (rating != null && rating <= 2) {
      weight = -1; // read it and didn't like it
    } else {
      final base = switch (entry.status) {
        ReadingStatus.read => 1.0,
        ReadingStatus.reading => 0.7,
        ReadingStatus.planToRead => 0.3,
      };
      weight = base * (rating != null && rating >= 4 ? 2 : 1);
    }
    for (final tag in genreTags(entry.genre)) {
      if (_genericTags.contains(tag)) continue;
      taste[tag] = (taste[tag] ?? 0) + weight;
    }
  }
  return taste;
}

/// 3 units of liking saturate a genre; dislike counts for at most half that.
double _tagValue(double raw) => 4 * (raw / 3).clamp(-0.5, 1.0);

double _distanceBonus(double? km, double? maxKm) {
  if (km == null) return 0;
  if (maxKm != null && km > maxKm) return -1;
  if (km <= 5) return 1.5;
  if (km <= 20) return 1.0;
  if (km <= 50) return 0.5;
  return 0;
}

/// Ranks other members' available books for one member. Pure: the same inputs
/// always give the same list, and nothing leaves the device.
///
/// A book needs at least one interest signal (wishlist, reading history or a
/// registration preference) to be considered at all, so a member with nothing
/// to go on gets no recommendations rather than arbitrary ones.
List<Recommendation> recommendBooks({
  required List<Book> books,
  required String myId,
  required Set<String> blockedOwnerIds,
  required Set<String> ownedKeys,
  required List<ReadingEntry> reading,
  required Set<String> wantedKeys,
  required List<String> preferences,
  required Map<String, RatingSummary> ratings,
  required double? Function(Book) distanceKm,
  required double? maxDistanceKm,
  Set<String> dismissedKeys = const {},
  int limit = 8,
  int perGenre = 3,
}) {
  final readKeys = {
    for (final e in reading)
      workMatchKey(workKey: e.workKey, title: e.title, author: e.author),
  };
  final taste = tasteProfile(reading);
  final preferenceTags = {for (final p in preferences) ...genreTags(p)};

  final candidates = books.where(
    (b) =>
        b.ownerId != myId &&
        !blockedOwnerIds.contains(b.ownerId) &&
        b.status == BookStatus.available,
  );

  final scored = <Recommendation>[];
  for (final group in groupBooksByWork(candidates)) {
    final key = group.key;
    if (ownedKeys.contains(key) ||
        readKeys.contains(key) ||
        dismissedKeys.contains(key)) {
      continue;
    }
    final tags = genreTags(group.representative.genre);

    final wished = wantedKeys.contains(key);
    var tasteScore = 0.0;
    String? tasteTag;
    var tasteBest = 0.0;
    for (final tag in tags) {
      final raw = taste[tag];
      if (raw == null) continue;
      final value = _tagValue(raw);
      tasteScore += value;
      if (value > tasteBest) {
        tasteBest = value;
        tasteTag = tag;
      }
    }
    tasteScore = tasteScore.clamp(-maxTastePenalty, maxTasteBonus);
    final prefers = tags.any(preferenceTags.contains);
    final interested = wished || tasteScore > 0 || prefers;
    if (!interested) continue;

    final summary = ratings[key];
    final ratingScore = summary != null && summary.count >= minReviewsForRating
        ? (summary.average - 3).clamp(0.0, 2.0)
        : 0.0;
    final nearest = group.listings
        .map(distanceKm)
        .whereType<double>()
        .fold<double?>(null, (m, d) => m == null || d < m ? d : m);
    final nearbyScore = _distanceBonus(nearest, maxDistanceKm);

    final score =
        (wished ? wishlistWeight : 0) +
        tasteScore +
        (prefers ? preferenceWeight : 0) +
        ratingScore +
        nearbyScore;
    if (score < minRecommendationScore) continue;

    // The reason is the biggest contributor, so the line is always true.
    final contributions = <RecommendationSignal, double>{
      if (wished) RecommendationSignal.wishlist: wishlistWeight,
      if (tasteScore > 0) RecommendationSignal.taste: tasteScore,
      if (ratingScore > 0) RecommendationSignal.rating: ratingScore,
      if (prefers) RecommendationSignal.preference: preferenceWeight,
      if (nearbyScore > 0) RecommendationSignal.nearby: nearbyScore,
    };
    final signal = contributions.entries
        .reduce((a, b) => b.value > a.value ? b : a)
        .key;
    final reason = switch (signal) {
      RecommendationSignal.wishlist => 'On your wishlist',
      RecommendationSignal.taste =>
        'Matches your ${_titleCase(tasteTag ?? 'reading')} reading',
      RecommendationSignal.rating =>
        'Highly rated · ${summary!.averageLabel} from ${summary.count} '
            '${summary.count == 1 ? 'review' : 'reviews'}',
      RecommendationSignal.preference => 'One of your favourite genres',
      RecommendationSignal.nearby => 'Close to you',
    };
    scored.add(
      Recommendation(
        group: group,
        score: score,
        signal: signal,
        reason: reason,
      ),
    );
  }

  scored.sort((a, b) {
    final byScore = b.score.compareTo(a.score);
    if (byScore != 0) return byScore;
    final byTitle = a.group.representative.title.toLowerCase().compareTo(
      b.group.representative.title.toLowerCase(),
    );
    return byTitle != 0 ? byTitle : a.group.key.compareTo(b.group.key);
  });

  // Keep one genre from filling the strip.
  final perGenreCount = <String, int>{};
  final result = <Recommendation>[];
  for (final r in scored) {
    final primary = _primaryTag(r.group.representative.genre);
    final used = perGenreCount[primary] ?? 0;
    if (used >= perGenre) continue;
    perGenreCount[primary] = used + 1;
    result.add(r);
    if (result.length == limit) break;
  }
  return result;
}

String _primaryTag(String genre) {
  for (final raw in genre.split(RegExp(r'[,;/]'))) {
    final token = raw.trim().toLowerCase();
    if (token.isNotEmpty && !_genericTags.contains(token)) return token;
  }
  return 'other';
}
