import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../borrow_requests/presentation/providers/request_providers.dart';
import '../../../reading/domain/models/reading_entry.dart';
import '../../../reading/presentation/providers/reading_providers.dart';
import '../../data/repositories/hive_seen_badges_repository.dart';
import '../../domain/models/achievement_badge.dart';
import '../../domain/repositories/seen_badges_repository.dart';
import '../../domain/reputation_stats.dart';

final seenBadgesRepositoryProvider = Provider<SeenBadgesRepository>(
  (ref) => HiveSeenBadgesRepository(),
);

final reliabilityStatsProvider = Provider<ReliabilityStats>((ref) {
  final incoming = ref.watch(incomingRequestsProvider).valueOrNull ?? const [];
  final outgoing = ref.watch(outgoingRequestsProvider).valueOrNull ?? const [];
  return computeReliability(incoming: incoming, outgoing: outgoing);
});

final conditionRecordProvider = Provider<ConditionRecord>((ref) {
  final outgoing = ref.watch(outgoingRequestsProvider).valueOrNull ?? const [];
  return computeConditionRecord(outgoing);
});

final earnedBadgesProvider = Provider<List<AchievementBadge>>((ref) {
  final incoming = ref.watch(incomingRequestsProvider).valueOrNull ?? const [];
  final outgoing = ref.watch(outgoingRequestsProvider).valueOrNull ?? const [];
  final booksRead = (ref.watch(myReadingProvider).valueOrNull ?? const [])
      .where((e) => e.status == ReadingStatus.read)
      .length;
  return computeEarnedBadges(
    incoming: incoming,
    outgoing: outgoing,
    booksRead: booksRead,
  );
});

/// The badges plus whether every input they're computed from has actually
/// loaded. While anything is still loading (or reloading for a new sign-in)
/// the list is incomplete, so nothing may be announced from it.
class BadgeState {
  const BadgeState({required this.ready, required this.badges});
  final bool ready;
  final List<AchievementBadge> badges;
}

bool _loaded(AsyncValue<Object?> value) => value.hasValue && !value.isLoading;

final badgeStateProvider = Provider<BadgeState>((ref) {
  final ready =
      _loaded(ref.watch(incomingRequestsProvider)) &&
      _loaded(ref.watch(outgoingRequestsProvider)) &&
      _loaded(ref.watch(myReadingProvider));
  return BadgeState(ready: ready, badges: ref.watch(earnedBadgesProvider));
});
