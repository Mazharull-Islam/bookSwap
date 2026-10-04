/// Marks "argument not passed" in [copyWith], so null can be passed on purpose.
const Object _keep = Object();

class BookOfMonthNomination {
  const BookOfMonthNomination({
    required this.id,
    required this.periodId,
    required this.matchKey,
    required this.title,
    this.author = '',
    this.coverUrl,
    this.workKey,
    this.genre,
    required this.nominatedBy,
    required this.nominatedByName,
    required this.nominatedAtMs,
  });

  /// '${periodId}_${matchKey}' — deterministic so nominating the same
  /// book twice in the same period is a no-op (checked client-side)
  /// rather than a duplicate competing entry that splits votes.
  final String id;

  final String periodId;

  final String matchKey;

  final String title;

  final String author;

  final String? coverUrl;

  final String? workKey;

  final String? genre;

  final String nominatedBy;

  final String nominatedByName;

  final int nominatedAtMs;

  BookOfMonthNomination copyWith({
    String? id,
    String? periodId,
    String? matchKey,
    String? title,
    String? author,
    Object? coverUrl = _keep,
    Object? workKey = _keep,
    Object? genre = _keep,
    String? nominatedBy,
    String? nominatedByName,
    int? nominatedAtMs,
  }) => BookOfMonthNomination(
    id: id ?? this.id,
    periodId: periodId ?? this.periodId,
    matchKey: matchKey ?? this.matchKey,
    title: title ?? this.title,
    author: author ?? this.author,
    coverUrl: identical(coverUrl, _keep) ? this.coverUrl : coverUrl as String?,
    workKey: identical(workKey, _keep) ? this.workKey : workKey as String?,
    genre: identical(genre, _keep) ? this.genre : genre as String?,
    nominatedBy: nominatedBy ?? this.nominatedBy,
    nominatedByName: nominatedByName ?? this.nominatedByName,
    nominatedAtMs: nominatedAtMs ?? this.nominatedAtMs,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookOfMonthNomination &&
          id == other.id &&
          periodId == other.periodId &&
          matchKey == other.matchKey &&
          title == other.title &&
          author == other.author &&
          coverUrl == other.coverUrl &&
          workKey == other.workKey &&
          genre == other.genre &&
          nominatedBy == other.nominatedBy &&
          nominatedByName == other.nominatedByName &&
          nominatedAtMs == other.nominatedAtMs;

  @override
  int get hashCode => Object.hashAll([
    BookOfMonthNomination,
    id,
    periodId,
    matchKey,
    title,
    author,
    coverUrl,
    workKey,
    genre,
    nominatedBy,
    nominatedByName,
    nominatedAtMs,
  ]);

  @override
  String toString() => 'BookOfMonthNomination(id: $id)';
}
