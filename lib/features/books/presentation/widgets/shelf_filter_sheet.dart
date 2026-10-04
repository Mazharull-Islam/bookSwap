import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/genre_filter.dart';
import '../../../../shared/widgets/filter_widgets.dart';
import '../../domain/entities/book.dart';
import '../../domain/shelf_filter.dart';
import '../providers/book_providers.dart';

String _statusLabel(BookStatus s) => switch (s) {
  BookStatus.available => 'Available',
  BookStatus.requested => 'Requested',
  BookStatus.lent => 'Lent out',
  BookStatus.returned => 'Returned',
};

String _sortLabel(ShelfSort s) => switch (s) {
  ShelfSort.recent => 'Recently updated',
  ShelfSort.title => 'Title',
  ShelfSort.author => 'Author',
  ShelfSort.value => 'Highest value',
};

class ShelfFilterSheet extends ConsumerWidget {
  const ShelfFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(shelfFilterProvider);
    void update(ShelfFilter next) =>
        ref.read(shelfFilterProvider.notifier).state = next;
    return FilterSheetFrame(
      onClear: () => update(const ShelfFilter()),
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
        FilterSection(
          title: 'Status',
          child: MultiChipGroup<BookStatus>(
            options: BookStatus.values,
            selected: filter.statuses,
            labelOf: _statusLabel,
            onChanged: (v) => update(filter.copyWith(statuses: v)),
          ),
        ),
        FilterSection(
          title: 'Sort by',
          child: SingleChipGroup<ShelfSort>(
            options: ShelfSort.values,
            selected: filter.sort,
            labelOf: _sortLabel,
            onChanged: (v) => update(filter.copyWith(sort: v)),
          ),
        ),
      ],
    );
  }
}
