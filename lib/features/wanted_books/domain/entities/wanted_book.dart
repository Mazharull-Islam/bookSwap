/// Marks "argument not passed" in [copyWith], so null can be passed on purpose.
const Object _keep = Object();

class WantedBook {
  const WantedBook({
    required this.id,
    required this.userId,
    required this.title,
    this.author = '',
    this.coverUrl,
    this.workKey,
    required this.matchKey,
    required this.addedAtMs,
  });

  final String id;

  final String userId;

  final String title;

  final String author;

  final String? coverUrl;

  final String? workKey;

  /// Same format as discovery's `bookGroupKey` (workKey, or a normalized
  /// title|author fallback) — stored so it can be queried directly instead
  /// of recomputed, e.g. for the duplicate-entry check on add.
  final String matchKey;

  final int addedAtMs;

  WantedBook copyWith({
    String? id,
    String? userId,
    String? title,
    String? author,
    Object? coverUrl = _keep,
    Object? workKey = _keep,
    String? matchKey,
    int? addedAtMs,
  }) => WantedBook(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    author: author ?? this.author,
    coverUrl: identical(coverUrl, _keep) ? this.coverUrl : coverUrl as String?,
    workKey: identical(workKey, _keep) ? this.workKey : workKey as String?,
    matchKey: matchKey ?? this.matchKey,
    addedAtMs: addedAtMs ?? this.addedAtMs,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WantedBook &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          author == other.author &&
          coverUrl == other.coverUrl &&
          workKey == other.workKey &&
          matchKey == other.matchKey &&
          addedAtMs == other.addedAtMs;

  @override
  int get hashCode => Object.hashAll([
    WantedBook,
    id,
    userId,
    title,
    author,
    coverUrl,
    workKey,
    matchKey,
    addedAtMs,
  ]);

  @override
  String toString() => 'WantedBook(id: $id)';
}
