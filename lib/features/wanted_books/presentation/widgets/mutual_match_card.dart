import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/owner_label.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../../domain/mutual_match.dart';

/// A detected mutual swap opportunity (SRS §3.5): shows both books side by
/// side and lets the user act on it immediately by sending a normal borrow
/// request for the other party's book — reuses the existing Borrow Requests
/// flow rather than inventing a separate "swap" transaction type.
class MutualMatchCard extends StatelessWidget {
  const MutualMatchCard({
    super.key,
    required this.match,
    required this.sending,
    required this.sent,
    required this.onRequest,
  });

  final MutualMatch match;
  final bool sending;
  final bool sent;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: context.colors.surfaceSoft,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: context.colors.brand.withValues(alpha: 0.25)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.swap_horiz, color: context.colors.brand, size: 20),
            const SizedBox(width: 6),
            Text(
              'Mutual swap match',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.colors.brand,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _BookColumn(
                label: 'They want',
                title: match.myBook.title,
                coverUrl: match.myBook.coverPhotoUrl,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.sync_alt, color: context.colors.textMuted),
            ),
            Expanded(
              child: _BookColumn(
                label: 'You want',
                title: match.theirBook.title,
                coverUrl: match.theirBook.coverPhotoUrl,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('With ', style: TextStyle(color: context.colors.textMuted)),
            OwnerLabel(
              ownerId: match.otherUserId,
              style: TextStyle(
                color: context.colors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: sent
              ? const OutlinedButton(
                  onPressed: null,
                  child: Text('Requested ✓'),
                )
              : PrimaryButton(
                  label: 'Request their book',
                  onPressed: onRequest,
                  loading: sending,
                ),
        ),
      ],
    ),
  );
}

class _BookColumn extends StatelessWidget {
  const _BookColumn({required this.label, required this.title, this.coverUrl});
  final String label;
  final String title;
  final String? coverUrl;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 12, color: context.colors.textMuted),
      ),
      const SizedBox(height: 4),
      Row(
        children: [
          BookCoverImage(url: coverUrl, width: 32, height: 44, borderRadius: 6),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    ],
  );
}
