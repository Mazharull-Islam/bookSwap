import 'package:flutter/material.dart';

/// A small spinner for inside a button, field or row ("looking it up…").
class InlineSpinner extends StatelessWidget {
  const InlineSpinner({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 16,
    width: 16,
    child: CircularProgressIndicator(strokeWidth: 2),
  );
}
