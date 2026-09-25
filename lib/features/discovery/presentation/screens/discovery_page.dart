import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../books/presentation/providers/book_providers.dart';
import '../providers/discovery_providers.dart';
import '../widgets/book_group_detail_dialog.dart';
import '../widgets/book_group_grid_tile.dart';
import '../widgets/book_group_tile.dart';

class DiscoveryPage extends ConsumerStatefulWidget {
  const DiscoveryPage({super.key});

  @override
  ConsumerState<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends ConsumerState<DiscoveryPage> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(discoveryResultsProvider);
    final viewMode = ref.watch(discoveryViewModeProvider);
    final isGrid = viewMode == ShelfViewMode.grid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            tooltip: isGrid ? 'Switch to list view' : 'Switch to grid view',
            icon: Icon(
              isGrid ? Icons.view_list_outlined : Icons.grid_view_outlined,
            ),
            onPressed: () =>
                ref.read(discoveryViewModeProvider.notifier).state =
                    isGrid ? ShelfViewMode.list : ShelfViewMode.grid,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _query,
              label: 'Search for a book',
              hint: 'Try a title...',
              prefixIcon: Icons.search,
              suffixIcon: _query.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _query.clear();
                        ref.read(discoverySearchQueryProvider.notifier).state =
                            '';
                        setState(() {});
                      },
                    ),
              onChanged: (value) {
                ref.read(discoverySearchQueryProvider.notifier).state = value;
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (results == null) {
                    return const _Hint(
                      icon: Icons.search,
                      text:
                          'Search by title to see which members nearby have '
                          'it on their shelf.',
                    );
                  }
                  if (results.isEmpty) {
                    return const _Hint(
                      icon: Icons.menu_book_outlined,
                      text: 'No members have that book listed yet.',
                    );
                  }
                  return isGrid
                      ? GridView.builder(
                          padding: const EdgeInsets.only(top: 4),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 180,
                                childAspectRatio: 0.62,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final group = results[index];
                            return BookGroupGridTile(
                              group: group,
                              onTap: () =>
                                  showBookGroupDetailDialog(context, group),
                            );
                          },
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 4),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final group = results[index];
                            return BookGroupTile(
                              group: group,
                              onTap: () =>
                                  showBookGroupDetailDialog(context, group),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
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
