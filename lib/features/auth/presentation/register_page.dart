import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../application/auth_controller.dart';
import '../domain/auth_repository.dart';
import '../domain/registration.dart';
import 'auth_widgets.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _form = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{
    for (final name in [
      'firstName',
      'lastName',
      'email',
      'mobile',
      'address',
      'favoriteBook',
      'password',
      'confirmPassword',
    ])
      name: TextEditingController(),
  };
  String _gender = 'Prefer not to say';
  List<String> _preferences = [];
  bool _accepted = false;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authControllerProvider).isLoading ||
        !_form.currentState!.validate())
      return;
    FocusScope.of(context).unfocus();
    String value(String name) => _controllers[name]!.text;
    await ref
        .read(authControllerProvider.notifier)
        .register(
          Registration(
            firstName: value('firstName'),
            lastName: value('lastName'),
            email: value('email'),
            password: value('password'),
            gender: _gender,
            mobile: value('mobile'),
            address: value('address'),
            preferences: _preferences,
            favoriteBook: value('favoriteBook'),
            acceptedTerms: _accepted,
          ),
        );
    if (!mounted) return;
    if (ref.read(authControllerProvider).asData?.value != null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    }
  }

  Widget _field(
    String name,
    String label, {
    String? Function(String?)? validator,
    TextInputType? keyboard,
    String? hint,
    int lines = 1,
    Iterable<String>? autofill,
  }) => TextFormField(
    key: Key(name),
    controller: _controllers[name],
    enabled: !ref.watch(authControllerProvider).isLoading,
    validator: validator,
    keyboardType: keyboard,
    textInputAction: TextInputAction.next,
    maxLines: lines,
    autofillHints: autofill,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      errorMaxLines: 3,
    ),
  );

  Widget _pair(Widget first, Widget second) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 560)
        return Column(children: [first, const SizedBox(height: 18), second]);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: first),
          const SizedBox(width: 18),
          Expanded(child: second),
        ],
      );
    },
  );

  Widget _heading(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: forest,
          ),
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final loading = state.isLoading;
    final error = state.error;
    return PopScope(
      canPop: !loading,
      child: AuthPage(
        maxWidth: 740,
        child: AutofillGroup(
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'MAKE ROOM FOR MORE STORIES',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: forest,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Join the neighbourhood.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                const Text(
                  'A few details, a shared love of books, and a new chapter.',
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEDF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Demo registration • Use fictional details and a unique test password. Your account lasts until the app restarts.',
                  ),
                ),
                _heading(
                  '01  About you',
                  'All fields are required unless marked optional.',
                ),
                _pair(
                  _field(
                    'firstName',
                    'First name',
                    validator: (v) => requiredText(v, 'first name'),
                    autofill: const [AutofillHints.givenName],
                  ),
                  _field(
                    'lastName',
                    'Last name',
                    validator: (v) => requiredText(v, 'last name'),
                    autofill: const [AutofillHints.familyName],
                  ),
                ),
                const SizedBox(height: 18),
                _pair(
                  DropdownButtonFormField<String>(
                    key: const Key('gender'),
                    initialValue: _gender,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: genders
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: loading
                        ? null
                        : (value) {
                            if (value != null) _gender = value;
                          },
                  ),
                  _field(
                    'mobile',
                    'Mobile number',
                    validator: validateMobile,
                    keyboard: TextInputType.phone,
                    hint: '+880 1XXXXXXXXX',
                    autofill: const [AutofillHints.telephoneNumber],
                  ),
                ),
                const SizedBox(height: 18),
                _field(
                  'address',
                  'Address (area and city)',
                  validator: (v) => requiredText(v, 'area and city'),
                  hint: 'e.g. Board Bazar, Gazipur',
                  lines: 2,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your neighbourhood is enough. Do not enter your exact home address.',
                  style: TextStyle(fontSize: 12),
                ),
                _heading(
                  '02  Your reading world',
                  'Choose at least one genre. You can choose more than one.',
                ),
                FormField<List<String>>(
                  initialValue: const [],
                  validator: (v) => v == null || v.isEmpty
                      ? 'Choose at least one book preference.'
                      : null,
                  builder: (field) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Book preferences',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: bookGenres
                            .map(
                              (genre) => FilterChip(
                                label: Text(genre),
                                selected: field.value!.contains(genre),
                                onSelected: loading
                                    ? null
                                    : (selected) {
                                        final next = [...field.value!];
                                        if (selected) {
                                          next.add(genre);
                                        } else {
                                          next.remove(genre);
                                        }
                                        _preferences = next;
                                        field.didChange(next);
                                      },
                              ),
                            )
                            .toList(),
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
                const SizedBox(height: 18),
                _field(
                  'favoriteBook',
                  'Favorite book (optional)',
                  hint: 'The book you always recommend',
                ),
                _heading(
                  '03  Your account',
                  'Use your email and password to sign in.',
                ),
                _field(
                  'email',
                  'Email address',
                  validator: validateEmail,
                  keyboard: TextInputType.emailAddress,
                  autofill: const [AutofillHints.email],
                ),
                const SizedBox(height: 18),
                _pair(
                  PasswordInput(
                    fieldKey: const Key('password'),
                    controller: _controllers['password']!,
                    label: 'Password',
                    validator: validateNewPassword,
                    enabled: !loading,
                    newPassword: true,
                  ),
                  PasswordInput(
                    fieldKey: const Key('confirmPassword'),
                    controller: _controllers['confirmPassword']!,
                    label: 'Confirm password',
                    validator: (v) => v == null || v.isEmpty
                        ? 'Confirm your password.'
                        : v != _controllers['password']!.text
                        ? 'Passwords do not match.'
                        : null,
                    enabled: !loading,
                    newPassword: true,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'At least 8 characters, including a letter and a number.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),
                FormField<bool>(
                  initialValue: false,
                  validator: (v) => v == true
                      ? null
                      : 'Accept the Terms & Conditions to continue.',
                  builder: (field) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        key: const Key('termsConsent'),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: field.value,
                        title: const Text(
                          'I have read and agree to the Terms & Conditions.',
                        ),
                        onChanged: loading
                            ? null
                            : (v) {
                                _accepted = v ?? false;
                                field.didChange(_accepted);
                              },
                      ),
                      TextButton(
                        onPressed: loading
                            ? null
                            : () => Navigator.pushNamed(context, '/terms'),
                        child: const Text('Read Terms & Conditions →'),
                      ),
                      if (field.hasError)
                        Text(
                          field.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        error is AuthFailure
                            ? error.message
                            : 'Unable to create your account. Please try again.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                FilledButton(
                  key: const Key('createAccount'),
                  onPressed: loading ? null : _submit,
                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            semanticsLabel: 'Creating account',
                          ),
                        )
                      : const Text('Create account  →'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: loading
                      ? null
                      : () {
                          ref
                              .read(authControllerProvider.notifier)
                              .clearError();
                          Navigator.pop(context);
                        },
                  child: const Text('Already a neighbour? Sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
