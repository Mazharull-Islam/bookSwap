import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../forum/presentation/providers/forum_providers.dart';
import '../../application/use_cases/book_of_month_use_cases.dart';
import '../../data/repositories/firestore_book_of_month_repository.dart';
import '../../domain/entities/book_of_month_nomination.dart';
import '../../domain/entities/book_of_month_period.dart';
import '../../domain/entities/book_of_month_vote.dart';
import '../../domain/period.dart';
import '../../domain/repositories/book_of_month_repository.dart';

final bookOfMonthRepositoryProvider = Provider<BookOfMonthRepository>(
  (ref) => FirestoreBookOfMonthRepository(FirebaseFirestore.instance),
);

final currentPeriodIdProvider = Provider<String>((ref) => currentPeriodId());

final nominationsProvider =
    StreamProvider.family<List<BookOfMonthNomination>, String>(
      (ref, periodId) =>
          ref.watch(bookOfMonthRepositoryProvider).watchNominations(periodId),
    );

final votesProvider = StreamProvider.family<List<BookOfMonthVote>, String>(
  (ref, periodId) =>
      ref.watch(bookOfMonthRepositoryProvider).watchVotes(periodId),
);

final periodInfoProvider = StreamProvider.family<BookOfMonthPeriod?, String>(
  (ref, periodId) =>
      ref.watch(bookOfMonthRepositoryProvider).watchPeriod(periodId),
);

final knownPeriodsProvider = StreamProvider<List<BookOfMonthPeriod>>(
  (ref) => ref.watch(bookOfMonthRepositoryProvider).watchKnownPeriods(),
);

/// Vote counts per nominee (matchKey -> count) for a period, derived from
/// the raw votes list rather than a denormalized counter — no increment
/// races to worry about.
final voteCountsProvider = Provider.family<Map<String, int>, String>((
  ref,
  periodId,
) {
  final votes = ref.watch(votesProvider(periodId)).valueOrNull ?? const [];
  final counts = <String, int>{};
  for (final vote in votes) {
    counts[vote.matchKey] = (counts[vote.matchKey] ?? 0) + 1;
  }
  return counts;
});

/// Nominations for a period, sorted by vote count (desc), nomination time
/// (asc) as a tiebreak.
final leaderboardProvider =
    Provider.family<List<BookOfMonthNomination>, String>((ref, periodId) {
      final nominations =
          ref.watch(nominationsProvider(periodId)).valueOrNull ?? const [];
      final counts = ref.watch(voteCountsProvider(periodId));
      final sorted = [...nominations]
        ..sort((a, b) {
          final byVotes = (counts[b.matchKey] ?? 0).compareTo(
            counts[a.matchKey] ?? 0,
          );
          return byVotes != 0
              ? byVotes
              : a.nominatedAtMs.compareTo(b.nominatedAtMs);
        });
      return sorted;
    });

/// The current period's leading nominee, if any — what Discovery features.
final currentPickProvider = Provider<BookOfMonthNomination?>((ref) {
  final periodId = ref.watch(currentPeriodIdProvider);
  final board = ref.watch(leaderboardProvider(periodId));
  return board.isEmpty ? null : board.first;
});

final nominateBookProvider = Provider(
  (ref) => NominateBook(ref.watch(bookOfMonthRepositoryProvider)),
);
final voteForBookProvider = Provider(
  (ref) => VoteForBook(ref.watch(bookOfMonthRepositoryProvider)),
);
final ensureDiscussionThreadProvider = Provider(
  (ref) => EnsureDiscussionThread(
    ref.watch(bookOfMonthRepositoryProvider),
    ref.watch(forumRepositoryProvider),
  ),
);
