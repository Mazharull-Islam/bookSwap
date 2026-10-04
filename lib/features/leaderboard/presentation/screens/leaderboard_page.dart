import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../book_of_month/domain/period.dart';
import '../providers/leaderboard_providers.dart';
import '../widgets/ranking_tile.dart';
import '../../../../shared/widgets/section_heading.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodId = ref.watch(leaderboardPeriodIdProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
              child: SectionHeading(periodLabel(periodId), fontSize: 16),
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
      return const _Hint(
        icon: Icons.menu_book_outlined,
        text: 'No books marked Read this month yet.',
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
      return const _Hint(
        icon: Icons.person_outline,
        text: 'No authors recorded this month yet.',
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
