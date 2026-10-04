import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/period.dart';
import '../../application/use_cases/record_read_activity.dart';
import '../../data/repositories/firestore_leaderboard_repository.dart';
import '../../domain/leaderboard_stats.dart';
import '../../domain/entities/reading_activity.dart';
import '../../domain/repositories/leaderboard_repository.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>(
  (ref) => FirestoreLeaderboardRepository(FirebaseFirestore.instance),
);

/// Which month the leaderboard is showing: 0 is this month, 1 last month, 2
/// the month before that. Goes back to this month when the screen is closed.
final leaderboardMonthsBackProvider = StateProvider.autoDispose<int>(
  (ref) => 0,
);

/// The month being viewed. Reading activity is always recorded against the
/// current month (see ReadingEntryDialog), whatever is shown here.
final viewedLeaderboardPeriodProvider = Provider.autoDispose<String>(
  (ref) => recentPeriodIds()[ref.watch(leaderboardMonthsBackProvider)],
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
