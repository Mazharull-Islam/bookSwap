import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/period.dart';
import '../providers/leaderboard_providers.dart';
import '../widgets/ranking_tile.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/back_to_more_button.dart';
import '../../../../shared/widgets/period_selector.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodId = ref.watch(viewedLeaderboardPeriodProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackToMoreButton(),
          title: const Text('Leaderboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Top Readers'),
              Tab(text: 'Popular Authors'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: PeriodSelector(
                  periods: recentPeriodIds(),
                  selected: periodId,
                  onSelected: (id) =>
                      ref.read(leaderboardMonthsBackProvider.notifier).state =
                          recentPeriodIds().indexOf(id),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _TopReadersTab(periodId: periodId),
                  _TopAuthorsTab(periodId: periodId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopReadersTab extends ConsumerWidget {
  const _TopReadersTab({required this.periodId});
  final String periodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readers = ref.watch(topReadersProvider(periodId));
    if (readers.isEmpty) {
      return EmptyState(
        icon: Icons.menu_book_outlined,
        message: periodId == currentPeriodId()
            ? 'No books marked Read this month yet.'
            : 'No books were marked Read in ${periodLabel(periodId)}.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: readers.length,
      itemBuilder: (context, index) {
        final reader = readers[index];
        return RankingTile(
          rank: index + 1,
          label: reader.userName,
          userId: reader.userId,
          count: reader.count,
          countLabel: reader.count == 1 ? 'book' : 'books',
        );
      },
    );
  }
}

class _TopAuthorsTab extends ConsumerWidget {
  const _TopAuthorsTab({required this.periodId});
  final String periodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authors = ref.watch(topAuthorsProvider(periodId));
    if (authors.isEmpty) {
      return EmptyState(
        icon: Icons.person_outline,
        message: periodId == currentPeriodId()
            ? 'No authors recorded this month yet.'
            : 'No authors were recorded in ${periodLabel(periodId)}.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: authors.length,
      itemBuilder: (context, index) {
        final author = authors[index];
        return RankingTile(
          rank: index + 1,
          label: author.author,
          count: author.count,
          countLabel: author.count == 1 ? 'read' : 'reads',
        );
      },
    );
  }
}
