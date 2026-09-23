import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class BookCoverImage extends StatelessWidget {
  const BookCoverImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.iconSize = 22,
    this.placeholderColor = const Color(0xFFE9EEDF),
  });

  final String? url;

  /// Omit to fill the parent (e.g. inside an [Expanded] or a sized [Stack]).
  final double? width;
  final double? height;
  final double borderRadius;
  final double iconSize;
  final Color placeholderColor;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: url != null
        ? Image.network(
            url!,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _placeholder(),
          )
        : _placeholder(),
  );

  Widget _placeholder() => Container(
    width: width,
    height: height,
    color: placeholderColor,
    child: Icon(Icons.menu_book_outlined, color: forest, size: iconSize),
  );
}
