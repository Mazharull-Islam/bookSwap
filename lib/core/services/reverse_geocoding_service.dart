import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_provider.dart';

/// Turns a (coarse) coordinate into a short "Neighbourhood, City" label via
/// Nominatim — free and keyless, like Open Library. Deliberately stops at
/// neighbourhood level: stored locations are rounded to ~1km, so anything
/// finer (a building number) would be a guess.
class ReverseGeocodingService {
  ReverseGeocodingService(this._dio);
  final Dio _dio;

  static const _endpoint = 'https://nominatim.openstreetmap.org/reverse';
  static const _areaKeys = [
    'neighbourhood',
    'suburb',
    'city_district',
    'quarter',
    'village',
    'hamlet',
  ];
  static const _cityKeys = [
    'city',
    'town',
    'municipality',
    'county',
    'state_district',
  ];

  Future<String?> labelFor(double lat, double lng) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _endpoint,
        queryParameters: {
          'lat': lat,
          'lon': lng,
          'format': 'jsonv2',
          'zoom': 14,
          'addressdetails': 1,
        },
        options: Options(headers: {'User-Agent': 'BookSwap/1.0'}),
      );
      final address = response.data?['address'] as Map<String, dynamic>?;
      if (address == null) return null;
      String? firstOf(List<String> keys) {
        for (final key in keys) {
          final value = address[key];
          if (value is String && value.isNotEmpty) return value;
        }
        return null;
      }

      final parts = {
        firstOf(_areaKeys),
        firstOf(_cityKeys),
      }.whereType<String>();
      return parts.isEmpty ? null : parts.join(', ');
    } on DioException {
      // A label is cosmetic; the card just falls back to "Area set".
      return null;
    }
  }
}

final reverseGeocodingServiceProvider = Provider<ReverseGeocodingService>(
  (ref) => ReverseGeocodingService(ref.watch(dioProvider)),
);

/// Cached per coordinate pair, so the card doesn't re-query on every rebuild.
final areaLabelProvider = FutureProvider.family<String?, (double, double)>(
  (ref, point) =>
      ref.watch(reverseGeocodingServiceProvider).labelFor(point.$1, point.$2),
);
