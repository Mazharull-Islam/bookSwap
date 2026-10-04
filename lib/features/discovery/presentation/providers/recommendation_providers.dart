import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/services/public_profile_service.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../../blocking/presentation/providers/block_providers.dart';
import '../../../books/domain/entities/book.dart';
import '../../../books/presentation/providers/book_providers.dart';
import '../../../location/domain/owner_distance.dart';
import '../../../location/presentation/providers/location_providers.dart';
import '../../../reading/presentation/providers/reading_providers.dart';
import '../../../reviews/presentation/providers/review_providers.dart';
import '../../../wanted_books/presentation/providers/wanted_book_providers.dart';
import '../../domain/book_group.dart';
import '../../domain/recommendations.dart';
import 'discovery_providers.dart';

String _dismissKey(String userId) => 'recsDismissed:$userId';

/// Books the member said they aren't interested in, remembered on this device
/// (per account). Falls back to in-memory when the settings box isn't open.
class DismissedRecommendationsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final userId = ref.watch(currentUserProvider).id;
    if (!Hive.isBoxOpen(HiveService.settingsBoxName)) return {};
    final raw = Hive.box<String>(
      HiveService.settingsBoxName,
    ).get(_dismissKey(userId));
    if (raw == null) return {};
    try {
      return {...(jsonDecode(raw) as List).cast<String>()};
    } catch (_) {
      return {};
    }
  }

  Future<void> dismiss(String groupKey) async {
    state = {...state, groupKey};
    if (!Hive.isBoxOpen(HiveService.settingsBoxName)) return;
    await Hive.box<String>(HiveService.settingsBoxName).put(
      _dismissKey(ref.read(currentUserProvider).id),
      jsonEncode(state.toList()),
    );
  }
}

final dismissedRecommendationsProvider =
    NotifierProvider<DismissedRecommendationsNotifier, Set<String>>(
      DismissedRecommendationsNotifier.new,
    );

/// "Recommended for you", worked out on the device from what's already loaded.
final recommendationsProvider = Provider<List<Recommendation>>((ref) {
  final myId = ref.watch(currentUserProvider).id;
  final books = ref.watch(allBooksProvider).valueOrNull ?? const <Book>[];
  final shelf = ref.watch(myShelfProvider).valueOrNull ?? const <Book>[];
  final reading = ref.watch(myReadingProvider).valueOrNull ?? const [];
  final wanted = ref.watch(myWantedBooksProvider).valueOrNull ?? const [];
  final blocked = ref.watch(myBlockedUsersProvider).valueOrNull ?? const [];
  final preferences =
      ref.watch(authControllerProvider).valueOrNull?.profile?.preferences ??
      const <String>[];
  final myLocation = ref.watch(myLocationProvider);
  final profiles =
      ref.watch(allPublicProfilesProvider).valueOrNull ??
      const <String, PublicProfile>{};

  return recommendBooks(
    books: books,
    myId: myId,
    blockedOwnerIds: {for (final b in blocked) b.blockedId},
    ownedKeys: {for (final b in shelf) bookGroupKey(b)},
    reading: reading,
    wantedKeys: {for (final w in wanted) w.matchKey},
    preferences: preferences,
    ratings: ref.watch(ratingSummariesProvider),
    distanceKm: (book) => distanceToOwnerKm(
      myLocation: myLocation,
      ownerLocation: profiles[book.ownerId],
    ),
    maxDistanceKm: ref.watch(myMaxDistanceKmProvider),
    dismissedKeys: ref.watch(dismissedRecommendationsProvider),
  );
});
