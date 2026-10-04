import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/services/public_profile_service.dart';
import '../../../../shared/widgets/owner_label.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../books/domain/entities/book.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../../../books/presentation/widgets/book_list_tile.dart';
import '../../../books/presentation/widgets/genre_pill_list.dart';
import '../../../borrow_requests/domain/repositories/request_repository.dart';
import '../../../borrow_requests/presentation/providers/request_providers.dart';
import '../../../location/domain/owner_distance.dart';
import '../../../location/presentation/providers/location_providers.dart';
import '../../domain/book_group.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../../reviews/presentation/widgets/reviews_section.dart';
import '../../../books/domain/book_genres.dart';

Future<void> showBookGroupDetailDialog(BuildContext context, BookGroup group) {
  return showDialog(
    context: context,
    builder: (context) => _BookGroupDetailDialog(group: group),
  );
}

class _BookGroupDetailDialog extends ConsumerStatefulWidget {
  const _BookGroupDetailDialog({required this.group});
  final BookGroup group;

  @override
  ConsumerState<_BookGroupDetailDialog> createState() =>
      _BookGroupDetailDialogState();
}

class _BookGroupDetailDialogState
    extends ConsumerState<_BookGroupDetailDialog> {
  final _sending = <String>{};
  final _sent = <String>{};

  Future<void> _request(Book listing) async {
    setState(() => _sending.add(listing.id));
    try {
      await ref.read(sendBorrowRequestProvider)(
        book: listing,
        borrowerId: ref.read(currentUserProvider).id,
      );
      if (mounted) setState(() => _sent.add(listing.id));
    } on RequestValidationFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _sending.remove(listing.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final book = group.representative;
    final genres = bookGenreList(book.genre);
    final myLocation = ref.watch(myLocationProvider);
    final profiles =
        ref.watch(allPublicProfilesProvider).valueOrNull ??
        const <String, PublicProfile>{};
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 620),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 12, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Close',
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BookCoverImage(
                        url: book.coverPhotoUrl,
                        width: 140,
                        height: 200,
                        borderRadius: 14,
                        iconSize: 40,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        book.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (book.author.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.colors.textMuted),
                        ),
                      ],
                      if (genres.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        GenrePillList(
                          genres: genres,
                          alignment: WrapAlignment.center,
                        ),
                      ],
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SectionHeading(
                          group.ownerCount == 1
                              ? 'Available from 1 member'
                              : 'Available from ${group.ownerCount} members',
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...group.listings.map(
                        (listing) => _listingCard(
                          listing,
                          distanceToOwnerKm(
                            myLocation: myLocation,
                            ownerLocation: profiles[listing.ownerId],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ReviewsSection(matchKey: group.key),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listingCard(Book listing, double? distanceKm) {
    final canRequest = listing.status == BookStatus.available;
    final sending = _sending.contains(listing.id);
    final sent = _sent.contains(listing.id);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.colors.surfaceSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OwnerLabel(
                  ownerId: listing.ownerId,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Chip(
                label: Text(
                  bookStatusLabel(listing.status),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: bookStatusColor(listing.status),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Condition: ${listing.condition}',
            style: TextStyle(color: context.colors.textMuted),
          ),
          if (distanceKm != null)
            Text(
              distanceKm < 1
                  ? 'Less than 1 km away'
                  : '${distanceKm.round()} km away',
              style: TextStyle(color: context.colors.textMuted),
            ),
          if (canRequest) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: sent
                  ? const OutlinedButton(
                      onPressed: null,
                      child: Text('Requested ✓'),
                    )
                  : PrimaryButton(
                      label: 'Request to borrow',
                      onPressed: () => _request(listing),
                      loading: sending,
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
