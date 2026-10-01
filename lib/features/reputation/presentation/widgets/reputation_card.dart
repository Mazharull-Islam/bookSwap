import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../../domain/models/achievement_badge.dart';
import '../providers/reputation_providers.dart';

class ReputationCard extends ConsumerWidget {
  const ReputationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reliability = ref.watch(reliabilityStatsProvider);
    final badges = ref.watch(earnedBadgesProvider);
    final percent = reliability.percent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEDF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reputation',
            style: TextStyle(fontWeight: FontWeight.w700, color: forest),
          ),
          const SizedBox(height: 8),
          if (percent == null)
            const Text(
              'Not enough history yet — complete a loan to build your reputation.',
              style: TextStyle(color: Color(0xFF617065)),
            )
          else
            Text(
              '${percent.round()}% on-time · ${reliability.completed} '
              '${reliability.completed == 1 ? 'loan' : 'loans'} completed',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          if (badges.isNotEmpty) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: badges
                  .map((b) => _BadgeChip(info: badgeCatalog[b]!))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.info});
  final BadgeInfo info;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: info.description,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD6DED5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(info.emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            info.label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
