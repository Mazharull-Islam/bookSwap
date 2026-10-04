import 'package:flutter/material.dart';
import 'book_cover_image.dart';

/// One row in the title-search suggestion dropdown. Takes plain fields
/// rather than a service's BookMetadata type, so it doesn't care which
/// provider (Open Library, Google Books, ...) produced the suggestion.
class BookSuggestionTile extends StatelessWidget {
  const BookSuggestionTile({
    super.key,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.onTap,
  });

  final String title;
  final String author;
  final String? coverUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: BookCoverImage(
      url: coverUrl,
      width: 40,
      height: 56,
      borderRadius: 6,
      iconSize: 18,
    ),
    title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
    subtitle: author.isEmpty
        ? null
        : Text(author, maxLines: 1, overflow: TextOverflow.ellipsis),
    onTap: onTap,
  );
}
