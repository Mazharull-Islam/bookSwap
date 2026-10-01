import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../domain/models/achievement_badge.dart';
import '../providers/reputation_providers.dart';
import 'badge_toast.dart';

/// Wraps the authenticated shell so a badge toast can fire from wherever
/// the user happens to be — badges are earned by actions on Requests or My
/// Reading, not just by visiting Profile, where they're displayed.
class BadgeNotificationWatcher extends ConsumerWidget {
  const BadgeNotificationWatcher({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<List<AchievementBadge>>(earnedBadgesProvider, (previous, next) {
      final userId = ref.read(currentUserProvider).id;
      if (userId == 'placeholder-user') return;
      final repo = ref.read(seenBadgesRepositoryProvider);
      final currentNames = next.map((b) => b.name).toSet();

      // First time this user's badges have ever been computed on this
      // device: seed the baseline silently rather than toasting for every
      // badge they already happened to qualify for.
      if (!repo.hasBaseline(userId)) {
        repo.setSeen(userId, currentNames);
        return;
      }

      final seen = repo.getSeen(userId);
      final newlyEarned = next.where((b) => !seen.contains(b.name)).toList();
      if (newlyEarned.isEmpty) return;

      repo.setSeen(userId, currentNames);
      for (var i = 0; i < newlyEarned.length; i++) {
        final info = badgeCatalog[newlyEarned[i]]!;
        // Stagger simultaneous badges so their toasts don't stack on top
        // of one another at the same position.
        Future.delayed(Duration(milliseconds: i * 3400), () {
          if (context.mounted) showBadgeEarnedToast(context, info);
        });
      }
    });

    return child;
  }
}
