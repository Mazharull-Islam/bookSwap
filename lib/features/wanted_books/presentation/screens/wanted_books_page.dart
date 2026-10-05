import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/services/open_library_service.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../books/domain/entities/book.dart';
import '../../../../shared/widgets/book_suggestion_tile.dart';
import '../../../borrow_requests/domain/repositories/request_repository.dart';
import '../../../borrow_requests/presentation/providers/request_providers.dart';
import '../../../discovery/domain/book_group.dart';
import '../../../discovery/presentation/providers/discovery_providers.dart';
import '../../domain/mutual_match.dart';
import '../../domain/repositories/wanted_book_repository.dart';
import '../providers/wanted_book_providers.dart';
import '../widgets/mutual_match_card.dart';
import '../widgets/wanted_book_tile.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../../../shared/domain/match_key.dart';
import '../../../../shared/widgets/feedback.dart';
import '../../../../shared/widgets/inline_spinner.dart';
import '../../../../shared/widgets/view_mode.dart';
import '../../../../shared/widgets/cover_grid.dart';
import '../widgets/wanted_book_grid_tile.dart';

class WantedBooksPage extends ConsumerStatefulWidget {
  const WantedBooksPage({super.key});

  @override
  ConsumerState<WantedBooksPage> createState() => _WantedBooksPageState();
}

class _WantedBooksPageState extends ConsumerState<WantedBooksPage> {
  final _query = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  List<BookMetadata> _suggestions = [];
  bool _searching = false;
  final _sendingFor = <String>{};
  final _sentFor = <String>{};

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
    // Match against books already known locally first (no network round
    // trip needed for a book someone on the app already listed), then fall
    // back to Open Library for anything else.
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
      final key = workMatchKey(
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

  Future<void> _addWanted(BookMetadata suggestion) async {
    _query.clear();
    _focus.unfocus();
    setState(() => _suggestions = []);
    try {
      await ref.read(addWantedBookProvider)(
        userId: ref.read(currentUserProvider).id,
        title: suggestion.title,
        author: suggestion.author,
        coverUrl: suggestion.coverUrl,
        workKey: suggestion.workKey,
      );
    } on WantedBookValidationFailure catch (e) {
      if (mounted) {
        showMessage(context, e.message);
      }
    }
  }

  String _matchId(MutualMatch match) =>
      '${match.otherUserId}|${match.theirBook.id}';

  Future<void> _requestMatch(MutualMatch match) async {
    final id = _matchId(match);
    setState(() => _sendingFor.add(id));
    try {
      await ref.read(sendBorrowRequestProvider)(
        book: match.theirBook,
        borrowerId: ref.read(currentUserProvider).id,
      );
      if (mounted) setState(() => _sentFor.add(id));
    } on RequestValidationFailure catch (e) {
      if (mounted) {
        showMessage(context, e.message);
      }
    } finally {
      if (mounted) setState(() => _sendingFor.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final wanted = ref.watch(myWantedBooksProvider);
    final matches = ref.watch(mutualMatchesProvider);
    final viewMode = ref.watch(wishlistViewModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          ViewModeButton(
            mode: viewMode,
            onChanged: (mode) =>
                ref.read(wishlistViewModeProvider.notifier).state = mode,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TapRegion(
              onTapOutside: (_) => setState(() => _suggestions = []),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _query,
                    focusNode: _focus,
                    label: 'Add a book you want',
                    hint: 'Try a title...',
                    prefixIcon: Icons.add,
                    suffixIcon: _searching
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: InlineSpinner(),
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
                              onTap: () => _addWanted(suggestion),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (matches.isNotEmpty) ...[
              const SizedBox(height: 20),
              SectionHeading('Matches'),
              const SizedBox(height: 8),
              ...matches.map(
                (match) => MutualMatchCard(
                  match: match,
                  sending: _sendingFor.contains(_matchId(match)),
                  sent: _sentFor.contains(_matchId(match)),
                  onRequest: () => _requestMatch(match),
                  onReview: () => context.go('/requests'),
                ),
              ),
            ],
            const SizedBox(height: 20),
            SectionHeading('What you want'),
            const SizedBox(height: 8),
            wanted.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Could not load your wishlist. Please try again.',
                  style: TextStyle(color: context.colors.textMuted),
                ),
              ),
              data: (items) => items.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "Search above for books you'd like to borrow — "
                        "we'll flag it if a match works out both ways.",
                        style: TextStyle(color: context.colors.textMuted),
                      ),
                    )
                  : viewMode == ViewMode.grid
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: coverGridDelegate,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final w = items[index];
                        return WantedBookGridTile(
                          wanted: w,
                          onRemove: () =>
                              ref.read(removeWantedBookProvider)(w.id),
                        );
                      },
                    )
                  : Column(
                      children: items
                          .map(
                            (w) => WantedBookTile(
                              wanted: w,
                              onRemove: () =>
                                  ref.read(removeWantedBookProvider)(w.id),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
