import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/reverse_geocoding_service.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../providers/location_providers.dart';
import '../screens/location_picker_page.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../../../shared/widgets/feedback.dart';

const _distanceOptions = [1.0, 5.0, 10.0, 25.0, 50.0, 100.0];

class LocationSettingsCard extends ConsumerStatefulWidget {
  const LocationSettingsCard({super.key});

  @override
  ConsumerState<LocationSettingsCard> createState() =>
      _LocationSettingsCardState();
}

class _LocationSettingsCardState extends ConsumerState<LocationSettingsCard> {
  bool _settingLocation = false;

  Future<void> _pickOnMap() async {
    final user = ref.read(authControllerProvider).valueOrNull;
    if (user == null) return;
    final current = ref.read(myLocationProvider);
    final picked = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(
          initial: current != null && current.hasLocation
              ? LatLng(current.latitude!, current.longitude!)
              : null,
        ),
      ),
    );
    if (picked == null) return;
    try {
      await ref
          .read(setMyLocationProvider)
          .setManually(
            user.id,
            user.profile?.firstName ?? user.name,
            picked.latitude,
            picked.longitude,
          );
    } on FirebaseException catch (e) {
      if (mounted) {
        showMessage(context, 'Could not save your area (${e.code}).');
      }
    }
  }

  Future<void> _setLocation() async {
    final user = ref.read(authControllerProvider).valueOrNull;
    if (user == null || _settingLocation) return;
    setState(() => _settingLocation = true);
    try {
      await ref.read(setMyLocationProvider)(
        user.id,
        user.profile?.firstName ?? user.name,
      );
    } on LocationFailure catch (e) {
      if (mounted) {
        showMessage(context, e.message);
      }
    } finally {
      if (mounted) setState(() => _settingLocation = false);
    }
  }

  Future<void> _setMaxDistance(double? km) async {
    await ref.read(authRepositoryProvider).updateMaxDistance(km);
    await ref.read(authControllerProvider.notifier).refreshSession();
  }

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(myLocationProvider);
    final maxDistance = ref.watch(myMaxDistanceKmProvider);
    final areaLabel = location != null && location.hasLocation
        ? ref
              .watch(
                areaLabelProvider((location.latitude!, location.longitude!)),
              )
              .valueOrNull
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading('Location & distance'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  location != null && location.hasLocation
                      ? (areaLabel != null
                            ? 'Area set: $areaLabel'
                            : 'Area set — used to show distance on Discovery.')
                      : 'No area set yet.',
                  style: TextStyle(color: context.colors.textMuted),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _settingLocation ? null : _setLocation,
                child: _settingLocation
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        location != null && location.hasLocation
                            ? 'Update'
                            : 'Set area',
                      ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _pickOnMap,
            icon: const Icon(Icons.map_outlined),
            label: const Text('Pick on map'),
          ),
          const SizedBox(height: 14),
          Text(
            'Max exchange distance',
            style: TextStyle(color: context.colors.textMuted),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<double?>(
            isExpanded: true,
            initialValue: maxDistance,
            decoration: const InputDecoration(isDense: true),
            items: [
              const DropdownMenuItem<double?>(child: Text('No limit')),
              ..._distanceOptions.map(
                (km) => DropdownMenuItem<double?>(
                  value: km,
                  child: Text('${km.toStringAsFixed(0)} km'),
                ),
              ),
            ],
            onChanged: (value) => _setMaxDistance(value),
          ),
        ],
      ),
    );
  }
}
