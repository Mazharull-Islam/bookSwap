import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/filter_widgets.dart';
import '../providers/discovery_providers.dart';
import '../widgets/book_group_detail_dialog.dart';
import '../widgets/book_group_grid_tile.dart';
import '../widgets/book_group_tile.dart';
import '../widgets/discovery_filter_sheet.dart';
import '../widgets/recommended_strip.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/view_mode.dart';
import '../../../../shared/widgets/cover_grid.dart';

class DiscoveryPage extends ConsumerStatefulWidget {
  const DiscoveryPage({super.key, this.banner});

  /// Shown above the search row. Supplied by the app's router so Discover
  /// doesn't depend on whichever feature provides it.
  final Widget? banner;

  @override
  ConsumerState<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends ConsumerState<DiscoveryPage> {
  final _query = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The query lives in a provider, so it outlasts this page; show it again
    // if the member comes back to Discover mid-search.
    _query.text = ref.read(discoverySearchQueryProvider);
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(discoveryResultsProvider);
    final query = ref.watch(discoverySearchQueryProvider);
    final filter = ref.watch(discoveryFilterProvider);
    final viewMode = ref.watch(discoveryViewModeProvider);
    final isGrid = viewMode == ViewMode.grid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          ViewModeButton(
            mode: viewMode,
            onChanged: (mode) =>
                ref.read(discoveryViewModeProvider.notifier).state = mode,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.banner != null) widget.banner!,
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _query,
                    label: 'Search for a book',
                    hint: 'Try a title or author...',
                    prefixIcon: Icons.search,
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _query.clear();
                              ref
                                      .read(
                                        discoverySearchQueryProvider.notifier,
                                      )
                                      .state =
                                  '';
                            },
                          ),
                    onChanged: (value) {
                      ref.read(discoverySearchQueryProvider.notifier).state =
                          value;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FilterButton(
                  count: filter.activeCount,
                  onPressed: () => showFilterSheet(
                    context,
                    builder: (_) => const DiscoveryFilterSheet(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const RecommendedStrip(),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (results.isEmpty) {
                    final narrowed =
                        query.trim().isNotEmpty || filter.activeCount > 0;
                    return EmptyState(
                      icon: Icons.menu_book_outlined,
                      message: narrowed
                          ? 'No listings match your search and filters.'
                          : 'No members have listed any books yet.',
                    );
                  }
                  return isGrid
                      ? GridView.builder(
                          padding: const EdgeInsets.only(top: 4),
                          gridDelegate: coverGridDelegate,
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
