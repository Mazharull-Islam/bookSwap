import 'package:flutter/material.dart';
import '../../../../shared/widgets/inline_spinner.dart';

/// "Refresh genres & synopsis" for a book already on the shelf.
class RefreshDetailsButton extends StatelessWidget {
  const RefreshDetailsButton({
    super.key,
    required this.refreshing,
    required this.enabled,
    required this.onPressed,
  });

  final bool refreshing;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: TextButton.icon(
      key: const Key('refreshDetails'),
      onPressed: refreshing || !enabled ? null : onPressed,
      icon: refreshing ? const InlineSpinner() : const Icon(Icons.refresh),
      label: const Text('Refresh genres & synopsis'),
    ),
  );
}
