import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../core/services/open_library_service.dart';
import '../../../../core/utils/isbn.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../providers/book_providers.dart';
import '../widgets/book_suggestion_tile.dart';
import 'scan_isbn_page.dart';
import '../widgets/selected_book_card.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/services/book_enrichment_service.dart';
import '../../../../shared/genre_normalizer.dart';
import '../../domain/book_genres.dart';

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
  bool _lookingUp = false;
  bool _refreshing = false;
  bool _fetchingSynopsis = false;

  String _author = '';
  String _genre = '';
  List<String> _genres = [];
  String? _publishedYear;
  String? _coverPhotoUrl;
  String? _isbn;
  String? _workKey;

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
    _workKey = existing?.workKey;
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
          .read(openLibraryServiceProvider)
          .searchByTitle(query);
      if (mounted && _title.text == query) {
        setState(() => _suggestions = results);
      }
    } on BookLookupFailure {
      // Suggestions are a convenience; a lookup failure shouldn't block typing.
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _selectSuggestion(BookMetadata suggestion) async {
    _title.removeListener(_onTitleChanged);
    _title.text = suggestion.title;
    _title.addListener(_onTitleChanged);
    // Standard genres from the subject tags right away (no network), then
    // refined below once the second source has answered.
    final quickGenres = standardGenres(subjects: suggestion.genres);
    setState(() {
      _author = suggestion.author;
      _genres = quickGenres;
      _genre = quickGenres.join(', ');
      _publishedYear = suggestion.publishedYear;
      _coverPhotoUrl = suggestion.coverUrl;
      _isbn = suggestion.isbn;
      _workKey = suggestion.workKey;
      _suggestions = [];
      _fetchingSynopsis = true;
    });
    _titleFocus.unfocus();
    final details = await ref
        .read(bookEnrichmentServiceProvider)
        .enrich(suggestion);
    if (!mounted) return;
    setState(() {
      _genres = details.genres;
      _genre = details.genres.join(', ');
      _description.text = details.synopsis ?? '';
      _fetchingSynopsis = false;
    });
  }

  /// For a book already on the shelf: re-reads its genres and synopsis from
  /// the catalogues, keeping what's there if nothing better turns up.
  Future<void> _refreshDetails() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    try {
      final details = await ref
          .read(bookEnrichmentServiceProvider)
          .enrich(
            BookMetadata(
              title: _title.text,
              author: _author,
              isbn: _isbn,
              workKey: _workKey,
              genres: bookGenreList(_genre),
            ),
          );
      if (!mounted) return;
      setState(() {
        _genres = details.genres;
        _genre = details.genres.join(', ');
        if (details.synopsis != null) _description.text = details.synopsis!;
      });
      _say('Updated genres and synopsis.');
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  void _say(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _scanBarcode() async {
    final isbn = await ref.read(isbnScannerProvider)(context);
    if (isbn != null && mounted) await _lookupIsbn(isbn);
  }

  Future<void> _typeIsbn() async {
    final isbn = await showDialog<String>(
      context: context,
      builder: (_) => const _IsbnDialog(),
    );
    if (isbn != null && mounted) await _lookupIsbn(isbn);
  }

  Future<void> _lookupIsbn(String isbn) async {
    setState(() => _lookingUp = true);
    try {
      final found = await ref
          .read(openLibraryServiceProvider)
          .lookupByIsbn(isbn);
      if (!mounted) return;
      if (found == null) {
        _say("We couldn't find that ISBN. Try searching by title instead.");
        _titleFocus.requestFocus();
        return;
      }
      await _selectSuggestion(found);
    } on BookLookupFailure {
      if (mounted) {
        _say(
          "Couldn't reach the book database. Check your connection and try "
          'again.',
        );
      }
    } finally {
      if (mounted) setState(() => _lookingUp = false);
    }
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
      workKey: _workKey,
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

  bool _isDuplicateOnShelf(List<Book> shelf) {
    if (_workKey == null) return false;
    final ownId = widget.existing?.id ?? '';
    return shelf.any((b) => b.workKey == _workKey && b.id != ownId);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    final shelf = ref.watch(myShelfProvider).valueOrNull ?? const <Book>[];
    final isDuplicate = _isDuplicateOnShelf(shelf);
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
                      AppTextField(
                        controller: _title,
                        focusNode: _titleFocus,
                        enabled: !_saving,
                        label: 'Title',
                        suffixIcon: (_searching || _lookingUp)
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
                            border: Border.all(color: context.colors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // Material ancestor so BookSuggestionTile's ListTile
                          // ink/background isn't painted under this
                          // Container's own decoration and lost.
                          child: Material(
                            type: MaterialType.transparency,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _suggestions.length,
                              itemBuilder: (context, index) {
                                final suggestion = _suggestions[index];
                                return BookSuggestionTile(
                                  title: suggestion.title,
                                  author: suggestion.author,
                                  coverUrl: suggestion.coverUrl,
                                  onTap: () => _selectSuggestion(suggestion),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (!kIsWeb)
                      OutlinedButton.icon(
                        key: const Key('scanIsbn'),
                        onPressed: _saving || _lookingUp ? null : _scanBarcode,
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Scan barcode'),
                      ),
                    OutlinedButton.icon(
                      key: const Key('typeIsbn'),
                      onPressed: _saving || _lookingUp ? null : _typeIsbn,
                      icon: const Icon(Icons.dialpad),
                      label: const Text('Type an ISBN'),
                    ),
                  ],
                ),
                if (isEditing) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      key: const Key('refreshDetails'),
                      onPressed: _refreshing || _saving
                          ? null
                          : _refreshDetails,
                      icon: _refreshing
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: const Text('Refresh genres & synopsis'),
                    ),
                  ),
                ],
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
                if (isDuplicate) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.warningSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE0A93A)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: context.colors.warningText,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Book already in shelf',
                            style: TextStyle(color: context.colors.warningText),
                          ),
                        ),
                      ],
                    ),
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
                AppTextField(
                  controller: _estimatedValue,
                  enabled: !_saving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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
                  controller: _description,
                  enabled: !_saving,
                  maxLines: 2,
                  label: 'Description (optional)',
                  suffixIcon: _fetchingSynopsis
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
                if (!_hasSelection) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Search a title above and pick a result to continue.',
                    style: TextStyle(color: context.colors.textMuted),
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
                PrimaryButton(
                  label: isEditing ? 'Save changes' : 'Add to shelf',
                  onPressed: _hasSelection ? _submit : null,
                  loading: _saving,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
      FilledButton(onPressed: _submit, child: const Text('Find book')),
    ],
  );
}
