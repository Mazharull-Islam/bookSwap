import 'package:flutter/material.dart';
import 'book_cover_image.dart';
import 'genre_pill_list.dart';
import '../../../../app/app_colors.dart';

/// Summary of the book chosen from title-search suggestions (or the book
/// being edited), shown between the title field and the condition/description
/// inputs so the user can confirm what they picked.
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
      color: context.colors.surfaceSoft,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookCoverImage(
          url: coverUrl,
          width: 56,
          height: 80,
          iconSize: 24,
          placeholderColor: context.colors.surface,
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
                  style: TextStyle(color: context.colors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (genres.isNotEmpty) ...[
                const SizedBox(height: 8),
                GenrePillList(genres: genres),
              ],
              if (publishedYear != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Published $publishedYear',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}
