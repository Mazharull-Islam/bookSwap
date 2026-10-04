import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

class BookSwapBrand extends StatelessWidget {
  const BookSwapBrand({super.key});
  @override
  Widget build(BuildContext context) => FittedBox(
    fit: BoxFit.scaleDown,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_stories_rounded, color: context.colors.brand, size: 30),
        SizedBox(width: 10),
        Text(
          'bookswap',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            color: context.colors.brand,
          ),
        ),
      ],
    ),
  );
}
