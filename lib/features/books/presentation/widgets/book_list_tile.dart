import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../domain/models/book.dart';

String bookStatusLabel(BookStatus status) => switch (status) {
  BookStatus.available => 'Available',
  BookStatus.requested => 'Requested',
  BookStatus.lent => 'Lent out',
  BookStatus.returned => 'Returned',
};

Color bookStatusColor(BookStatus status) => switch (status) {
  BookStatus.available => forest,
  BookStatus.requested => const Color(0xFFB16C46),
  BookStatus.lent => const Color(0xFF3D6FA5),
  BookStatus.returned => const Color(0xFF7A7A7A),
};

List<String> bookGenreList(String genre) => genre.trim().isEmpty
    ? const []
    : genre.split(',').map((g) => g.trim()).where((g) => g.isNotEmpty).toList();

class BookListTile extends StatelessWidget {
  const BookListTile({
    super.key,
    required this.book,
    required this.onTap,
    required this.onDelete,
  });
  final Book book;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: book.coverPhotoUrl != null
            ? Image.network(
                book.coverPhotoUrl!,
                width: 48,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholderCover(),
              )
            : _placeholderCover(),
      ),
      title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${book.author} · ${book.genre}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            label: Text(
              bookStatusLabel(book.status),
              style: const TextStyle(fontSize: 11, color: Colors.white),
            ),
            backgroundColor: bookStatusColor(book.status),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            tooltip: 'Remove',
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    ),
  );

  Widget _placeholderCover() => Container(
    width: 48,
    height: 64,
    color: const Color(0xFFE9EEDF),
    child: const Icon(Icons.menu_book_outlined, color: forest, size: 22),
  );
}
