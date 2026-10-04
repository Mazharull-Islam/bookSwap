import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

/// What a list or tab shows when there is nothing to list: an icon and a short
/// message, centred, with an optional heading above the message.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.title,
  });

  final IconData icon;
  final String message;

  /// A bolder first line, for empty states that also tell the member what to
  /// do next ("Your shelf is empty" / "Add a book to get started").
  final String? title;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: title == null ? 56 : 64,
            color: context.colors.brand,
          ),
          const SizedBox(height: 16),
          if (title != null) ...[
            Text(
              title!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.textMuted),
          ),
        ],
      ),
    ),
  );
}
