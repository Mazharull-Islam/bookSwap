import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../core/services/public_profile_service.dart';
import '../../../books/domain/models/book.dart';
import '../../../books/presentation/providers/book_providers.dart';
import '../../../location/domain/owner_distance.dart';
import '../../../location/presentation/providers/location_providers.dart';
import '../../domain/book_group.dart';
import '../../domain/discovery_filter.dart';

final allBooksProvider = StreamProvider<List<Book>>(
  (ref) => ref.watch(bookRepositoryProvider).watchAll(),
);

final discoverySearchQueryProvider = StateProvider<String>((ref) => '');

final discoveryFilterProvider = StateProvider<DiscoveryFilter>(
  (ref) => const DiscoveryFilter(),
);

/// Upper bound for the value slider: the priciest listed book, rounded up.
final discoveryValueCeilingProvider = Provider<double>((ref) {
  final books = ref.watch(allBooksProvider).valueOrNull ?? const <Book>[];
  final highest = books.fold<double>(
    0,
    (m, b) => b.estimatedValue > m ? b.estimatedValue : m,
  );
  return (highest / 100).ceil().clamp(1, 1000000) * 100.0;
});

/// Every other member's listings, narrowed by the text query and filters.
final discoveryResultsProvider = Provider<List<BookGroup>>((ref) {
  final query = ref.watch(discoverySearchQueryProvider).trim().toLowerCase();
  final filter = ref.watch(discoveryFilterProvider);

  final books = ref.watch(allBooksProvider).valueOrNull ?? const <Book>[];
  final myId = ref.watch(currentUserProvider).id;
  final myLocation = ref.watch(myLocationProvider);
  // A per-search override beats the Profile limit; infinity = no limit.
  final maxDistanceKm =
      filter.maxDistanceKm ?? ref.watch(myMaxDistanceKmProvider);
  final profiles =
      ref.watch(allPublicProfilesProvider).valueOrNull ??
      const <String, PublicProfile>{};

  double? distanceOf(Book book) => distanceToOwnerKm(
    myLocation: myLocation,
    ownerLocation: profiles[book.ownerId],
  );

  final matches = books.where((book) {
    if (book.ownerId == myId) return false;
    if (query.isNotEmpty &&
        !book.title.toLowerCase().contains(query) &&
        !book.author.toLowerCase().contains(query)) {
      return false;
    }
    if (!bookPassesDiscoveryFilter(book, filter)) return false;
    // Only filters when both a limit and both locations are known — an owner
    // who hasn't set a location never gets excluded by this.
    if (maxDistanceKm == null) return true;
    final distance = distanceOf(book);
    return distance == null || distance <= maxDistanceKm;
  });
  return sortDiscoveryGroups(
    groupBooksByWork(matches),
    filter.sort,
    distanceOf,
  );
});

/// Independent of shelfViewModeProvider — toggling grid/list here shouldn't
/// affect My Shelf's view mode or vice versa.
final discoveryViewModeProvider = StateProvider<ShelfViewMode>(
  (ref) => ShelfViewMode.list,
);
