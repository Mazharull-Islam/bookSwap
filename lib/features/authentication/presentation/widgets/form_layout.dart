import 'package:flutter/material.dart';
import '../../../../shared/widgets/section_heading.dart';

/// Two form fields side by side when there's room, stacked when there isn't.
class FieldPair extends StatelessWidget {
  const FieldPair(this.first, this.second, {super.key});
  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 560) {
        return Column(children: [first, const SizedBox(height: 18), second]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: first),
          const SizedBox(width: 18),
          Expanded(child: second),
        ],
      );
    },
  );
}

/// The title and one-line explanation that start a section of a long form.
class FormSectionHeading extends StatelessWidget {
  const FormSectionHeading(this.title, this.subtitle, {super.key});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeading(title, fontSize: 20),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    ),
  );
}
