import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/services/open_library_service.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../books/domain/entities/book.dart';
import '../../../books/domain/book_genres.dart';
import '../../../../shared/widgets/book_suggestion_tile.dart';
import '../../../discovery/domain/book_group.dart';
import '../../../discovery/presentation/providers/discovery_providers.dart';
import '../../domain/entities/book_of_month_nomination.dart';
import '../../domain/period.dart';
import '../providers/book_of_month_providers.dart';
import '../widgets/nomination_tile.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../../../core/utils/friendly_error.dart';
import '../../domain/repositories/book_of_month_repository.dart';
import '../../../../shared/genre_normalizer.dart';
import '../../../../shared/domain/match_key.dart';
import '../../../../shared/widgets/feedback.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../shared/widgets/inline_spinner.dart';

class BookOfMonthPage extends ConsumerStatefulWidget {
  const BookOfMonthPage({super.key});

  @override
  ConsumerState<BookOfMonthPage> createState() => _BookOfMonthPageState();
}

class _BookOfMonthPageState extends ConsumerState<BookOfMonthPage> {
  final _query = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  List<BookMetadata> _suggestions = [];
  bool _searching = false;
  bool _ensuringThread = false;

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

  /// Standard genres only; null when none could be read.
  String? _nominationGenre(List<String> subjects) {
    final genres = standardGenres(subjects: subjects);
    return genres.first == unknownGenre ? null : genres.join(', ');
  }

  Future<void> _nominate(BookMetadata suggestion) async {
    _query.clear();
    _focus.unfocus();
    setState(() => _suggestions = []);
    final me = ref.read(currentUserProvider);
    try {
      await ref.read(nominateBookProvider)(
        periodId: ref.read(currentPeriodIdProvider),
        nominatedBy: me.id,
        nominatedByName: me.displayName,
        title: suggestion.title,
        author: suggestion.author,
        coverUrl: suggestion.coverUrl,
        workKey: suggestion.workKey,
        genre: _nominationGenre(suggestion.genres),
      );
    } on BookOfMonthValidationFailure catch (e) {
      if (mounted) {
        showMessage(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          context,
          friendlyError(e, fallback: 'Could not nominate that book.'),
        );
      }
    }
  }

  Future<void> _vote(BookOfMonthNomination nomination) async {
    try {
      await ref.read(voteForBookProvider)(
        periodId: nomination.periodId,
        userId: ref.read(currentUserProvider).id,
        matchKey: nomination.matchKey,
      );
    } on BookOfMonthValidationFailure catch (e) {
      if (mounted) {
        showMessage(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          context,
          friendlyError(e, fallback: 'Could not save your vote.'),
        );
      }
    }
  }

  Future<void> _maybeEnsureThread(String periodId) async {
    if (_ensuringThread) return;
    final period = ref.read(periodInfoProvider(periodId)).valueOrNull;
    final nominations = ref.read(nominationsProvider(periodId)).valueOrNull;
    if (period == null || nominations == null || nominations.isEmpty) return;
    if (period.discussionPostId != null) return;
    _ensuringThread = true;
    final me = ref.read(currentUserProvider);
    await ref.read(ensureDiscussionThreadProvider)(
      period: period,
      hasNominations: true,
      authorId: me.id,
      authorName: me.displayName,
    );
    _ensuringThread = false;
  }

  void _openDiscussion(String postId) => context.push('/forum/post/$postId');

  @override
  Widget build(BuildContext context) {
    final periodId = ref.watch(currentPeriodIdProvider);
    final board = ref.watch(leaderboardProvider(periodId));
    final counts = ref.watch(voteCountsProvider(periodId));
    final period = ref.watch(periodInfoProvider(periodId)).valueOrNull;
    final myId = ref.watch(currentUserProvider).id;
    final myVotes =
        ref
            .watch(votesProvider(periodId))
            .valueOrNull
            ?.where((v) => v.userId == myId) ??
        const Iterable.empty();
    final myVote = myVotes.isEmpty ? null : myVotes.first;

    ref.listen(
      nominationsProvider(periodId),
      (_, _) => _maybeEnsureThread(periodId),
    );
    ref.listen(
      periodInfoProvider(periodId),
      (_, _) => _maybeEnsureThread(periodId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Book of the Month')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeading(periodLabel(periodId), fontSize: 16),
          const SizedBox(height: 12),
          TapRegion(
            onTapOutside: (_) => setState(() => _suggestions = []),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _query,
                  focusNode: _focus,
                  label: 'Nominate a book',
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
                            onTap: () => _nominate(suggestion),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (period?.discussionPostId != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SecondaryButton(
                label: 'Open this month\'s discussion',
                icon: Icons.forum_outlined,
                onPressed: () => _openDiscussion(period!.discussionPostId!),
              ),
            ),
          if (board.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No nominations yet this month — search above to start.',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.textMuted),
              ),
            )
          else
            ...board.map(
              (nomination) => NominationTile(
                nomination: nomination,
                voteCount: counts[nomination.matchKey] ?? 0,
                isLeader:
                    nomination.matchKey == board.first.matchKey &&
                    (counts[nomination.matchKey] ?? 0) > 0,
                isMyVote: myVote?.matchKey == nomination.matchKey,
                onVote: () => _vote(nomination),
              ),
            ),
          const SizedBox(height: 24),
          const _ArchiveSection(),
        ],
      ),
    );
  }
}

class _ArchiveSection extends ConsumerWidget {
  const _ArchiveSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(knownPeriodsProvider).valueOrNull ?? const [];
    final current = ref.watch(currentPeriodIdProvider);
    final past = periods.where((p) => p.id != current).toList();
    if (past.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading('Past picks'),
        const SizedBox(height: 8),
        ...past.map((period) => _PastPickTile(periodId: period.id)),
      ],
    );
  }
}

class _PastPickTile extends ConsumerWidget {
  const _PastPickTile({required this.periodId});
  final String periodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(leaderboardProvider(periodId));
    final counts = ref.watch(voteCountsProvider(periodId));
    final winner = board.isNotEmpty ? board.first : null;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(periodLabel(periodId)),
      subtitle: Text(
        winner == null
            ? 'No nominations'
            : '${winner.title} · ${counts[winner.matchKey] ?? 0} votes',
      ),
    );
  }
}
