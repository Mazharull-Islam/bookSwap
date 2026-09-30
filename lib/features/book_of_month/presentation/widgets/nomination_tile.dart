import 'package:flutter/material.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../../domain/models/book_of_month_nomination.dart';

class NominationTile extends StatelessWidget {
  const NominationTile({
    super.key,
    required this.nomination,
    required this.voteCount,
    required this.isLeader,
    required this.isMyVote,
    required this.onVote,
  });

  final BookOfMonthNomination nomination;
  final int voteCount;
  final bool isLeader;
  final bool isMyVote;
  final VoidCallback onVote;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isLeader ? const Color(0xFFFBF1DC) : const Color(0xFFE9EEDF),
      borderRadius: BorderRadius.circular(12),
      border: isLeader ? Border.all(color: const Color(0xFFCB9A3B)) : null,
    ),
    child: Row(
      children: [
        BookCoverImage(url: nomination.coverUrl, width: 44, height: 60),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLeader)
                const Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 14,
                      color: Color(0xFFCB9A3B),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Leading',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFCB9A3B),
                      ),
                    ),
                  ],
                ),
              Text(
                nomination.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (nomination.author.isNotEmpty)
                Text(
                  nomination.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF617065)),
                ),
              Text(
                'Nominated by ${nomination.nominatedByName} · $voteCount '
                '${voteCount == 1 ? 'vote' : 'votes'}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF9AA69C)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        isMyVote
            ? const OutlinedButton(onPressed: null, child: Text('Voted ✓'))
            : PrimaryButton(label: 'Vote', onPressed: onVote),
      ],
    ),
  );
}
