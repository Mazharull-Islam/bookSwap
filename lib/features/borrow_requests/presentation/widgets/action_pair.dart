import 'package:flutter/material.dart';

/// Two buttons side by side when they fit, stacked full-width when they don't
/// (large text, narrow screens).
class ActionPair extends StatelessWidget {
  const ActionPair({super.key, required this.secondary, required this.primary});
  final Widget secondary;
  final Widget primary;

  @override
  Widget build(BuildContext context) => OverflowBar(
    alignment: MainAxisAlignment.end,
    overflowAlignment: OverflowBarAlignment.end,
    spacing: 8,
    overflowSpacing: 8,
    children: [secondary, primary],
  );
}
