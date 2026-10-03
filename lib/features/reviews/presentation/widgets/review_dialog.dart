import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../core/utils/friendly_error.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../application/use_cases/review_use_cases.dart';
import '../../domain/models/book_review.dart';
import '../../domain/repositories/review_repository.dart';
import '../providers/review_providers.dart';

Future<void> showReviewDialog(
  BuildContext context, {
  required String requestId,
  required String bookId,
  required String bookTitle,
  required String matchKey,
  BookReview? existing,
}) => showDialog<void>(
  context: context,
  builder: (_) => _ReviewDialog(
    requestId: requestId,
    bookId: bookId,
    bookTitle: bookTitle,
    matchKey: matchKey,
    existing: existing,
  ),
);

class _ReviewDialog extends ConsumerStatefulWidget {
  const _ReviewDialog({
    required this.requestId,
    required this.bookId,
    required this.bookTitle,
    required this.matchKey,
    required this.existing,
  });
  final String requestId;
  final String bookId;
  final String bookTitle;
  final String matchKey;
  final BookReview? existing;

  @override
  ConsumerState<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends ConsumerState<_ReviewDialog> {
  late int? _rating = widget.existing?.rating;
  late final _text = TextEditingController(text: widget.existing?.text);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final me = ref.read(currentUserProvider);
    try {
      await ref.read(submitReviewProvider)(
        existing: widget.existing,
        requestId: widget.requestId,
        reviewerId: me.id,
        reviewerName: me.displayName,
        bookId: widget.bookId,
        bookTitle: widget.bookTitle,
        matchKey: widget.matchKey,
        rating: _rating ?? 0,
        text: _text.text,
      );
      if (mounted) Navigator.of(context).pop();
    } on ReviewValidationFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      if (mounted) {
        setState(
          () => _error = friendlyError(
            e,
            fallback: 'Could not save your review. Please try again.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    setState(() => _saving = true);
    try {
      await ref.read(deleteReviewProvider)(widget.requestId);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = friendlyError(
            e,
            fallback: 'Could not delete your review. Please try again.',
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.existing == null ? 'Rate this book' : 'Your review',
      style: Theme.of(context).textTheme.titleLarge,
    ),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bookTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          StarRating(
            rating: _rating,
            size: 32,
            onChanged: _saving ? null : (v) => setState(() => _rating = v),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('reviewText'),
            controller: _text,
            enabled: !_saving,
            maxLines: 4,
            maxLength: maxReviewLength,
            decoration: const InputDecoration(
              labelText: 'Review (optional)',
              alignLabelWithHint: true,
            ),
          ),
          if (_error != null)
            Semantics(
              liveRegion: true,
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    ),
    actions: [
      OverflowBar(
        alignment: MainAxisAlignment.end,
        overflowAlignment: OverflowBarAlignment.end,
        spacing: 8,
        overflowSpacing: 8,
        children: [
          if (widget.existing != null)
            TextButton(
              key: const Key('deleteReview'),
              onPressed: _saving ? null : _delete,
              child: const Text('Delete'),
            ),
          TextButton(
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            buttonKey: const Key('saveReview'),
            label: widget.existing == null ? 'Submit' : 'Save',
            onPressed: _save,
            loading: _saving,
            loadingSemanticLabel: 'Saving',
          ),
        ],
      ),
    ],
  );
}
