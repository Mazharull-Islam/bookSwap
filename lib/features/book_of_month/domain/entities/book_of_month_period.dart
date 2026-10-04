/// Marks "argument not passed" in [copyWith], so null can be passed on purpose.
const Object _keep = Object();

/// A lightweight index doc — one per period that has ever had a nomination
/// — so the archive can list past periods without Firestore's lack of a
/// "distinct" query. Also carries the period's single Forum discussion
/// thread, created lazily on the period's first nomination.
class BookOfMonthPeriod {
  const BookOfMonthPeriod({required this.id, this.discussionPostId});

  final String id;

  final String? discussionPostId;

  BookOfMonthPeriod copyWith({String? id, Object? discussionPostId = _keep}) =>
      BookOfMonthPeriod(
        id: id ?? this.id,
        discussionPostId: identical(discussionPostId, _keep)
            ? this.discussionPostId
            : discussionPostId as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookOfMonthPeriod &&
          id == other.id &&
          discussionPostId == other.discussionPostId;

  @override
  int get hashCode => Object.hashAll([BookOfMonthPeriod, id, discussionPostId]);

  @override
  String toString() => 'BookOfMonthPeriod(id: $id)';
}
