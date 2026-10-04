import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/app_colors.dart';
import '../providers/block_providers.dart';
import '../../../../shared/widgets/secondary_button.dart';

class BlockedUsersPage extends ConsumerWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocked = ref.watch(myBlockedUsersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Blocked users')),
      body: blocked.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Could not load your blocked users. Please try again.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.block_outlined,
                      size: 56,
                      color: context.colors.brand,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "You haven't blocked anyone.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.colors.textMuted),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Block someone from an incoming request to stop them '
                      'sending you new ones.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.colors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.person_off_outlined),
                  title: Text(entry.blockedName),
                  trailing: SecondaryButton(
                    label: 'Unblock',
                    onPressed: () => ref.read(unblockUserProvider)(
                      ref.read(currentUserProvider).id,
                      entry.blockedId,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
