import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../location/presentation/widgets/location_settings_card.dart';
import '../../../reputation/presentation/widgets/reputation_card.dart';
import '../providers/auth_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;
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
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 72,
                    color: forest,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome, ${user?.name ?? ''}.',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You’re an official BookSwap member.\nYour next chapter starts here.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const LocationSettingsCard(),
                  const SizedBox(height: 16),
                  const ReputationCard(),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context.push('/blocked'),
                    child: const Text('Manage blocked users'),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Sign out',
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (context.mounted) context.go('/login');
                    },
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
