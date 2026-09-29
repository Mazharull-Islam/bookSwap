import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../../domain/models/reading_entry.dart';
import '../providers/reading_providers.dart';
import 'reading_status.dart';

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
    await ref.read(updateReadingEntryProvider)(
      widget.entry.copyWith(
        status: _status,
        rating: _status == ReadingStatus.read ? _rating : null,
        review: _status == ReadingStatus.read ? _review.text.trim() : '',
      ),
    );
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
                            style: const TextStyle(color: Color(0xFF617065)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
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
                const Text(
                  'Your rating',
                  style: TextStyle(color: Color(0xFF617065)),
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
              Row(
                children: [
                  TextButton(
                    onPressed: _saving ? null : _remove,
                    child: const Text('Remove'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
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
