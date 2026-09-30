import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../providers/book_of_month_providers.dart';

/// Featured on Discovery per SRS §3.10 — the current period's leading
/// nominee, live (not a locked-in "final" winner until the month rolls
/// over). Nothing shown if no one's nominated anything yet this month.
class BookOfMonthBanner extends ConsumerWidget {
  const BookOfMonthBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pick = ref.watch(currentPickProvider);
    if (pick == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push('/book-of-month'),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF1DC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFCB9A3B)),
          ),
          child: Row(
            children: [
              const Icon(Icons.emoji_events, color: Color(0xFFCB9A3B)),
              const SizedBox(width: 10),
              BookCoverImage(url: pick.coverUrl, width: 32, height: 44),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Book of the Month',
                      style: TextStyle(fontSize: 11, color: Color(0xFF8A6116)),
                    ),
                    Text(
                      pick.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: forest),
            ],
          ),
        ),
      ),
    );
  }
}
