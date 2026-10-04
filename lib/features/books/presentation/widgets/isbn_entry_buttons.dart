import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../../shared/widgets/secondary_button.dart';

/// The two ways to find a book by ISBN: scanning its barcode (phones only) or
/// typing the number.
class IsbnEntryButtons extends StatelessWidget {
  const IsbnEntryButtons({
    super.key,
    required this.enabled,
    required this.onScan,
    required this.onType,
  });

  final bool enabled;
  final VoidCallback onScan;
  final VoidCallback onType;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      if (!kIsWeb)
        SecondaryButton(
          buttonKey: const Key('scanIsbn'),
          label: 'Scan barcode',
          icon: Icons.qr_code_scanner,
          onPressed: enabled ? onScan : null,
        ),
      SecondaryButton(
        buttonKey: const Key('typeIsbn'),
        label: 'Type an ISBN',
        icon: Icons.dialpad,
        onPressed: enabled ? onType : null,
      ),
    ],
  );
}
