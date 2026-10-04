import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/public_profile_service.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';

/// Null means "no distance preference" — Discovery then shows everything
/// regardless of distance.
final myMaxDistanceKmProvider = Provider<double?>(
  (ref) =>
      ref.watch(authControllerProvider).valueOrNull?.profile?.maxDistanceKm,
);

/// My own location, looked up the same way as anyone else's — from the
/// bulk public_profiles stream Discovery already needs, rather than a
/// second, separate read.
final myLocationProvider = Provider<PublicProfile?>((ref) {
  final myId = ref.watch(authControllerProvider).valueOrNull?.id;
  if (myId == null) return null;
  return ref.watch(allPublicProfilesProvider).valueOrNull?[myId];
});

class SetMyLocation {
  const SetMyLocation(this._location, this._profiles);
  final LocationService _location;
  final PublicProfileService _profiles;

  Future<void> call(String uid, String firstName) async {
    final position = await _location.getCurrentPosition();
    await _profiles.updateLocation(uid, firstName, position.lat, position.lng);
  }

  /// Same destination as the GPS flow, but with coordinates already picked
  /// — e.g. from the map picker rather than the device's sensor.
  Future<void> setManually(
    String uid,
    String firstName,
    double lat,
    double lng,
  ) => _profiles.updateLocation(uid, firstName, lat, lng);
}

final setMyLocationProvider = Provider(
  (ref) => SetMyLocation(
    ref.watch(locationServiceProvider),
    ref.watch(publicProfileServiceProvider),
  ),
);
