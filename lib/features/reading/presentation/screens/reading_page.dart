import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/services/open_library_service.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/filter_widgets.dart';
import '../../../books/domain/entities/book.dart';
import '../../../books/domain/book_genres.dart';
import '../../../books/presentation/widgets/book_suggestion_tile.dart';
import '../../../discovery/domain/book_group.dart';
import '../../../discovery/presentation/providers/discovery_providers.dart';
import '../../domain/entities/reading_entry.dart';
import '../../domain/reading_filter.dart';
import '../../domain/repositories/reading_repository.dart';
import '../providers/reading_providers.dart';
import '../widgets/reading_entry_dialog.dart';
import '../widgets/reading_entry_tile.dart';
import '../widgets/reading_filter_sheet.dart';
import '../widgets/reading_stats_tab.dart';
import '../../../../core/services/book_enrichment_service.dart';
import '../../../../shared/genre_normalizer.dart';

class ReadingPage extends ConsumerStatefulWidget {
  const ReadingPage({super.key});

  @override
  ConsumerState<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends ConsumerState<ReadingPage> {
  final _query = TextEditingController();
  final _focus = FocusNode();
  final _filterQuery = TextEditingController();
  Timer? _debounce;
  List<BookMetadata> _suggestions = [];
  bool _searching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    _filterQuery.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 3) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  Future<void> _search(String query) async {
    setState(() => _searching = true);
    final local = ref.read(allBooksProvider).valueOrNull ?? const <Book>[];
    final localMatches =
        groupBooksByWork(
          local.where(
            (b) => b.title.toLowerCase().contains(query.toLowerCase()),
          ),
        ).map(
          (g) => BookMetadata(
            title: g.representative.title,
            author: g.representative.author,
            coverUrl: g.representative.coverPhotoUrl,
            workKey: g.representative.workKey,
            genres: bookGenreList(g.representative.genre),
          ),
        );
    var remote = const <BookMetadata>[];
    try {
      remote = await ref.read(openLibraryServiceProvider).searchByTitle(query);
    } on BookLookupFailure {
      // Local matches are still useful even if the network lookup fails.
    }
    final seen = <String>{};
    final merged = <BookMetadata>[];
    for (final suggestion in [...localMatches, ...remote]) {
      final key = readingMatchKey(
        workKey: suggestion.workKey,
        title: suggestion.title,
        author: suggestion.author,
      );
      if (seen.add(key)) merged.add(suggestion);
    }
    if (mounted && _query.text == query) {
      setState(() {
        _suggestions = merged.take(8).toList();
        _searching = false;
      });
    }
  }

  Future<void> _addEntry(BookMetadata suggestion) async {
    _query.clear();
    _focus.unfocus();
    setState(() => _suggestions = []);
    final ReadingEntry added;
    try {
      added = await ref.read(addReadingEntryProvider)(
        ReadingEntry(
          id: '',
          userId: ref.read(currentUserProvider).id,
          title: suggestion.title,
          author: suggestion.author,
          genre: standardGenres(subjects: suggestion.genres).join(', '),
          publishedYear: suggestion.publishedYear,
          coverUrl: suggestion.coverUrl,
          workKey: suggestion.workKey,
          updatedAtMs: 0,
        ),
      );
    } on ReadingValidationFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
      return;
    }
    // Best-effort, same as AddBookPage: refine genres and fetch a synopsis
    // after the entry already exists rather than blocking the add on it.
    final details = await ref
        .read(bookEnrichmentServiceProvider)
        .enrich(suggestion);
    await ref.read(updateReadingEntryProvider)(
      added.copyWith(
        genre: details.genres.join(', '),
        description: details.synopsis ?? added.description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(readingFilterProvider);
    return DefaultTabController(
      length: 4,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('My Reading'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'To read'),
                Tab(text: 'Reading'),
                Tab(text: 'Read'),
                Tab(text: 'Stats'),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TapRegion(
                  onTapOutside: (_) => setState(() => _suggestions = []),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _query,
                        focusNode: _focus,
                        label: 'Add a book',
                        hint: 'Try a title...',
                        prefixIcon: Icons.add,
                        suffixIcon: _searching
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : null,
                        onChanged: _onQueryChanged,
                      ),
                      if (_suggestions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          constraints: const BoxConstraints(maxHeight: 260),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(color: context.colors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _suggestions.length,
                              itemBuilder: (context, index) {
                                final suggestion = _suggestions[index];
                                return BookSuggestionTile(
                                  title: suggestion.title,
                                  author: suggestion.author,
                                  coverUrl: suggestion.coverUrl,
                                  onTap: () => _addEntry(suggestion),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _filterQuery,
                        label: 'Filter your list',
                        hint: 'Title, author or review...',
                        prefixIcon: Icons.filter_alt_outlined,
                        suffixIcon: filter.query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Clear filter',
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _filterQuery.clear();
                                  ref
                                      .read(readingFilterProvider.notifier)
                                      .state = filter.copyWith(
                                    query: '',
                                  );
                                },
                              ),
                        onChanged: (v) =>
                            ref.read(readingFilterProvider.notifier).state = ref
                                .read(readingFilterProvider)
                                .copyWith(query: v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilterButton(
                      count:
                          filter.activeCount -
                          (filter.query.trim().isEmpty ? 0 : 1),
                      onPressed: () => showFilterSheet(
                        context,
                        builder: (_) => const ReadingFilterSheet(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _ReadingList(status: ReadingStatus.planToRead),
                    _ReadingList(status: ReadingStatus.reading),
                    _ReadingList(status: ReadingStatus.read),
                    const ReadingStatsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadingList extends ConsumerWidget {
  const _ReadingList({required this.status});
  final ReadingStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(myReadingProvider);
    final filter = ref.watch(readingFilterProvider);
    return entries.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => const _Hint(
        icon: Icons.error_outline,
        text: 'Could not load your reading list. Please try again.',
      ),
      data: (all) {
        final inTab = all.where((e) => e.status == status).toList();
        final filtered = applyReadingFilter(inTab, filter);
        if (filtered.isEmpty && inTab.isNotEmpty) {
          return const _Hint(
            icon: Icons.search_off,
            text: 'Nothing in this list matches your filters.',
          );
        }
        if (filtered.isEmpty) {
          return _Hint(
            icon: Icons.menu_book_outlined,
            text: switch (status) {
              ReadingStatus.planToRead =>
                'Search above for a book to add to your list.',
              ReadingStatus.reading => 'Nothing marked as currently reading.',
              ReadingStatus.read =>
                'Books you finish and rate will show up here.',
            },
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final entry = filtered[index];
            return ReadingEntryTile(
              entry: entry,
              onTap: () => showReadingEntryDialog(context, entry),
            );
          },
        );
      },
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: context.colors.brand),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textMuted),
          ),
        ],
      ),
    ),
  );
}
