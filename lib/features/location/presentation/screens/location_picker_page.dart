import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../app/app_colors.dart';

const _fallbackCenter = LatLng(23.8103, 90.4125);

/// Tap-to-place map for choosing an exchange area. Pops with the chosen
/// point already coarsened to ~1km, same as the GPS path.
class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key, this.initial});
  final LatLng? initial;

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng? _picked;

  @override
  Widget build(BuildContext context) {
    final picked = _picked ?? widget.initial;
    return Scaffold(
      appBar: AppBar(title: const Text('Pick your area')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: widget.initial ?? _fallbackCenter,
                initialZoom: widget.initial == null ? 11 : 13,
                onTap: (_, point) => setState(() => _picked = point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.bookswap.app',
                ),
                if (picked != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: picked,
                        width: 40,
                        height: 40,
                        alignment: Alignment.topCenter,
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                const SimpleAttributionWidget(
                  source: Text('OpenStreetMap contributors'),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _picked == null
                        ? 'Tap the map to drop a pin. Only an approximate '
                              'area (~1 km) is saved.'
                        : 'Pin placed. Only an approximate area (~1 km) is '
                              'saved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.textMuted),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Use this area',
                    onPressed: _picked == null
                        ? null
                        : () => Navigator.of(context).pop(
                            LatLng(
                              roundCoordinate(_picked!.latitude),
                              roundCoordinate(_picked!.longitude),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
