import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../app/theme.dart';
import '../../../../core/services/google_books_service.dart';
import '../../domain/models/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../providers/book_providers.dart';
import '../widgets/selected_book_card.dart';

class AddBookPage extends ConsumerStatefulWidget {
  const AddBookPage({super.key, this.existing});
  final Book? existing;

  @override
  ConsumerState<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends ConsumerState<AddBookPage> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.existing?.title);
  late final _description = TextEditingController(
    text: widget.existing?.description,
  );
  late final _estimatedValue = TextEditingController(
    text: widget.existing?.estimatedValue.toString(),
  );
  late String _condition =
      widget.existing?.condition ?? bookConditionOptions.first;
  final _titleFocus = FocusNode();
  Timer? _debounce;
  List<BookMetadata> _suggestions = [];
  bool _searching = false;

  // Pulled from the selected suggestion (or the book being edited) rather
  // than typed directly — there's no genre/author input anymore.
  String _author = '';
  String _genre = '';
  List<String> _genres = [];
  String? _publishedYear;
  String? _coverPhotoUrl;
  String? _isbn;

  bool _saving = false;
  String? _error;

  bool get _hasSelection => _author.isNotEmpty;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _author = existing?.author ?? '';
    _genre = existing?.genre ?? '';
    _genres = _genre.isEmpty
        ? []
        : _genre.split(',').map((g) => g.trim()).toList();
    _coverPhotoUrl = existing?.coverPhotoUrl;
    _isbn = existing?.isbn;
    _title.addListener(_onTitleChanged);
  }

  void _onTitleChanged() {
    _debounce?.cancel();
    final query = _title.text;
    if (query.trim().length < 3) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() => _searching = true);
    try {
      final results = await ref
          .read(googleBooksServiceProvider)
          .searchByTitle(query);
      // Ignore a stale response if the title changed while this was in flight.
      if (mounted && _title.text == query) {
        setState(() => _suggestions = results);
      }
    } on BookLookupFailure {
      // Suggestions are a convenience; a lookup failure shouldn't block typing.
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _selectSuggestion(BookMetadata suggestion) {
    _title.text = suggestion.title;
    setState(() {
      _author = suggestion.author;
      _genres = suggestion.genres;
      _genre = suggestion.genres.join(', ');
      _publishedYear = suggestion.publishedYear;
      _coverPhotoUrl = suggestion.coverUrl;
      _isbn = suggestion.isbn;
      _suggestions = [];
    });
    _titleFocus.unfocus();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _title.removeListener(_onTitleChanged);
    _title.dispose();
    _description.dispose();
    _estimatedValue.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _saving = true;
      _error = null;
    });
    final existing = widget.existing;
    final book = Book(
      id: existing?.id ?? '',
      ownerId: existing?.ownerId ?? ref.read(currentUserProvider).id,
      title: _title.text,
      author: _author,
      genre: _genre,
      condition: _condition,
      estimatedValue: double.tryParse(_estimatedValue.text) ?? 0,
      description: _description.text,
      coverPhotoUrl: _coverPhotoUrl,
      isbn: _isbn,
      status: existing?.status ?? BookStatus.available,
    );
    try {
      if (existing == null) {
        await ref.read(addBookToShelfProvider)(book);
      } else {
        await ref.read(updateShelfBookProvider)(book);
      }
      if (mounted) Navigator.of(context).pop();
    } on BookValidationFailure catch (error) {
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _suggestionCover(String? coverUrl) => ClipRRect(
    borderRadius: BorderRadius.circular(6),
    child: coverUrl != null
        ? Image.network(
            coverUrl,
            width: 40,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _suggestionCoverPlaceholder(),
          )
        : _suggestionCoverPlaceholder(),
  );

  Widget _suggestionCoverPlaceholder() => Container(
    width: 40,
    height: 56,
    color: const Color(0xFFE9EEDF),
    child: const Icon(Icons.menu_book_outlined, color: forest, size: 18),
  );

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit book' : 'Add a book')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TapRegion(
                  onTapOutside: (_) => setState(() => _suggestions = []),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _title,
                        focusNode: _titleFocus,
                        enabled: !_saving,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          suffixIcon: _searching
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Enter a title.'
                            : null,
                      ),
                      if (_suggestions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          constraints: const BoxConstraints(maxHeight: 260),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: const Color(0xFFD6DED5),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _suggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = _suggestions[index];
                              return ListTile(
                                leading: _suggestionCover(
                                  suggestion.coverUrl,
                                ),
                                title: Text(
                                  suggestion.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: suggestion.author.isEmpty
                                    ? null
                                    : Text(
                                        suggestion.author,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                onTap: () => _selectSuggestion(suggestion),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                if (_hasSelection) ...[
                  const SizedBox(height: 16),
                  SelectedBookCard(
                    title: _title.text,
                    author: _author,
                    coverUrl: _coverPhotoUrl,
                    genres: _genres,
                    publishedYear: _publishedYear,
                  ),
                ],
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _condition,
                  decoration: const InputDecoration(labelText: 'Condition'),
                  items: bookConditionOptions
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (value) => setState(() => _condition = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _estimatedValue,
                  enabled: !_saving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Estimated value',
                    prefixText: '\$ ',
                  ),
                  validator: (v) {
                    final parsed = double.tryParse(v ?? '');
                    if (parsed == null) return 'Enter a number.';
                    if (parsed < 0) return 'Value can\'t be negative.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _description,
                  enabled: !_saving,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                  ),
                ),
                if (!_hasSelection) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Search a title above and pick a result to continue.',
                    style: TextStyle(color: Color(0xFF617065)),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: (_saving || !_hasSelection) ? null : _submit,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Save changes' : 'Add to shelf'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
