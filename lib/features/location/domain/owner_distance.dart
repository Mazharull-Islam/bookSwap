import '../../../shared/entities/public_profile.dart';
import '../../../core/utils/distance_calculator.dart';

/// Null when either party's location is unknown — callers treat that as
/// "don't know," not "too far" (an owner who hasn't set a location
/// shouldn't have their listings hidden by a distance filter they never
/// had a chance to satisfy).
double? distanceToOwnerKm({
  required PublicProfile? myLocation,
  required PublicProfile? ownerLocation,
}) {
  if (myLocation == null ||
      !myLocation.hasLocation ||
      ownerLocation == null ||
      !ownerLocation.hasLocation) {
    return null;
  }
  return haversineKm(
    lat1: myLocation.latitude!,
    lng1: myLocation.longitude!,
    lat2: ownerLocation.latitude!,
    lng2: ownerLocation.longitude!,
  );
}
