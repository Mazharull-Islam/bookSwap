import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class BookSwapBrand extends StatelessWidget {
  const BookSwapBrand({super.key});
  @override
  Widget build(BuildContext context) => const FittedBox(
    fit: BoxFit.scaleDown,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_stories_rounded, color: forest, size: 30),
        SizedBox(width: 10),
        Text(
          'bookswap',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            color: forest,
          ),
        ),
      ],
    ),
  );
}
