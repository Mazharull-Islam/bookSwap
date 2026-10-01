import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../../../../app/widgets/nav_menu_button.dart';
import '../../../../app/widgets/profile_nav_button.dart';
import '../../../../shared/widgets/pill_tab_bar.dart';
import '../../../book_of_month/domain/period.dart';
import '../providers/leaderboard_providers.dart';
import '../widgets/ranking_tile.dart';

class LeaderboardPage extends ConsumerWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodId = ref.watch(leaderboardPeriodIdProvider);
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Leaderboard'),
            actions: const [
              ProfileNavButton(),
              NavMenuButton(),
              SizedBox(width: 4),
            ],
          ),
          floatingActionButton: PillTabBar(
            controller: DefaultTabController.of(context),
            labels: const ['Top Readers', 'Popular Authors'],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  periodLabel(periodId),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: forest,
                    fontSize: 16,
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      itemCount: readers.length,
      itemBuilder: (context, index) {
        final reader = readers[index];
        return RankingTile(
          rank: index + 1,
          label: reader.userName,
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
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
