import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../borrow_requests/presentation/providers/request_providers.dart';
import '../../../reading/domain/models/reading_entry.dart';
import '../../../reading/presentation/providers/reading_providers.dart';
import '../../domain/models/achievement_badge.dart';
import '../../domain/reputation_stats.dart';

final reliabilityStatsProvider = Provider<ReliabilityStats>((ref) {
  final incoming = ref.watch(incomingRequestsProvider).valueOrNull ?? const [];
  final outgoing = ref.watch(outgoingRequestsProvider).valueOrNull ?? const [];
  return computeReliability(incoming: incoming, outgoing: outgoing);
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
