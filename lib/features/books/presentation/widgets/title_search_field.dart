import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/services/open_library_service.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/book_suggestion_tile.dart';
import '../../../../shared/widgets/inline_spinner.dart';

/// The title box with its dropdown of catalogue suggestions. Tapping outside
/// dismisses the suggestions.
class TitleSearchField extends StatelessWidget {
  const TitleSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.busy,
    required this.suggestions,
    required this.onSelect,
    required this.onDismiss,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;

  /// A search or ISBN lookup is running.
  final bool busy;
  final List<BookMetadata> suggestions;
  final ValueChanged<BookMetadata> onSelect;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => TapRegion(
    onTapOutside: (_) => onDismiss(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          label: 'Title',
          suffixIcon: busy
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: InlineSpinner(),
                )
              : null,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Enter a title.' : null,
        ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 260),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: context.colors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            // Material ancestor so BookSuggestionTile's ListTile ink/background
            // isn't painted under this Container's own decoration and lost.
            child: Material(
              type: MaterialType.transparency,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return BookSuggestionTile(
                    title: suggestion.title,
                    author: suggestion.author,
                    coverUrl: suggestion.coverUrl,
                    onTap: () => onSelect(suggestion),
                  );
                },
              ),
            ),
          ),
      ],
    ),
  );
}
