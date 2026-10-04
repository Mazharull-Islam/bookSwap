import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

/// A warning that the chosen book is already on the member's shelf.
class DuplicateShelfNotice extends StatelessWidget {
  const DuplicateShelfNotice({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: context.colors.warningSurface,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFE0A93A)),
    ),
    child: Row(
      children: [
        Icon(Icons.info_outline, color: context.colors.warningText, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Book already in shelf',
            style: TextStyle(color: context.colors.warningText),
          ),
        ),
      ],
    ),
  );
}
