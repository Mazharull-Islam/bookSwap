import 'package:flutter/material.dart';

/// The main action on a screen or dialog. Looks come from the app theme.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.buttonKey,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.loadingSemanticLabel,
    this.destructive = false,
  });

  final Key? buttonKey;
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final String? loadingSemanticLabel;

  /// Colours the button as a warning, for actions like "Decline" or "Delete".
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton(
      key: buttonKey,
      style: destructive
          ? FilledButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
            )
          : null,
      onPressed: loading ? null : onPressed,
      child: loading
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                semanticsLabel: loadingSemanticLabel,
              ),
            )
          : Text(label),
    );
  }
}
