/// Marks "argument not passed" in [copyWith], so null can be passed on purpose.
const Object _keep = Object();

/// One "I marked a book Read" event, pushed live so the leaderboard can
/// aggregate across members. Deliberately minimal — no book title, rating,
/// or review — the leaderboard only ever needs a reader's name, the book's
/// author/genre, and which period it happened in.
class ReadingActivity {
  const ReadingActivity({
    required this.id,
    required this.userId,
    required this.userName,
    this.author = '',
    this.genre,
    required this.periodId,
    required this.markedReadAtMs,
  });

  final String id;

  final String userId;

  final String userName;

  final String author;

  final String? genre;

  final String periodId;

  final int markedReadAtMs;

  ReadingActivity copyWith({
    String? id,
    String? userId,
    String? userName,
    String? author,
    Object? genre = _keep,
    String? periodId,
    int? markedReadAtMs,
  }) => ReadingActivity(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    author: author ?? this.author,
    genre: identical(genre, _keep) ? this.genre : genre as String?,
    periodId: periodId ?? this.periodId,
    markedReadAtMs: markedReadAtMs ?? this.markedReadAtMs,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingActivity &&
          id == other.id &&
          userId == other.userId &&
          userName == other.userName &&
          author == other.author &&
          genre == other.genre &&
          periodId == other.periodId &&
          markedReadAtMs == other.markedReadAtMs;

  @override
  int get hashCode => Object.hashAll([
    ReadingActivity,
    id,
    userId,
    userName,
    author,
    genre,
    periodId,
    markedReadAtMs,
  ]);

  @override
  String toString() => 'ReadingActivity(id: $id)';
}
