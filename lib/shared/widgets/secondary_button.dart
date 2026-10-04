import 'package:flutter/material.dart';
import 'inline_spinner.dart';

/// A lower-emphasis action next to (or instead of) a [PrimaryButton]. Looks
/// come from the app theme. An [icon] puts a leading icon beside the label.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    this.buttonKey,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  final Key? buttonKey;
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Shows a small spinner instead of the label and ignores taps.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final action = loading ? null : onPressed;
    if (loading) {
      return OutlinedButton(
        key: buttonKey,
        onPressed: action,
        child: const InlineSpinner(),
      );
    }
    return icon == null
        ? OutlinedButton(key: buttonKey, onPressed: action, child: Text(label))
        : OutlinedButton.icon(
            key: buttonKey,
            onPressed: action,
            icon: Icon(icon),
            label: Text(label),
          );
  }
}
