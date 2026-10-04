import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../books/domain/entities/book.dart' show bookGenreOptions;
import '../../../../app/app_colors.dart';
import '../providers/forum_providers.dart';

Future<void> showCreatePostDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const _CreatePostDialog(),
  );
}

class _CreatePostDialog extends ConsumerStatefulWidget {
  const _CreatePostDialog();

  @override
  ConsumerState<_CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends ConsumerState<_CreatePostDialog> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  String? _genre;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || !_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final me = ref.read(currentUserProvider);
    await ref.read(createForumPostProvider)(
      authorId: me.id,
      authorName: me.displayName,
      title: _title.text.trim(),
      body: _body.text.trim(),
      genre: _genre,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('New post'),
    content: Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _title,
              enabled: !_saving,
              label: 'Title',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter a title.' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              initialValue: _genre,
              decoration: const InputDecoration(labelText: 'Genre (optional)'),
              items: [
                const DropdownMenuItem<String?>(child: Text('None')),
                ...bookGenreOptions.map(
                  (g) => DropdownMenuItem<String?>(value: g, child: Text(g)),
                ),
              ],
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _genre = value),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _body,
              enabled: !_saving,
              maxLines: 5,
              label: 'What do you want to say?',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter a message.' : null,
            ),
            const SizedBox(height: 12),
            Text(
              'Be kind and stay on topic. Posts can be reported and reviewed '
              'by moderators.',
              style: TextStyle(fontSize: 12, color: context.colors.textMuted),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      PrimaryButton(label: 'Post', onPressed: _submit, loading: _saving),
    ],
  );
}
