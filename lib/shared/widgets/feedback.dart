import 'package:flutter/material.dart';
import 'primary_button.dart';

/// A brief message at the bottom of the screen ("Profile updated.").
void showMessage(BuildContext context, String message) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));

/// Asks the member to confirm before something they can't easily undo.
/// Returns true only if they press the confirm button; cancelling or tapping
/// outside the dialog returns false. [destructive] colours the confirm button
/// as a warning.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            PrimaryButton(
              label: confirmLabel,
              destructive: destructive,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ) ??
      false;
}
