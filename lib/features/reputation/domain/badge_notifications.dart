import 'entities/achievement_badge.dart';

class BadgeNotificationPlan {
  const BadgeNotificationPlan({required this.announce, required this.store});

  /// Badges to toast for, in order.
  final List<AchievementBadge> announce;

  /// What to persist as "already seen" — never smaller than [seen] was.
  final Set<String> store;
}

/// Decides which earned badges deserve a toast.
///
/// [hasBaseline] is false the first time this device sees the member: their
/// existing badges are recorded silently. Afterwards only badges missing from
/// [seen] are announced, and the stored set only ever grows — shrinking it
/// (because some data hadn't loaded yet) would make an old badge look new
/// the next time it reappeared.
BadgeNotificationPlan planBadgeNotifications({
  required bool hasBaseline,
  required Set<String> seen,
  required List<AchievementBadge> earned,
}) {
  final earnedNames = earned.map((b) => b.name).toSet();
  if (!hasBaseline) {
    return BadgeNotificationPlan(announce: const [], store: earnedNames);
  }
  return BadgeNotificationPlan(
    announce: earned.where((b) => !seen.contains(b.name)).toList(),
    store: {...seen, ...earnedNames},
  );
}
