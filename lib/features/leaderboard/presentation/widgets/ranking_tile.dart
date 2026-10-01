import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class RankingTile extends StatelessWidget {
  const RankingTile({
    super.key,
    required this.rank,
    required this.label,
    required this.count,
    required this.countLabel,
  });

  final int rank;
  final String label;
  final int count;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    final isTopThree = rank <= 3;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isTopThree ? const Color(0xFFFBF1DC) : const Color(0xFFE9EEDF),
        borderRadius: BorderRadius.circular(12),
        border: isTopThree ? Border.all(color: const Color(0xFFCB9A3B)) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isTopThree ? const Color(0xFFCB9A3B) : forest,
              ),
            ),
          ),
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
            style: const TextStyle(color: Color(0xFF617065), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
