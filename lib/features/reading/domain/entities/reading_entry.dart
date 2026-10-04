/// Marks "argument not passed" in [copyWith], so null can be passed on purpose.
const Object _keep = Object();

enum ReadingStatus { planToRead, reading, read }

class ReadingEntry {
  const ReadingEntry({
    required this.id,
    required this.userId,
    required this.title,
    this.author = '',
    this.genre = '',
    this.publishedYear,
    this.description = '',
    this.coverUrl,
    this.workKey,
    this.status = ReadingStatus.planToRead,
    this.rating,
    this.review = '',
    required this.updatedAtMs,
    this.deletedAtMs,
  });

  final String id;

  final String userId;

  final String title;

  final String author;

  /// Comma-joined, same convention as [Book.genre] — feeds the "genres
  /// explored" stat. Populated from search metadata at add time.
  final String genre;

  final String? publishedYear;

  /// Synopsis, fetched from Open Library the same way `AddBookPage` does.
  /// Best-effort: added asynchronously after the entry itself, so it may
  /// briefly be empty right after adding.
  final String description;

  final String? coverUrl;

  final String? workKey;

  final ReadingStatus status;

  /// 1-5. Only meaningful once [status] is [ReadingStatus.read] — the UI
  /// clears it if the status is changed away from Read.
  final int? rating;

  final String review;

  final int updatedAtMs;

  /// Set when the member removes the entry. Kept rather than deleted so the
  /// removal syncs to the member's other devices; every reader ignores
  /// entries with this set, and old ones are purged locally after a while.
  final int? deletedAtMs;

  ReadingEntry copyWith({
    String? id,
    String? userId,
    String? title,
    String? author,
    String? genre,
    Object? publishedYear = _keep,
    String? description,
    Object? coverUrl = _keep,
    Object? workKey = _keep,
    ReadingStatus? status,
    Object? rating = _keep,
    String? review,
    int? updatedAtMs,
    Object? deletedAtMs = _keep,
  }) => ReadingEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    author: author ?? this.author,
    genre: genre ?? this.genre,
    publishedYear: identical(publishedYear, _keep)
        ? this.publishedYear
        : publishedYear as String?,
    description: description ?? this.description,
    coverUrl: identical(coverUrl, _keep) ? this.coverUrl : coverUrl as String?,
    workKey: identical(workKey, _keep) ? this.workKey : workKey as String?,
    status: status ?? this.status,
    rating: identical(rating, _keep) ? this.rating : rating as int?,
    review: review ?? this.review,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    deletedAtMs: identical(deletedAtMs, _keep)
        ? this.deletedAtMs
        : deletedAtMs as int?,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingEntry &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          author == other.author &&
          genre == other.genre &&
          publishedYear == other.publishedYear &&
          description == other.description &&
          coverUrl == other.coverUrl &&
          workKey == other.workKey &&
          status == other.status &&
          rating == other.rating &&
          review == other.review &&
          updatedAtMs == other.updatedAtMs &&
          deletedAtMs == other.deletedAtMs;

  @override
  int get hashCode => Object.hashAll([
    ReadingEntry,
    id,
    userId,
    title,
    author,
    genre,
    publishedYear,
    description,
    coverUrl,
    workKey,
    status,
    rating,
    review,
    updatedAtMs,
    deletedAtMs,
  ]);

  @override
  String toString() => 'ReadingEntry(id: $id)';
}

/// Same key as discovery's `bookGroupKey` (copied rather than imported across
/// features).
String readingMatchKey({
  required String? workKey,
  required String title,
  required String author,
}) {
  if (workKey != null && workKey.isNotEmpty) return workKey;
  return '${title.trim().toLowerCase()}|${author.trim().toLowerCase()}';
}
