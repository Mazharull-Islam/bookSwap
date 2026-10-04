import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/inline_spinner.dart';
import '../../domain/entities/book.dart';

/// The fields a member fills in themselves: the book's condition, what it is
/// worth, and an optional description.
class BookDetailsFields extends StatelessWidget {
  const BookDetailsFields({
    super.key,
    required this.condition,
    required this.onConditionChanged,
    required this.estimatedValue,
    required this.description,
    required this.fetchingSynopsis,
    required this.enabled,
  });

  final String condition;
  final ValueChanged<String> onConditionChanged;
  final TextEditingController estimatedValue;
  final TextEditingController description;

  /// A synopsis is being looked up and will fill the description.
  final bool fetchingSynopsis;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DropdownButtonFormField<String>(
        initialValue: condition,
        decoration: const InputDecoration(labelText: 'Condition'),
        items: bookConditionOptions
            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList(),
        onChanged: enabled ? (value) => onConditionChanged(value!) : null,
      ),
      const SizedBox(height: 16),
      AppTextField(
        controller: estimatedValue,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        label: 'Estimated value',
        prefixText: '৳ ',
        validator: (v) {
          final parsed = double.tryParse(v ?? '');
          if (parsed == null) return 'Enter a number.';
          if (parsed < 0) return 'Value can\'t be negative.';
          return null;
        },
      ),
      const SizedBox(height: 16),
      AppTextField(
        controller: description,
        enabled: enabled,
        maxLines: 2,
        label: 'Description (optional)',
        suffixIcon: fetchingSynopsis
            ? const Padding(padding: EdgeInsets.all(12), child: InlineSpinner())
            : null,
      ),
    ],
  );
}
