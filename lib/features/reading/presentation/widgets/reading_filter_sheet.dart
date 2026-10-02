import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/genre_filter.dart';
import '../../../../shared/widgets/filter_widgets.dart';
import '../../domain/reading_filter.dart';
import '../providers/reading_providers.dart';

String _sortLabel(ReadingSort s) => switch (s) {
  ReadingSort.recent => 'Recently updated',
  ReadingSort.title => 'Title',
  ReadingSort.rating => 'Highest rated',
};

class ReadingFilterSheet extends ConsumerWidget {
  const ReadingFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(readingFilterProvider);
    void update(ReadingFilter next) =>
        ref.read(readingFilterProvider.notifier).state = next;
    return FilterSheetFrame(
      onClear: () => update(ReadingFilter(query: filter.query)),
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
          title: 'Minimum rating (Read tab)',
          child: SingleChipGroup<int?>(
            options: const [null, 3, 4, 5],
            selected: filter.minRating,
            labelOf: (r) => r == null ? 'Any' : '$r★ & up',
            onChanged: (v) => update(filter.copyWith(minRating: v)),
          ),
        ),
        FilterSection(
          title: 'Sort by',
          child: SingleChipGroup<ReadingSort>(
            options: ReadingSort.values,
            selected: filter.sort,
            labelOf: _sortLabel,
            onChanged: (v) => update(filter.copyWith(sort: v)),
          ),
        ),
      ],
    );
  }
}
