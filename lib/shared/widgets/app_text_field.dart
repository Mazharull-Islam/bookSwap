import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.fieldKey,
    this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.autofillHints,
    this.enabled = true,
    this.autocorrect = true,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.focusNode,
  });

  final Key? fieldKey;
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final bool autocorrect;
  final IconData? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) => TextFormField(
    key: fieldKey,
    controller: controller,
    focusNode: focusNode,
    enabled: enabled,
    validator: validator,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    maxLines: maxLines,
    autofillHints: autofillHints,
    autocorrect: autocorrect,
    onFieldSubmitted: onFieldSubmitted,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      errorMaxLines: 3,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      prefixText: prefixText,
      suffixIcon: suffixIcon,
    ),
  );
}
