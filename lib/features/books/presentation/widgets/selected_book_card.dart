import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class SelectedBookCard extends StatelessWidget {
  const SelectedBookCard({
    super.key,
    required this.title,
    required this.author,
    this.coverUrl,
    this.genres = const [],
    this.publishedYear,
  });

  final String title;
  final String author;
  final String? coverUrl;
  final List<String> genres;
  final String? publishedYear;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFE9EEDF),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: coverUrl != null
              ? Image.network(
                  coverUrl!,
                  width: 56,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _placeholderCover(),
                )
              : _placeholderCover(),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (author.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  author,
                  style: const TextStyle(color: Color(0xFF617065)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (genres.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
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
              if (publishedYear != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Published $publishedYear',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF617065),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );

  Widget _placeholderCover() => Container(
    width: 56,
    height: 80,
    color: Colors.white,
    child: const Icon(Icons.menu_book_outlined, color: forest, size: 24),
  );
}
