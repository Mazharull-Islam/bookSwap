import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.buttonKey,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.loadingSemanticLabel,
  });

  final Key? buttonKey;
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final String? loadingSemanticLabel;

  @override
  Widget build(BuildContext context) => FilledButton(
    key: buttonKey,
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
