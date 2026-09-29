import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/nav_menu_button.dart';
import '../../../../app/widgets/profile_nav_button.dart';
import '../../../../core/services/open_library_service.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/pill_tab_bar.dart';
import '../../../books/domain/models/book.dart';
import '../../../books/presentation/widgets/book_suggestion_tile.dart';
import '../../../discovery/domain/book_group.dart';
import '../../../discovery/presentation/providers/discovery_providers.dart';
import '../../domain/models/reading_entry.dart';
import '../../domain/repositories/reading_repository.dart';
import '../providers/reading_providers.dart';
import '../widgets/reading_entry_dialog.dart';
import '../widgets/reading_entry_tile.dart';

class ReadingPage extends ConsumerStatefulWidget {
  const ReadingPage({super.key});

  @override
  ConsumerState<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends ConsumerState<ReadingPage> {
  final _query = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  List<BookMetadata> _suggestions = [];
  bool _searching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
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
    try {
      await ref.read(addReadingEntryProvider)(
        ReadingEntry(
          id: '',
          userId: ref.read(currentUserProvider).id,
          title: suggestion.title,
          author: suggestion.author,
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
    }
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('My Reading'),
          actions: const [
            ProfileNavButton(),
            NavMenuButton(),
            SizedBox(width: 4),
          ],
        ),
        floatingActionButton: PillTabBar(
          controller: DefaultTabController.of(context),
          labels: const ['To read', 'Reading', 'Read'],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                          border: Border.all(color: const Color(0xFFD6DED5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _ReadingList(status: ReadingStatus.planToRead),
                  _ReadingList(status: ReadingStatus.reading),
                  _ReadingList(status: ReadingStatus.read),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ReadingList extends ConsumerWidget {
  const _ReadingList({required this.status});
  final ReadingStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(myReadingProvider);
    return entries.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => const _Hint(
        icon: Icons.error_outline,
        text: 'Could not load your reading list. Please try again.',
      ),
      data: (all) {
        final filtered = all.where((e) => e.status == status).toList();
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
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 88),
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
          Icon(icon, size: 56, color: forest),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF617065)),
          ),
        ],
      ),
    ),
  );
}
