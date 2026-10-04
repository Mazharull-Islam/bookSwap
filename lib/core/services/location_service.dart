import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/distance_calculator.dart';

class LocationFailure implements Exception {
  const LocationFailure(this.message);
  final String message;
}

/// Thin wrapper around geolocator — the only thing that knows this is a
/// device/browser permission API. Coordinates are rounded before leaving
/// this layer (see [roundCoordinate]), so nothing downstream ever handles
/// exact-precision values.
class LocationService {
  Future<({double lat, double lng})> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationFailure(
        'Location services are turned off on this device.',
      );
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationFailure(
        'Location permission was denied. Allow location access to set your '
        'area.',
      );
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
    return (
      lat: roundCoordinate(position.latitude),
      lng: roundCoordinate(position.longitude),
    );
  }
}

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);
