import '../entities/book_of_month_nomination.dart';
import '../entities/book_of_month_period.dart';
import '../entities/book_of_month_vote.dart';

class BookOfMonthValidationFailure implements Exception {
  const BookOfMonthValidationFailure(this.message);
  final String message;
}

abstract interface class BookOfMonthRepository {
  Stream<List<BookOfMonthNomination>> watchNominations(String periodId);
  Stream<List<BookOfMonthVote>> watchVotes(String periodId);
  Stream<BookOfMonthPeriod?> watchPeriod(String periodId);

  /// Most recent periods that have ever had a nomination, newest first.
  Stream<List<BookOfMonthPeriod>> watchKnownPeriods({int limit});

  /// No-op if this book is already nominated this period (matched the same
  /// way as everywhere else — workKey, or title+author).
  Future<void> nominate({
    required String periodId,
    required String nominatedBy,
    required String nominatedByName,
    required String title,
    required String author,
    String? coverUrl,
    String? workKey,
    String? genre,
  });

  /// Replaces any existing vote this user has in this period.
  Future<void> vote({
    required String periodId,
    required String userId,
    required String matchKey,
  });

  /// Sets the period's discussion thread — only succeeds if it isn't set
  /// yet (rules-enforced), so concurrent callers racing this are harmless.
  Future<void> setDiscussionThread(String periodId, String postId);
}
