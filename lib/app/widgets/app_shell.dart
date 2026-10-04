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
  const _Destination(this.path, this.label, this.icon, this.selectedIcon);
  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const _destinations = [
  _Destination('/shelf', 'My Shelf', Icons.menu_book_outlined, Icons.menu_book),
  _Destination('/discover', 'Discover', Icons.search, Icons.search),
  _Destination('/wishlist', 'Wishlist', Icons.favorite_border, Icons.favorite),
  _Destination('/requests', 'Requests', Icons.swap_horiz, Icons.swap_horiz),
  _Destination('/more', 'More', Icons.menu, Icons.menu),
];

/// Everything that isn't one of the first four tabs lives under More, so
/// More stays highlighted while you're on any of those screens.
int shellIndexFor(String location) {
  for (var i = 0; i < _destinations.length - 1; i++) {
    if (location.startsWith(_destinations[i].path)) return i;
  }
  return _destinations.length - 1;
}

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.location, required this.child});
  final String location;
  final Widget child;

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
    final badges = {'/requests': pendingRequests, '/wishlist': matches};
    final selected = shellIndexFor(location);

    Widget icon(_Destination d, {required bool isSelected}) {
      final count = badges[d.path] ?? 0;
      return Badge.count(
        count: count,
        isLabelVisible: count > 0,
        child: Icon(isSelected ? d.selectedIcon : d.icon),
      );
    }

    void go(int index) => context.go(_destinations[index].path);

    final wide = MediaQuery.sizeOf(context).width >= shellRailBreakpoint;
    final body = BadgeNotificationWatcher(child: child);
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
                    icon: icon(_destinations[i], isSelected: false),
                    selectedIcon: icon(_destinations[i], isSelected: true),
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
              icon: icon(_destinations[i], isSelected: false),
              selectedIcon: icon(_destinations[i], isSelected: true),
              label: _destinations[i].label,
            ),
        ],
      ),
    );
  }
}
