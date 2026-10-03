import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_mode_provider.dart';
import '../app_colors.dart';
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
            leading: Icon(icon, color: context.colors.brand),
            title: Text(label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(path),
          ),
        const Divider(height: 24),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Appearance', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                  ],
                  selected: {ref.watch(themeModeProvider)},
                  onSelectionChanged: (selection) =>
                      ref.read(themeModeProvider.notifier).set(selection.first),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 24),
        ListTile(
          leading: Icon(Icons.logout, color: context.colors.brand),
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
