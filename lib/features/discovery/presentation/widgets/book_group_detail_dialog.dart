import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../books/presentation/widgets/book_cover_image.dart';
import '../../../books/presentation/widgets/book_list_tile.dart';
import '../../../books/presentation/widgets/genre_pill_list.dart';
import '../../domain/book_group.dart';
import 'owner_label.dart';

/// A non-full-screen "quick look" at every listing of a book (one per
/// owner/edition). Shows who owns each copy (first name only, via the
/// member-readable public profile) — but never contact details, which per
/// the SRS only get revealed once a borrow request is accepted.
Future<void> showBookGroupDetailDialog(BuildContext context, BookGroup group) {
  final book = group.representative;
  final genres = bookGenreList(book.genre);
  return showDialog(
    context: context,
    builder: (context) => Dialog(
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
                          style: const TextStyle(color: Color(0xFF617065)),
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
                        child: Text(
                          group.ownerCount == 1
                              ? 'Available from 1 member'
                              : 'Available from ${group.ownerCount} members',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: forest,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...group.listings.map(
                        (listing) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9EEDF),
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      bookStatusLabel(listing.status),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: bookStatusColor(
                                      listing.status,
                                    ),
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Condition: ${listing.condition}',
                                style: const TextStyle(
                                  color: Color(0xFF617065),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
