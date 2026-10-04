import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../../../shared/domain/period.dart';
import '../../../../shared/widgets/book_cover_image.dart';
import '../../../books/domain/book_genres.dart';
import '../../../../shared/widgets/genre_pill_list.dart';
import '../../../leaderboard/presentation/providers/leaderboard_providers.dart';
import '../../domain/entities/reading_entry.dart';
import '../providers/reading_providers.dart';
import 'reading_status.dart';
import '../../../../app/app_colors.dart';

Future<void> showReadingEntryDialog(BuildContext context, ReadingEntry entry) {
  return showDialog(
    context: context,
    builder: (context) => _ReadingEntryDialog(entry: entry),
  );
}

class _ReadingEntryDialog extends ConsumerStatefulWidget {
  const _ReadingEntryDialog({required this.entry});
  final ReadingEntry entry;

  @override
  ConsumerState<_ReadingEntryDialog> createState() =>
      _ReadingEntryDialogState();
}

class _ReadingEntryDialogState extends ConsumerState<_ReadingEntryDialog> {
  late ReadingStatus _status = widget.entry.status;
  late int? _rating = widget.entry.rating;
  late final _review = TextEditingController(text: widget.entry.review);
  bool _saving = false;

  @override
  void dispose() {
    _review.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final justFinishedReading =
        widget.entry.status != ReadingStatus.read &&
        _status == ReadingStatus.read;
    await ref.read(updateReadingEntryProvider)(
      widget.entry.copyWith(
        status: _status,
        rating: _status == ReadingStatus.read ? _rating : null,
        review: _status == ReadingStatus.read ? _review.text.trim() : '',
      ),
    );
    // Only on the transition into Read, not every edit of an already-Read
    // entry, so re-saving a rating/review doesn't double-count on the
    // leaderboard (SRS §3.11).
    if (justFinishedReading) {
      final me = ref.read(currentUserProvider);
      await ref.read(recordReadActivityProvider)(
        userId: me.id,
        userName: me.displayName,
        author: widget.entry.author,
        genre: widget.entry.genre.isEmpty ? null : widget.entry.genre,
        periodId: currentPeriodId(),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _remove() async {
    setState(() => _saving = true);
    await ref.read(removeReadingEntryProvider)(widget.entry.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  BookCoverImage(
                    url: widget.entry.coverUrl,
                    width: 44,
                    height: 60,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.entry.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (widget.entry.author.isNotEmpty)
                          Text(
                            widget.entry.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: context.colors.textMuted),
                          ),
                        if (widget.entry.publishedYear != null)
                          Text(
                            'Published ${widget.entry.publishedYear}',
                            style: TextStyle(
                              color: context.colors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (bookGenreList(widget.entry.genre).isNotEmpty) ...[
                const SizedBox(height: 12),
                GenrePillList(genres: bookGenreList(widget.entry.genre)),
              ],
              if (widget.entry.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  widget.entry.description,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.colors.textMuted),
                ),
              ],
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                children: ReadingStatus.values
                    .map(
                      (status) => ChoiceChip(
                        label: Text(readingStatusLabel(status)),
                        selected: _status == status,
                        onSelected: _saving
                            ? null
                            : (_) => setState(() => _status = status),
                      ),
                    )
                    .toList(),
              ),
              if (_status == ReadingStatus.read) ...[
                const SizedBox(height: 20),
                Text(
                  'Your rating',
                  style: TextStyle(color: context.colors.textMuted),
                ),
                const SizedBox(height: 6),
                StarRating(
                  rating: _rating,
                  size: 28,
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _rating = value),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _review,
                  enabled: !_saving,
                  maxLines: 3,
                  label: 'Review (optional)',
                ),
              ],
              const SizedBox(height: 20),
              OverflowBar(
                alignment: MainAxisAlignment.spaceBetween,
                overflowAlignment: OverflowBarAlignment.end,
                spacing: 8,
                overflowSpacing: 8,
                children: [
                  TextButton(
                    onPressed: _saving ? null : _remove,
                    child: const Text('Remove'),
                  ),
                  TextButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  PrimaryButton(
                    label: 'Save',
                    onPressed: _save,
                    loading: _saving,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
