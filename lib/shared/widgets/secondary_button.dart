import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    this.buttonKey,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final Key? buttonKey;
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => icon == null
      ? OutlinedButton(key: buttonKey, onPressed: onPressed, child: Text(label))
      : OutlinedButton.icon(
          key: buttonKey,
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
        );
}
