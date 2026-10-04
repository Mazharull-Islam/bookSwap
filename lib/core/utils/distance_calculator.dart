import 'dart:math';

const _earthRadiusKm = 6371.0;

double _degToRad(double deg) => deg * pi / 180;

/// Great-circle distance between two lat/lng points, in kilometres (the
/// haversine formula). Pure Dart, no platform dependency.
double haversineKm({
  required double lat1,
  required double lng1,
  required double lat2,
  required double lng2,
}) {
  final dLat = _degToRad(lat2 - lat1);
  final dLng = _degToRad(lng2 - lng1);
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          sin(dLng / 2) *
          sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return _earthRadiusKm * c;
}

/// Coarsens a coordinate to ~1km precision (2 decimal places) before it's
/// ever stored — the privacy trim this feature relies on: any member can
/// read another member's location (needed to compute distance client-side,
/// since there's no backend function to do it privately), but never at
/// exact-address precision.
double roundCoordinate(double value) => (value * 100).round() / 100;
