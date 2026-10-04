import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/borrow_requests/domain/entities/borrow_request.dart';
import '../../features/borrow_requests/presentation/providers/reminder_providers.dart';
import '../../features/borrow_requests/presentation/providers/request_providers.dart';
import '../../features/reputation/presentation/widgets/badge_notification_watcher.dart';
import '../../features/wanted_books/presentation/providers/wanted_book_providers.dart';
import '../providers/book_sync_controller.dart';

/// Width at which the bottom bar gives way to a side rail.
const shellRailBreakpoint = 720.0;

class _Destination {
  const _Destination(this.label, this.icon, this.selectedIcon);
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// In the same order as the router's branches.
const _destinations = [
  _Destination('My Shelf', Icons.menu_book_outlined, Icons.menu_book),
  _Destination('Discover', Icons.search, Icons.search),
  _Destination('Wishlist', Icons.favorite_border, Icons.favorite),
  _Destination('Requests', Icons.swap_horiz, Icons.swap_horiz),
  _Destination('More', Icons.menu, Icons.menu),
];

const _wishlistIndex = 2;
const _requestsIndex = 3;

/// The signed-in frame: the tab bar (or side rail on wide screens) around the
/// current tab. Each tab keeps its own state while another is showing; see the
/// router's StatefulShellRoute.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(bookSyncControllerProvider);
    ref.watch(loanReminderSyncProvider);
    final pendingRequests =
        ref
            .watch(incomingRequestsProvider)
            .valueOrNull
            ?.where((r) => r.status == RequestStatus.pending)
            .length ??
        0;
    final matches = ref.watch(mutualMatchesProvider).length;
    final badges = {_requestsIndex: pendingRequests, _wishlistIndex: matches};
    final selected = navigationShell.currentIndex;

    Widget icon(int index, {required bool isSelected}) {
      final d = _destinations[index];
      final count = badges[index] ?? 0;
      return Badge.count(
        count: count,
        isLabelVisible: count > 0,
        child: Icon(isSelected ? d.selectedIcon : d.icon),
      );
    }

    // Tapping the tab you're already on goes back to its first screen (for
    // More, that's the menu); tapping another tab returns to where you left it.
    void go(int index) => navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );

    final wide = MediaQuery.sizeOf(context).width >= shellRailBreakpoint;
    final body = BadgeNotificationWatcher(child: navigationShell);
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selected,
              onDestinationSelected: go,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (var i = 0; i < _destinations.length; i++)
                  NavigationRailDestination(
                    icon: icon(i, isSelected: false),
                    selectedIcon: icon(i, isSelected: true),
                    label: Text(_destinations[i].label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: go,
        destinations: [
          for (var i = 0; i < _destinations.length; i++)
            NavigationDestination(
              icon: icon(i, isSelected: false),
              selectedIcon: icon(i, isSelected: true),
              label: _destinations[i].label,
            ),
        ],
      ),
    );
  }
}
