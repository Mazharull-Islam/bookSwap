import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/utils/cached_image.dart';

class BookCoverImage extends StatelessWidget {
  const BookCoverImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.iconSize = 22,
    this.placeholderColor,
  });

  final String? url;

  /// Omit to fill the parent (e.g. inside an [Expanded] or a sized [Stack]).
  final double? width;
  final double? height;
  final double borderRadius;
  final double iconSize;
  final Color? placeholderColor;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: url != null
        ? Image(
            image: cachedImage(url!),
            width: width,
            height: height,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
            // A plain tile while the cover loads (no icon, so a book that does
            // have a cover doesn't flash the "no cover" icon first).
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                wasSynchronouslyLoaded || frame != null
                ? child
                : Container(
                    width: width,
                    height: height,
                    color: placeholderColor ?? context.colors.surfaceSoft,
                  ),
            errorBuilder: (context, error, stackTrace) => _placeholder(context),
          )
        : _placeholder(context),
  );

  Widget _placeholder(BuildContext context) => Container(
    width: width,
    height: height,
    color: placeholderColor ?? context.colors.surfaceSoft,
    child: Icon(
      Icons.menu_book_outlined,
      color: context.colors.brand,
      size: iconSize,
    ),
  );
}
