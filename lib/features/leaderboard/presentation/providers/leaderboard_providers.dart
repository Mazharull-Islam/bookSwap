import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../book_of_month/domain/period.dart';
import '../../application/use_cases/record_read_activity.dart';
import '../../data/repositories/firestore_leaderboard_repository.dart';
import '../../domain/leaderboard_stats.dart';
import '../../domain/entities/reading_activity.dart';
import '../../domain/repositories/leaderboard_repository.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>(
  (ref) => FirestoreLeaderboardRepository(FirebaseFirestore.instance),
);

/// Reuses Book of the Month's period concept (SRS §3.11): the current
/// calendar month is always open, a past one is implicitly fixed.
final leaderboardPeriodIdProvider = Provider<String>(
  (ref) => currentPeriodId(),
);

final readingActivityProvider =
    StreamProvider.family<List<ReadingActivity>, String>(
      (ref, periodId) =>
          ref.watch(leaderboardRepositoryProvider).watchActivity(periodId),
    );

final topReadersProvider = Provider.family<List<ReaderRanking>, String>((
  ref,
  periodId,
) {
  final activity =
      ref.watch(readingActivityProvider(periodId)).valueOrNull ?? const [];
  return topReaders(activity);
});

final topAuthorsProvider = Provider.family<List<AuthorRanking>, String>((
  ref,
  periodId,
) {
  final activity =
      ref.watch(readingActivityProvider(periodId)).valueOrNull ?? const [];
  return topAuthors(activity);
});

final recordReadActivityProvider = Provider(
  (ref) => RecordReadActivity(ref.watch(leaderboardRepositoryProvider)),
);
