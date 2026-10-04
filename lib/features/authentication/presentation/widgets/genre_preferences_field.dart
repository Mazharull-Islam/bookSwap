import 'package:flutter/material.dart';
import '../../domain/entities/registration.dart';

/// "Book preferences": a wrap of genre chips, at least one of which must be
/// chosen. Used when registering and when editing a profile.
class GenrePreferencesField extends StatelessWidget {
  const GenrePreferencesField({
    super.key,
    required this.initialValue,
    required this.enabled,
    required this.onChanged,
  });

  final List<String> initialValue;
  final bool enabled;
  final ValueChanged<List<String>> onChanged;

  @override
  Widget build(BuildContext context) => FormField<List<String>>(
    initialValue: initialValue,
    validator: (v) =>
        v == null || v.isEmpty ? 'Choose at least one book preference.' : null,
    builder: (field) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Book preferences',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            for (final genre in bookGenres)
              FilterChip(
                label: Text(genre),
                selected: field.value!.contains(genre),
                onSelected: enabled
                    ? (selected) {
                        final next = [...field.value!];
                        if (selected) {
                          next.add(genre);
                        } else {
                          next.remove(genre);
                        }
                        onChanged(next);
                        field.didChange(next);
                      }
                    : null,
              ),
          ],
        ),
        if (field.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              field.errorText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    ),
  );
}
