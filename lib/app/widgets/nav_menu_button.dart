import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/borrow_requests/domain/models/borrow_request.dart';
import '../../features/borrow_requests/presentation/providers/request_providers.dart';
import '../../features/wanted_books/presentation/providers/wanted_book_providers.dart';

/// Rightmost app-bar control on every shell page. Replaces a bottom
/// NavigationBar (six destinations was too many to fit comfortably) with a
/// single expanding menu, badged with the same pending-request / match
/// counts the old per-tab badges showed.
class NavMenuButton extends ConsumerWidget {
  const NavMenuButton({super.key});

  static const _destinations = [
    ('/shelf', 'My Shelf', Icons.menu_book_outlined),
    ('/discover', 'Discover', Icons.search),
    ('/wishlist', 'Wishlist', Icons.favorite_border),
    ('/requests', 'Requests', Icons.swap_horiz),
    ('/reading', 'My Reading', Icons.auto_stories_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCount = ref
        .watch(incomingRequestsProvider)
        .valueOrNull
        ?.where((r) => r.status == RequestStatus.pending)
        .length ?? 0;
    final matchCount = ref.watch(mutualMatchesProvider).length;
    final badgeCounts = {'/requests': pendingCount, '/wishlist': matchCount};
    final totalBadge = pendingCount + matchCount;

    return PopupMenuButton<String>(
      tooltip: 'Menu',
      icon: Badge.count(
        count: totalBadge,
        isLabelVisible: totalBadge > 0,
        child: const Icon(Icons.menu),
      ),
      onSelected: (value) async {
        if (value == 'sign-out') {
          await ref.read(authControllerProvider.notifier).signOut();
          if (context.mounted) context.go('/login');
        } else {
          context.go(value);
        }
      },
      itemBuilder: (context) => [
        for (final (path, label, icon) in _destinations)
          PopupMenuItem(
            value: path,
            child: Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(label)),
                if ((badgeCounts[path] ?? 0) > 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: CircleAvatar(
                      radius: 10,
                      child: Text(
                        '${badgeCounts[path]}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'sign-out',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20),
              SizedBox(width: 12),
              Text('Sign out'),
            ],
          ),
        ),
      ],
    );
  }
}
