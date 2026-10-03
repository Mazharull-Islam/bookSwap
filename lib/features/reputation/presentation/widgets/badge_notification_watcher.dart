import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../domain/badge_notifications.dart';
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
    ref.listen<BadgeState>(badgeStateProvider, (previous, next) {
      // The badge list is built from three separate data sources that arrive
      // at different times on every launch and sign-in. Acting on a partial
      // list is what made old badges look newly earned.
      if (!next.ready) return;
      final userId = ref.read(currentUserProvider).id;
      if (userId == 'placeholder-user') return;
      final repo = ref.read(seenBadgesRepositoryProvider);

      final plan = planBadgeNotifications(
        hasBaseline: repo.hasBaseline(userId),
        seen: repo.getSeen(userId),
        earned: next.badges,
      );
      repo.setSeen(userId, plan.store);
      for (var i = 0; i < plan.announce.length; i++) {
        final info = badgeCatalog[plan.announce[i]]!;
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
