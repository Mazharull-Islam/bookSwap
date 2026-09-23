import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../domain/models/book.dart';
import 'book_list_tile.dart';

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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: book.coverPhotoUrl != null
                            ? Image.network(
                                book.coverPhotoUrl!,
                                width: 140,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _placeholderCover(),
                              )
                            : _placeholderCover(),
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
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          runSpacing: 6,
                          children: genres
                              .map(
                                (genre) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: forest,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    genre,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      if (book.description.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Align(
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
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onEdit();
                      },
                      child: const Text('Edit'),
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

Widget _placeholderCover() => Container(
  width: 140,
  height: 200,
  color: const Color(0xFFE9EEDF),
  child: const Icon(Icons.menu_book_outlined, color: forest, size: 40),
);
