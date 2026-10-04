import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/member_avatar.dart';

class RankingTile extends StatelessWidget {
  const RankingTile({
    super.key,
    required this.rank,
    required this.label,
    required this.count,
    required this.countLabel,
    this.userId,
  });

  final int rank;
  final String label;
  final int count;
  final String countLabel;

  /// Set for rows that are people (not authors), to show their photo.
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final isTopThree = rank <= 3;
    return Semantics(
      label: 'Rank $rank, $label, $count $countLabel',
      excludeSemantics: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isTopThree
              ? context.colors.goldSurface
              : context.colors.surfaceSoft,
          borderRadius: BorderRadius.circular(12),
          border: isTopThree ? Border.all(color: context.colors.gold) : null,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isTopThree
                      ? context.colors.gold
                      : context.colors.brand,
                ),
              ),
            ),
            if (userId != null) ...[
              MemberAvatar(userId: userId!, name: label, radius: 14),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '$count $countLabel',
              style: TextStyle(color: context.colors.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
