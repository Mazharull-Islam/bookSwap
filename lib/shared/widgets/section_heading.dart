import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

/// A section title that screen readers can jump to as a heading.
class SectionHeading extends StatelessWidget {
  const SectionHeading(this.text, {super.key, this.fontSize});
  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: context.colors.brand,
        fontSize: fontSize,
      ),
    ),
  );
}
