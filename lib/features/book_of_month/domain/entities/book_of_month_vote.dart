class BookOfMonthVote {
  const BookOfMonthVote({
    required this.id,
    required this.periodId,
    required this.userId,
    required this.matchKey,
    required this.votedAtMs,
  });

  /// '${periodId}_${userId}' — one vote per user per period. Voting for
  /// a different nominee overwrites this same doc, so a user can never
  /// hold more than one active vote in a period.
  final String id;

  final String periodId;

  final String userId;

  final String matchKey;

  final int votedAtMs;

  BookOfMonthVote copyWith({
    String? id,
    String? periodId,
    String? userId,
    String? matchKey,
    int? votedAtMs,
  }) => BookOfMonthVote(
    id: id ?? this.id,
    periodId: periodId ?? this.periodId,
    userId: userId ?? this.userId,
    matchKey: matchKey ?? this.matchKey,
    votedAtMs: votedAtMs ?? this.votedAtMs,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookOfMonthVote &&
          id == other.id &&
          periodId == other.periodId &&
          userId == other.userId &&
          matchKey == other.matchKey &&
          votedAtMs == other.votedAtMs;

  @override
  int get hashCode => Object.hashAll([
    BookOfMonthVote,
    id,
    periodId,
    userId,
    matchKey,
    votedAtMs,
  ]);

  @override
  String toString() => 'BookOfMonthVote(id: $id)';
}
