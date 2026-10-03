import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/friendly_error.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/models/registration.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _form = GlobalKey<FormState>();
  late final ReaderProfile? _profile = ref
      .read(authControllerProvider)
      .valueOrNull
      ?.profile;
  late final _firstName = TextEditingController(text: _profile?.firstName);
  late final _lastName = TextEditingController(text: _profile?.lastName);
  late final _mobile = TextEditingController(text: _profile?.mobile);
  late final _address = TextEditingController(text: _profile?.address);
  late final _favoriteBook = TextEditingController(
    text: _profile?.favoriteBook,
  );
  late String _gender = genders.contains(_profile?.gender)
      ? _profile!.gender
      : genders.last;
  late List<String> _preferences = [...?_profile?.preferences];
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _mobile, _address, _favoriteBook]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .updateProfile(
            ProfileUpdate(
              firstName: _firstName.text,
              lastName: _lastName.text,
              gender: _gender,
              mobile: _mobile.text,
              address: _address.text,
              preferences: _preferences,
              favoriteBook: _favoriteBook.text,
            ),
          );
      await ref.read(authControllerProvider.notifier).refreshSession();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated.')));
      context.go('/profile');
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      if (mounted) {
        setState(
          () => _error = friendlyError(
            e,
            fallback: 'Could not save your profile. Please try again.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(authControllerProvider).valueOrNull?.email ?? '';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: _saving ? null : () => context.go('/profile'),
        ),
        title: const Text('Edit profile'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      fieldKey: const Key('editFirstName'),
                      controller: _firstName,
                      enabled: !_saving,
                      label: 'First name',
                      textInputAction: TextInputAction.next,
                      validator: (v) => requiredText(v, 'first name'),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      fieldKey: const Key('editLastName'),
                      controller: _lastName,
                      enabled: !_saving,
                      label: 'Last name',
                      textInputAction: TextInputAction.next,
                      validator: (v) => requiredText(v, 'last name'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _gender,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      items: genders
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                      onChanged: _saving
                          ? null
                          : (value) {
                              if (value != null) _gender = value;
                            },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      fieldKey: const Key('editMobile'),
                      controller: _mobile,
                      enabled: !_saving,
                      label: 'Mobile number',
                      hint: '+880 1XXXXXXXXX',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: validateMobile,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      fieldKey: const Key('editAddress'),
                      controller: _address,
                      enabled: !_saving,
                      label: 'Area and city',
                      hint: 'e.g. Board Bazar, Gazipur',
                      maxLines: 2,
                      validator: (v) => requiredText(v, 'area and city'),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your neighbourhood is enough. Do not enter your exact '
                      'home address.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 20),
                    FormField<List<String>>(
                      initialValue: _preferences,
                      validator: (v) => v == null || v.isEmpty
                          ? 'Choose at least one book preference.'
                          : null,
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
                                  onSelected: _saving
                                      ? null
                                      : (selected) {
                                          final next = [...field.value!];
                                          selected
                                              ? next.add(genre)
                                              : next.remove(genre);
                                          _preferences = next;
                                          field.didChange(next);
                                        },
                                ),
                            ],
                          ),
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                field.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      fieldKey: const Key('editFavoriteBook'),
                      controller: _favoriteBook,
                      enabled: !_saving,
                      label: 'Favorite book (optional)',
                      validator: (v) => (v ?? '').trim().length > 200
                          ? 'Use at most 200 characters for your favorite book.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: TextEditingController(text: email),
                      enabled: false,
                      label: 'Email address',
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your email can\'t be changed here.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    PrimaryButton(
                      buttonKey: const Key('saveProfile'),
                      label: 'Save changes',
                      onPressed: _save,
                      loading: _saving,
                      loadingSemanticLabel: 'Saving',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
