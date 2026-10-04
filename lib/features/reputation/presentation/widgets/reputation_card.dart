import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../domain/entities/achievement_badge.dart';
import '../providers/reputation_providers.dart';
import '../../../../shared/widgets/section_heading.dart';

class ReputationCard extends ConsumerWidget {
  const ReputationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reliability = ref.watch(reliabilityStatsProvider);
    final badges = ref.watch(earnedBadgesProvider);
    final percent = reliability.percent;
    final condition = ref.watch(conditionRecordProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceSoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading('Reputation'),
          const SizedBox(height: 8),
          if (percent == null)
            Text(
              'Not enough history yet — complete a loan to build your reputation.',
              style: TextStyle(color: context.colors.textMuted),
            )
          else
            Text(
              '${percent.round()}% on-time · ${reliability.completed} '
              '${reliability.completed == 1 ? 'loan' : 'loans'} completed',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          if (condition.recorded > 0) ...[
            const SizedBox(height: 4),
            Text(
              'Books returned as good as lent: '
              '${condition.recorded - condition.flagged} of '
              '${condition.recorded}',
              style: TextStyle(color: context.colors.textMuted),
            ),
          ],
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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.colors.border),
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
