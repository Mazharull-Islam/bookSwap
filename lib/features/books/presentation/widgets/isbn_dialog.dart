import 'package:flutter/material.dart';
import '../../../../core/utils/isbn.dart';
import '../../../../shared/widgets/primary_button.dart';

/// Asks for an ISBN-10 or ISBN-13 and returns it as an ISBN-13, or null if the
/// member cancels.
Future<String?> showIsbnDialog(BuildContext context) =>
    showDialog<String>(context: context, builder: (_) => const _IsbnDialog());

class _IsbnDialog extends StatefulWidget {
  const _IsbnDialog();

  @override
  State<_IsbnDialog> createState() => _IsbnDialogState();
}

class _IsbnDialogState extends State<_IsbnDialog> {
  final _form = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_form.currentState!.validate()) {
      Navigator.of(context).pop(toIsbn13(_controller.text));
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Type an ISBN'),
    content: Form(
      key: _form,
      child: TextFormField(
        key: const Key('isbnField'),
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          labelText: 'ISBN',
          hintText: '978-0-441-17271-9',
          helperText: 'The 10 or 13 digit number above the barcode.',
        ),
        validator: (v) => toIsbn13(v) == null
            ? 'Enter a valid ISBN (10 or 13 digits).'
            : null,
        onFieldSubmitted: (_) => _submit(),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      PrimaryButton(label: 'Find book', onPressed: _submit),
    ],
  );
}
