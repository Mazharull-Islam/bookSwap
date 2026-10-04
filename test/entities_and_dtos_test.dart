import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/core/services/public_profile_service.dart';
import 'package:bookswap_login/features/authentication/data/models/reader_profile_dto.dart';
import 'package:bookswap_login/features/blocking/data/models/blocked_user_dto.dart';
import 'package:bookswap_login/features/blocking/domain/entities/blocked_user.dart';
import 'package:bookswap_login/features/book_of_month/data/models/book_of_month_nomination_dto.dart';
import 'package:bookswap_login/features/book_of_month/data/models/book_of_month_period_dto.dart';
import 'package:bookswap_login/features/book_of_month/data/models/book_of_month_vote_dto.dart';
import 'package:bookswap_login/features/book_of_month/domain/entities/book_of_month_nomination.dart';
import 'package:bookswap_login/features/book_of_month/domain/entities/book_of_month_period.dart';
import 'package:bookswap_login/features/book_of_month/domain/entities/book_of_month_vote.dart';
import 'package:bookswap_login/features/books/data/models/book_dto.dart';
import 'package:bookswap_login/features/books/domain/entities/book.dart';
import 'package:bookswap_login/features/borrow_requests/data/models/borrow_request_dto.dart';
import 'package:bookswap_login/features/borrow_requests/domain/entities/borrow_request.dart';
import 'package:bookswap_login/features/forum/data/models/forum_post_dto.dart';
import 'package:bookswap_login/features/forum/data/models/forum_reply_dto.dart';
import 'package:bookswap_login/features/forum/data/models/forum_report_dto.dart';
import 'package:bookswap_login/features/forum/domain/entities/forum_post.dart';
import 'package:bookswap_login/features/forum/domain/entities/forum_reply.dart';
import 'package:bookswap_login/features/forum/domain/entities/forum_report.dart';
import 'package:bookswap_login/features/leaderboard/data/models/reading_activity_dto.dart';
import 'package:bookswap_login/features/leaderboard/domain/entities/reading_activity.dart';
import 'package:bookswap_login/features/reading/data/models/reading_entry_dto.dart';
import 'package:bookswap_login/features/reading/data/models/reading_goal_dto.dart';
import 'package:bookswap_login/features/reading/domain/entities/reading_entry.dart';
import 'package:bookswap_login/features/reading/domain/entities/reading_goal.dart';
import 'package:bookswap_login/features/reviews/data/models/book_review_dto.dart';
import 'package:bookswap_login/features/reviews/domain/entities/book_review.dart';
import 'package:bookswap_login/features/wanted_books/data/models/wanted_book_dto.dart';
import 'package:bookswap_login/features/wanted_books/domain/entities/wanted_book.dart';

/// Every entity must survive a trip through its DTO unchanged, and be stored
/// under exactly the field names the Firestore rules and existing data expect.
void roundTrip<T>(
  String label,
  T entity,
  T Function(Map<String, dynamic>) parse,
  Map<String, dynamic> Function(T) toJson,
  Set<String> storedKeys,
) {
  test('$label round-trips with the stored field names', () {
    final json = toJson(entity);
    expect(json.keys.toSet(), storedKeys);
    // Real storage holds JSON, so push it through an actual encode/decode.
    final stored = jsonDecode(jsonEncode(json)) as Map<String, dynamic>;
    expect(parse(stored), entity);
  });
}

void main() {
  group('storage format (unchanged by the entity/DTO split)', () {
    roundTrip(
      'Book',
      const Book(
        id: 'b1',
        ownerId: 'u1',
        title: 'Dune',
        author: 'Frank Herbert',
        genre: 'Science fiction',
        condition: 'Good',
        estimatedValue: 250.5,
        description: 'Sand.',
        coverPhotoUrl: 'https://x/c.jpg',
        isbn: '9780441013593',
        workKey: '/works/OL1W',
        status: BookStatus.lent,
        updatedAtMs: 7,
      ),
      BookDto.parse,
      (b) => b.toJson(),
      {
        'id', 'ownerId', 'title', 'author', 'genre', 'condition',
        'estimatedValue', 'description', 'coverPhotoUrl', 'isbn', 'workKey',
        'status', 'updatedAtMs', //
      },
    );
    roundTrip(
      'BorrowRequest',
      const BorrowRequest(
        id: 'r1',
        bookId: 'b1',
        bookTitle: 'Dune',
        bookCoverUrl: 'c',
        borrowerId: 'u2',
        lenderId: 'u1',
        status: RequestStatus.accepted,
        requestedAt: 1,
        respondedAt: 2,
        expectedReturnDateMs: 3,
        borrowerContact: 'a',
        lenderContact: 'b',
        returnedAt: 4,
        proposedReturnDateMs: 5,
        conditionOut: 'Good',
        conditionIn: 'Fair',
        borrowerNote: 'wet',
      ),
      BorrowRequestDto.parse,
      (r) => r.toJson(),
      {
        'id',
        'bookId',
        'bookTitle',
        'bookCoverUrl',
        'borrowerId',
        'lenderId',
        'status',
        'requestedAt',
        'respondedAt',
        'expectedReturnDateMs',
        'borrowerContact',
        'lenderContact',
        'returnedAt',
        'proposedReturnDateMs',
        'conditionOut',
        'conditionIn',
        'borrowerNote',
      },
    );
    roundTrip(
      'ForumPost',
      const ForumPost(
        id: 'p1',
        authorId: 'u1',
        authorName: 'Rafi',
        title: 'T',
        body: 'B',
        genre: 'Fantasy',
        createdAtMs: 1,
        likedBy: ['a', 'b'],
        reportedBy: ['c'],
        replyCount: 2,
      ),
      ForumPostDto.parse,
      (p) => p.toJson(),
      {
        'id',
        'authorId',
        'authorName',
        'title',
        'body',
        'genre',
        'createdAtMs',
        'likedBy',
        'reportedBy',
        'replyCount',
      },
    );
    roundTrip(
      'ForumReply',
      const ForumReply(
        id: 'r1',
        postId: 'p1',
        authorId: 'u1',
        authorName: 'Nadia',
        body: 'B',
        createdAtMs: 1,
        likedBy: ['a'],
        reportedBy: ['b', 'c'],
      ),
      ForumReplyDto.parse,
      (r) => r.toJson(),
      {
        'id',
        'postId',
        'authorId',
        'authorName',
        'body',
        'createdAtMs',
        'likedBy',
        'reportedBy',
      },
    );
    roundTrip(
      'ForumReport (post)',
      const ForumReport(
        id: 'p1_u2',
        postId: 'p1',
        reporterId: 'u2',
        reason: 'spam',
        createdAtMs: 9,
      ),
      ForumReportDto.parse,
      (r) => r.toJson(),
      {
        'id',
        'postId',
        'replyId',
        'targetKey',
        'reporterId',
        'reason',
        'createdAtMs',
      },
    );
    roundTrip(
      'ForumReport (reply)',
      const ForumReport(
        id: 'p1_r1_u2',
        postId: 'p1',
        replyId: 'r1',
        reporterId: 'u2',
        reason: 'abuse',
        createdAtMs: 9,
      ),
      ForumReportDto.parse,
      (r) => r.toJson(),
      {
        'id',
        'postId',
        'replyId',
        'targetKey',
        'reporterId',
        'reason',
        'createdAtMs',
      },
    );
    roundTrip(
      'ReadingEntry',
      const ReadingEntry(
        id: 'e1',
        userId: 'u1',
        title: 'Dune',
        author: 'FH',
        genre: 'Science fiction',
        publishedYear: '1965',
        description: 'd',
        coverUrl: 'c',
        workKey: 'w',
        status: ReadingStatus.read,
        rating: 5,
        review: 'great',
        updatedAtMs: 3,
        deletedAtMs: 4,
      ),
      ReadingEntryDto.parse,
      (e) => e.toJson(),
      {
        'id',
        'userId',
        'title',
        'author',
        'genre',
        'publishedYear',
        'description',
        'coverUrl',
        'workKey',
        'status',
        'rating',
        'review',
        'updatedAtMs',
        'deletedAtMs',
      },
    );
    roundTrip(
      'ReadingGoal',
      const ReadingGoal(
        userId: 'u1',
        targetCount: 12,
        startedAtMs: 1,
        periodDays: 365,
        updatedAtMs: 2,
        deletedAtMs: 3,
      ),
      ReadingGoalDto.parse,
      (g) => g.toJson(),
      {
        'userId',
        'targetCount',
        'startedAtMs',
        'periodDays',
        'updatedAtMs',
        'deletedAtMs',
      },
    );
    roundTrip(
      'ReadingActivity',
      const ReadingActivity(
        id: 'a1',
        userId: 'u1',
        userName: 'Rafi',
        author: 'FH',
        genre: 'Fantasy',
        periodId: '2026-10',
        markedReadAtMs: 5,
      ),
      ReadingActivityDto.parse,
      (a) => a.toJson(),
      {
        'id',
        'userId',
        'userName',
        'author',
        'genre',
        'periodId',
        'markedReadAtMs',
      },
    );
    roundTrip(
      'BookReview',
      const BookReview(
        id: 'r1',
        requestId: 'r1',
        reviewerId: 'u1',
        reviewerName: 'Rafi',
        bookId: 'b1',
        bookTitle: 'Dune',
        matchKey: 'dune|fh',
        rating: 4,
        text: 'ok',
        createdAtMs: 1,
        updatedAtMs: 2,
      ),
      BookReviewDto.parse,
      (r) => r.toJson(),
      {
        'id',
        'requestId',
        'reviewerId',
        'reviewerName',
        'bookId',
        'bookTitle',
        'matchKey',
        'rating',
        'text',
        'createdAtMs',
        'updatedAtMs',
      },
    );
    roundTrip(
      'WantedBook',
      const WantedBook(
        id: 'w1',
        userId: 'u1',
        title: 'Emma',
        author: 'JA',
        coverUrl: 'c',
        workKey: 'w',
        matchKey: 'emma|ja',
        addedAtMs: 1,
      ),
      WantedBookDto.parse,
      (w) => w.toJson(),
      {
        'id',
        'userId',
        'title',
        'author',
        'coverUrl',
        'workKey',
        'matchKey',
        'addedAtMs',
      },
    );
    roundTrip(
      'BlockedUser',
      const BlockedUser(
        id: 'u1_u2',
        blockerId: 'u1',
        blockedId: 'u2',
        blockedName: 'Sam',
        createdAtMs: 1,
      ),
      BlockedUserDto.parse,
      (b) => b.toJson(),
      {'id', 'blockerId', 'blockedId', 'blockedName', 'createdAtMs'},
    );
    roundTrip(
      'BookOfMonthNomination',
      const BookOfMonthNomination(
        id: 'p_k',
        periodId: 'p',
        matchKey: 'k',
        title: 'Dune',
        author: 'FH',
        coverUrl: 'c',
        workKey: 'w',
        genre: 'Fantasy',
        nominatedBy: 'u1',
        nominatedByName: 'Rafi',
        nominatedAtMs: 1,
      ),
      BookOfMonthNominationDto.parse,
      (n) => n.toJson(),
      {
        'id',
        'periodId',
        'matchKey',
        'title',
        'author',
        'coverUrl',
        'workKey',
        'genre',
        'nominatedBy',
        'nominatedByName',
        'nominatedAtMs',
      },
    );
    roundTrip(
      'BookOfMonthPeriod',
      const BookOfMonthPeriod(id: '2026-10', discussionPostId: 'post'),
      BookOfMonthPeriodDto.parse,
      (p) => p.toJson(),
      {'id', 'discussionPostId'},
    );
    roundTrip(
      'BookOfMonthVote',
      const BookOfMonthVote(
        id: 'p_u1',
        periodId: 'p',
        userId: 'u1',
        matchKey: 'k',
        votedAtMs: 1,
      ),
      BookOfMonthVoteDto.parse,
      (v) => v.toJson(),
      {'id', 'periodId', 'userId', 'matchKey', 'votedAtMs'},
    );
  });

  group('older documents', () {
    test('missing optional fields fall back to defaults', () {
      final book = BookDto.parse({
        'id': 'b',
        'ownerId': 'u',
        'title': 'T',
        'author': 'A',
        'genre': 'G',
        'condition': 'Good',
        'estimatedValue': 5,
      });
      expect(book.description, '');
      expect(book.status, BookStatus.available);
      expect(book.updatedAtMs, 0);
      expect(book.coverPhotoUrl, isNull);
    });

    test('a post saved before reports/likes existed has empty lists', () {
      final post = ForumPostDto.parse({
        'id': 'p',
        'authorId': 'u',
        'authorName': 'N',
        'title': 'T',
        'body': 'B',
        'createdAtMs': 1,
      });
      expect(post.likedBy, isEmpty);
      expect(post.reportedBy, isEmpty);
      expect(post.replyCount, 0);
    });

    test('a request saved before condition history has no condition', () {
      final request = BorrowRequestDto.parse({
        'id': 'r',
        'bookId': 'b',
        'bookTitle': 'T',
        'borrowerId': 'u2',
        'lenderId': 'u1',
        'requestedAt': 1,
      });
      expect(request.status, RequestStatus.pending);
      expect(request.conditionOut, isNull);
      expect(request.conditionIn, isNull);
    });

    test('a report without a reason is treated as "other"', () {
      final report = ForumReportDto.parse({
        'id': 'x',
        'postId': 'p',
        'reporterId': 'u',
      });
      expect(report.reason, 'other');
      expect(report.replyId, isNull);
      expect(report.createdAtMs, 0);
    });

    test('a profile with the old acceptedTerms fields still parses', () {
      final profile = ReaderProfileDto.parse({
        'firstName': 'Sam',
        'lastName': 'Reader',
        'gender': 'Prefer not to say',
        'mobile': '+8801712345678',
        'address': 'Gazipur',
        'preferences': ['Fiction'],
        'favoriteBook': '',
        'acceptedTermsVersion': '1.1',
        'acceptedTermsAt': 'anything',
        'maxDistanceKm': 12,
      });
      expect(profile.maxDistanceKm, 12.0);
      expect(profile.toMap().keys, isNot(contains('acceptedTermsAt')));
    });

    test('a public profile parses with and without a photo', () {
      final bare = PublicProfileDto.parse('u', {'firstName': 'A'});
      expect(bare.photoUrl, isNull);
      expect(bare.hasLocation, isFalse);
      final full = PublicProfileDto.parse('u', {
        'firstName': 'A',
        'latitude': 1,
        'longitude': 2,
        'photoUrl': 'https://x/p.jpg',
      });
      expect(full.hasLocation, isTrue);
      expect(full.photoUrl, 'https://x/p.jpg');
    });
  });

  group('entities behave like value objects', () {
    const entry = ReadingEntry(
      id: 'e',
      userId: 'u',
      title: 'Dune',
      status: ReadingStatus.read,
      rating: 4,
      updatedAtMs: 1,
    );

    test('copyWith replaces only what is given', () {
      final changed = entry.copyWith(title: 'Emma', updatedAtMs: 9);
      expect(changed.title, 'Emma');
      expect(changed.updatedAtMs, 9);
      expect(changed.rating, 4);
      expect(changed.userId, 'u');
    });

    test('copyWith can clear a nullable field on purpose', () {
      expect(entry.copyWith(rating: null).rating, isNull);
      expect(entry.copyWith(rating: null).title, 'Dune');
      expect(entry.copyWith().rating, 4, reason: 'omitted means unchanged');
    });

    test('copyWith can set a nullable field that was null', () {
      final cleared = entry.copyWith(rating: null);
      expect(cleared.copyWith(rating: 2).rating, 2);
    });

    test('equality compares every field', () {
      expect(entry, entry.copyWith());
      expect(entry == entry.copyWith(title: 'x'), isFalse);
      expect(entry.hashCode, entry.copyWith().hashCode);
      expect({entry, entry.copyWith()}, hasLength(1));
    });

    test('lists inside entities compare by content', () {
      const a = ForumPost(
        id: 'p',
        authorId: 'u',
        authorName: 'N',
        title: 'T',
        body: 'B',
        createdAtMs: 1,
        likedBy: ['x', 'y'],
      );
      final b = a.copyWith(likedBy: ['x', 'y']);
      expect(b, a);
      expect(b.hashCode, a.hashCode);
      expect(a.copyWith(likedBy: ['x']) == a, isFalse);
    });

    test('domain rules still live on the entity', () {
      const post = ForumPost(
        id: 'p',
        authorId: 'u',
        authorName: 'N',
        title: 'T',
        body: 'B',
        createdAtMs: 1,
        reportedBy: ['a', 'b', 'c'],
      );
      expect(post.isHidden, isTrue);
      expect(post.copyWith(reportedBy: ['a']).isHidden, isFalse);
      expect(
        const Book(
          id: 'b',
          ownerId: 'u',
          title: '',
          author: 'A',
          genre: 'G',
          condition: 'Good',
          estimatedValue: 1,
        ).validate(),
        isNotNull,
      );
    });
  });
}
