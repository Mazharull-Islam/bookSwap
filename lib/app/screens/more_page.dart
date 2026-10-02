import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  static const _destinations = [
    ('/reading', 'My Reading', Icons.auto_stories_outlined),
    ('/forum', 'Forum', Icons.forum_outlined),
    ('/book-of-month', 'Book of the Month', Icons.emoji_events_outlined),
    ('/leaderboard', 'Leaderboard', Icons.leaderboard_outlined),
    ('/profile', 'Profile', Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('More')),
    body: ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (final (path, label, icon) in _destinations)
          ListTile(
            leading: Icon(icon, color: forest),
            title: Text(label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(path),
          ),
        const Divider(height: 24),
        ListTile(
          leading: const Icon(Icons.logout, color: forest),
          title: const Text('Sign out'),
          onTap: () async {
            await ref.read(authControllerProvider.notifier).signOut();
            if (context.mounted) context.go('/login');
          },
        ),
      ],
    ),
  );
}
