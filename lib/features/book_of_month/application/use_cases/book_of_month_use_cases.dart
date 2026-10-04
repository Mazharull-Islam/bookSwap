import '../../../forum/domain/entities/forum_post.dart';
import '../../../forum/domain/repositories/forum_repository.dart';
import '../../domain/entities/book_of_month_period.dart';
import '../../../../shared/domain/period.dart';
import '../../domain/repositories/book_of_month_repository.dart';

class NominateBook {
  const NominateBook(this.repository);
  final BookOfMonthRepository repository;

  Future<void> call({
    required String periodId,
    required String nominatedBy,
    required String nominatedByName,
    required String title,
    required String author,
    String? coverUrl,
    String? workKey,
    String? genre,
  }) => repository.nominate(
    periodId: periodId,
    nominatedBy: nominatedBy,
    nominatedByName: nominatedByName,
    title: title,
    author: author,
    coverUrl: coverUrl,
    workKey: workKey,
    genre: genre,
  );
}

class VoteForBook {
  const VoteForBook(this.repository);
  final BookOfMonthRepository repository;

  Future<void> call({
    required String periodId,
    required String userId,
    required String matchKey,
  }) => repository.vote(periodId: periodId, userId: userId, matchKey: matchKey);
}

class EnsureDiscussionThread {
  const EnsureDiscussionThread(this._bookOfMonth, this._forum);
  final BookOfMonthRepository _bookOfMonth;
  final ForumRepository _forum;

  Future<void> call({
    required BookOfMonthPeriod period,
    required bool hasNominations,
    required String authorId,
    required String authorName,
  }) async {
    if (!hasNominations || period.discussionPostId != null) return;
    final ForumPost post = await _forum.createPost(
      authorId: authorId,
      authorName: authorName,
      title: 'Book of the Month discussion — ${periodLabel(period.id)}',
      body:
          "This month's Book of the Month nominations are open — reply here "
          'to discuss the nominees or make your case for your pick.',
    );
    await _bookOfMonth.setDiscussionThread(period.id, post.id);
  }
}
