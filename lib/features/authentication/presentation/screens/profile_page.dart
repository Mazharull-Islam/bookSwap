import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../../location/presentation/widgets/location_settings_card.dart';
import '../../../reputation/presentation/widgets/reputation_card.dart';
import '../../domain/models/registration.dart';
import '../providers/auth_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;
    final profile = user?.profile;
    return Scaffold(
      appBar: AppBar(
        // go_router's go() replaces the location, so there's no stack for
        // an automatic back arrow; this returns to the More menu.
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/more'),
        ),
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(
                    name: profile == null
                        ? (user?.name ?? '')
                        : '${profile.firstName} ${profile.lastName}'.trim(),
                    email: user?.email ?? '',
                  ),
                  const SizedBox(height: 20),
                  if (profile != null) _AccountCard(profile: profile),
                  const SizedBox(height: 16),
                  const LocationSettingsCard(),
                  const SizedBox(height: 16),
                  const ReputationCard(),
                  const SizedBox(height: 16),
                  Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(
                        Icons.block_outlined,
                        color: context.colors.brand,
                      ),
                      title: const Text('Manage blocked users'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/blocked'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (context.mounted) context.go('/login');
                    },
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.email});
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: context.colors.surfaceSoft,
          child: ExcludeSemantics(
            child: Text(
              initial,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 2),
        Text(email, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.profile});
  final ReaderProfile profile;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.colors.surfaceSoft,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: SectionHeading('Account')),
            TextButton.icon(
              key: const Key('editProfile'),
              onPressed: () => context.go('/profile/edit'),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit'),
            ),
          ],
        ),
        _InfoRow(label: 'Mobile', value: profile.mobile),
        _InfoRow(label: 'Area', value: profile.address),
        _InfoRow(label: 'Genres', value: profile.preferences.join(', ')),
        if (profile.favoriteBook.isNotEmpty)
          _InfoRow(label: 'Favorite book', value: profile.favoriteBook),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value),
      ],
    ),
  );
}
