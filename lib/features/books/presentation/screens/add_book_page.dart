import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../core/services/book_enrichment_service.dart';
import '../../../../core/services/open_library_service.dart';
import '../../../../shared/widgets/feedback.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../controllers/book_lookup_controller.dart';
import '../providers/book_providers.dart';
import '../widgets/book_details_fields.dart';
import '../widgets/duplicate_shelf_notice.dart';
import '../widgets/isbn_dialog.dart';
import '../widgets/isbn_entry_buttons.dart';
import '../widgets/refresh_details_button.dart';
import '../widgets/selected_book_card.dart';
import '../widgets/title_search_field.dart';
import 'scan_isbn_page.dart';

/// Adds a book to the shelf, or edits one that's already there. Finding the
/// book (search, ISBN, details) is [BookLookupController]'s job; this screen
/// lays it out and saves the form.
class AddBookPage extends ConsumerStatefulWidget {
  const AddBookPage({super.key, this.existing});
  final Book? existing;

  @override
  ConsumerState<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends ConsumerState<AddBookPage> {
  final _form = GlobalKey<FormState>();
  late final BookLookupController _lookup;
  late final _estimatedValue = TextEditingController(
    text: widget.existing?.estimatedValue.toString(),
  );
  late String _condition =
      widget.existing?.condition ?? bookConditionOptions.first;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _lookup = BookLookupController(
      catalogue: ref.read(openLibraryServiceProvider),
      enrichment: ref.read(bookEnrichmentServiceProvider),
      existing: widget.existing,
    )..addListener(_onLookupChanged);
  }

  void _onLookupChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _lookup.removeListener(_onLookupChanged);
    _lookup.dispose();
    _estimatedValue.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final isbn = await ref.read(isbnScannerProvider)(context);
    if (isbn != null && mounted) await _lookupIsbn(isbn);
  }

  Future<void> _typeIsbn() async {
    final isbn = await showIsbnDialog(context);
    if (isbn != null && mounted) await _lookupIsbn(isbn);
  }

  Future<void> _lookupIsbn(String isbn) async {
    final outcome = await _lookup.lookupIsbn(isbn);
    if (!mounted) return;
    switch (outcome) {
      case IsbnLookupOutcome.selected:
        break;
      case IsbnLookupOutcome.notFound:
        showMessage(
          context,
          "We couldn't find that ISBN. Try searching by title instead.",
        );
        _lookup.titleFocus.requestFocus();
      case IsbnLookupOutcome.unreachable:
        showMessage(
          context,
          "Couldn't reach the book database. Check your connection and try "
          'again.',
        );
    }
  }

  Future<void> _refreshDetails() async {
    final updated = await _lookup.refreshDetails();
    if (updated && mounted) {
      showMessage(context, 'Updated genres and synopsis.');
    }
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
      title: _lookup.title.text,
      author: _lookup.author,
      genre: _lookup.genre,
      condition: _condition,
      estimatedValue: double.tryParse(_estimatedValue.text) ?? 0,
      description: _lookup.description.text,
      coverPhotoUrl: _lookup.coverPhotoUrl,
      isbn: _lookup.isbn,
      workKey: _lookup.workKey,
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
    final workKey = _lookup.workKey;
    if (workKey == null) return false;
    final ownId = widget.existing?.id ?? '';
    return shelf.any((b) => b.workKey == workKey && b.id != ownId);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    final shelf = ref.watch(myShelfProvider).valueOrNull ?? const <Book>[];
    final busy = _saving || _lookup.lookingUp;
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
                TitleSearchField(
                  controller: _lookup.title,
                  focusNode: _lookup.titleFocus,
                  enabled: !_saving,
                  busy: _lookup.searching || _lookup.lookingUp,
                  suggestions: _lookup.suggestions,
                  onSelect: _lookup.selectSuggestion,
                  onDismiss: _lookup.clearSuggestions,
                ),
                const SizedBox(height: 12),
                IsbnEntryButtons(
                  enabled: !busy,
                  onScan: _scanBarcode,
                  onType: _typeIsbn,
                ),
                if (isEditing) ...[
                  const SizedBox(height: 8),
                  RefreshDetailsButton(
                    refreshing: _lookup.refreshing,
                    enabled: !_saving,
                    onPressed: _refreshDetails,
                  ),
                ],
                if (_lookup.hasSelection) ...[
                  const SizedBox(height: 16),
                  SelectedBookCard(
                    title: _lookup.title.text,
                    author: _lookup.author,
                    coverUrl: _lookup.coverPhotoUrl,
                    genres: _lookup.genres,
                    publishedYear: _lookup.publishedYear,
                  ),
                ],
                if (_isDuplicateOnShelf(shelf)) ...[
                  const SizedBox(height: 12),
                  const DuplicateShelfNotice(),
                ],
                const SizedBox(height: 16),
                BookDetailsFields(
                  condition: _condition,
                  onConditionChanged: (value) =>
                      setState(() => _condition = value),
                  estimatedValue: _estimatedValue,
                  description: _lookup.description,
                  fetchingSynopsis: _lookup.fetchingSynopsis,
                  enabled: !_saving,
                ),
                if (!_lookup.hasSelection) ...[
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
                  onPressed: _lookup.hasSelection ? _submit : null,
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
