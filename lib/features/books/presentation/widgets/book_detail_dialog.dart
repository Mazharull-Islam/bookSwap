import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../domain/models/book.dart';
import 'book_cover_image.dart';
import 'book_list_tile.dart';
import 'genre_pill_list.dart';

Future<void> showBookDetailDialog(
  BuildContext context, {
  required Book book,
  required VoidCallback onEdit,
}) {
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
                      if (book.description.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Synopsis',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: forest,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          book.description,
                          style: const TextStyle(height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Edit',
                      onPressed: () {
                        Navigator.of(context).pop();
                        onEdit();
                      },
                    ),
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
