import 'package:flutter/material.dart';
import '../../domain/entities/registration.dart';

/// The gender choice on the registration and edit-profile forms.
class GenderDropdown extends StatelessWidget {
  const GenderDropdown({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    initialValue: value,
    isExpanded: true,
    decoration: const InputDecoration(labelText: 'Gender'),
    items: genders
        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
        .toList(),
    onChanged: enabled
        ? (selected) {
            if (selected != null) onChanged(selected);
          }
        : null,
  );
}
