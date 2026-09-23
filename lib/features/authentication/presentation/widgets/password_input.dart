import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.enabled = true,
    this.onSubmitted,
    this.newPassword = false,
    this.fieldKey,
  });
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final bool enabled, newPassword;
  final VoidCallback? onSubmitted;
  final Key? fieldKey;
  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  final _hidden = ValueNotifier(true);
  @override
  void dispose() {
    _hidden.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: _hidden,
    builder: (context, hidden, _) => TextFormField(
      key: widget.fieldKey,
      controller: widget.controller,
      validator: widget.validator,
      enabled: widget.enabled,
      obscureText: hidden,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: [
        widget.newPassword ? AutofillHints.newPassword : AutofillHints.password,
      ],
      textInputAction: widget.onSubmitted == null
          ? TextInputAction.next
          : TextInputAction.done,
      onFieldSubmitted: (_) => widget.onSubmitted?.call(),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          tooltip: hidden ? 'Show password' : 'Hide password',
          onPressed: widget.enabled ? () => _hidden.value = !hidden : null,
          icon: Icon(
            hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
        ),
      ),
    ),
  );
}
