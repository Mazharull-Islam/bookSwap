import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/genre_filter.dart';
import '../../../../shared/widgets/filter_widgets.dart';
import '../../../books/domain/entities/book.dart';
import '../../../location/presentation/providers/location_providers.dart';
import '../../domain/discovery_filter.dart';
import '../providers/discovery_providers.dart';

String _sortLabel(DiscoverySort s) => switch (s) {
  DiscoverySort.title => 'Title',
  DiscoverySort.nearest => 'Nearest first',
  DiscoverySort.value => 'Lowest value',
};

String _distanceLabel(double km) =>
    km.isInfinite ? 'Any distance' : 'Within ${km.toStringAsFixed(0)} km';

class DiscoveryFilterSheet extends ConsumerWidget {
  const DiscoveryFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(discoveryFilterProvider);
    final ceiling = ref.watch(discoveryValueCeilingProvider);
    final profileLimit = ref.watch(myMaxDistanceKmProvider);
    void update(DiscoveryFilter next) =>
        ref.read(discoveryFilterProvider.notifier).state = next;

    final effectiveDistance =
        filter.maxDistanceKm ?? profileLimit ?? double.infinity;
    final distanceIndex = distanceSteps
        .indexOf(effectiveDistance)
        .clamp(0, distanceSteps.length - 1);
    final range = filter.valueRange ?? ValueRange(0, ceiling);

    return FilterSheetFrame(
      onClear: () => update(const DiscoveryFilter()),
      children: [
        FilterSection(
          title: 'Genre',
          child: MultiChipGroup<String>(
            options: filterGenres,
            selected: filter.genres,
            labelOf: (g) => g,
            onChanged: (v) => update(filter.copyWith(genres: v)),
          ),
        ),
        FilterSection(
          title: 'Condition',
          child: MultiChipGroup<String>(
            options: bookConditionOptions,
            selected: filter.conditions,
            labelOf: (c) => c,
            onChanged: (v) => update(filter.copyWith(conditions: v)),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Available now only'),
          value: filter.availableOnly,
          onChanged: (v) => update(filter.copyWith(availableOnly: v)),
        ),
        FilterSection(
          title:
              'Distance — ${_distanceLabel(effectiveDistance)}'
              '${filter.maxDistanceKm == null && profileLimit != null ? ' (from your Profile)' : ''}',
          child: Slider(
            value: distanceIndex.toDouble(),
            max: (distanceSteps.length - 1).toDouble(),
            divisions: distanceSteps.length - 1,
            label: _distanceLabel(distanceSteps[distanceIndex]),
            onChanged: (v) => update(
              filter.copyWith(maxDistanceKm: distanceSteps[v.round()]),
            ),
          ),
        ),
        FilterSection(
          title:
              'Estimated value — ৳${range.start.round()} to '
              '৳${range.end.round()}',
          child: RangeSlider(
            values: RangeValues(
              range.start.clamp(0, ceiling),
              range.end.clamp(0, ceiling),
            ),
            max: ceiling,
            labels: RangeLabels(
              '৳${range.start.round()}',
              '৳${range.end.round()}',
            ),
            onChanged: (v) => update(
              filter.copyWith(
                valueRange: v.start <= 0 && v.end >= ceiling
                    ? null
                    : ValueRange(v.start, v.end),
              ),
            ),
          ),
        ),
        FilterSection(
          title: 'Sort by',
          child: SingleChipGroup<DiscoverySort>(
            options: DiscoverySort.values,
            selected: filter.sort,
            labelOf: _sortLabel,
            onChanged: (v) => update(filter.copyWith(sort: v)),
          ),
        ),
      ],
    );
  }
}
