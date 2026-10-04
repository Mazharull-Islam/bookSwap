import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../../borrow_requests/domain/entities/borrow_request.dart';
import '../../../discovery/presentation/providers/discovery_providers.dart';
import '../../domain/entities/book_review.dart';
import '../providers/review_providers.dart';
import 'review_dialog.dart';
import '../../../../shared/domain/match_key.dart';
import '../../../../shared/widgets/secondary_button.dart';

/// Shown on a returned loan you borrowed: rate it, or see/edit what you said.
class ReviewLoanAction extends ConsumerWidget {
  const ReviewLoanAction({super.key, required this.request});
  final BorrowRequest request;

  String _matchKey(WidgetRef ref) {
    final books = ref.read(allBooksProvider).valueOrNull ?? const [];
    for (final book in books) {
      if (book.id == request.bookId) {
        return workMatchKey(
          workKey: book.workKey,
          title: book.title,
          author: book.author,
        );
      }
    }
    // The book has since left the local cache; fall back to its title.
    return workMatchKey(workKey: null, title: request.bookTitle, author: '');
  }

  void _open(BuildContext context, WidgetRef ref, BookReview? existing) =>
      showReviewDialog(
        context,
        requestId: request.id,
        bookId: request.bookId,
        bookTitle: request.bookTitle,
        matchKey: _matchKey(ref),
        existing: existing,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final existing = ref.watch(myReviewProvider(request.id));
    if (existing == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: SecondaryButton(
          buttonKey: Key('rate-${request.id}'),
          label: 'Rate this book',
          icon: Icons.star_border,
          onPressed: () => _open(context, ref, null),
        ),
      );
    }
    return Row(
      children: [
        StarRating(rating: existing.rating),
        const Spacer(),
        TextButton(
          key: Key('edit-review-${request.id}'),
          onPressed: () => _open(context, ref, existing),
          child: const Text('Edit review'),
        ),
      ],
    );
  }
}
