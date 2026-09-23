import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../domain/models/registration.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_page.dart';
import '../widgets/password_input.dart';

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
  void initState() {
    super.initState();
    _prefill();
  }

  void _prefill() {
    final user = ref.read(authControllerProvider).valueOrNull;
    if (user == null) return;
    _controllers['email']!.text = user.email;
    if (_controllers['firstName']!.text.isEmpty) {
      final names = user.name.trim().split(RegExp(r'\s+'));
      _controllers['firstName']!.text = names.first;
      _controllers['lastName']!.text = names.skip(1).join(' ');
    }
  }

  bool _usingGoogle = false;

  Future<void> _google() async {
    if (ref.read(authControllerProvider).isLoading) return;
    setState(() => _usingGoogle = true);
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    setState(() {
      _usingGoogle = false;
      _prefill();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authControllerProvider).isLoading ||
        !_form.currentState!.validate()) {
      return;
    }
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
  }

  Widget _field(
    String name,
    String label, {
    String? Function(String?)? validator,
    TextInputType? keyboard,
    String? hint,
    int lines = 1,
    Iterable<String>? autofill,
  }) => AppTextField(
    fieldKey: Key(name),
    controller: _controllers[name],
    enabled:
        !ref.watch(authControllerProvider).isLoading &&
        !(name == 'email' &&
            ref.watch(authControllerProvider).valueOrNull != null),
    validator: validator,
    keyboardType: keyboard,
    textInputAction: TextInputAction.next,
    maxLines: lines,
    autofillHints: autofill,
    label: label,
    hint: hint,
  );

  Widget _pair(Widget first, Widget second) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 560) {
        return Column(children: [first, const SizedBox(height: 18), second]);
      }
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
    final user = state.valueOrNull;
    final google = user?.usesGoogle ?? false;
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
                  child: Text(
                    google
                        ? 'Google has verified your email. Complete this form to become a BookSwap member.'
                        : 'After registration, we will email you a confirmation link. Verify your email to activate your membership.',
                  ),
                ),
                if (user == null) ...[
                  const SizedBox(height: 16),
                  SecondaryButton(
                    buttonKey: const Key('googleSignUp'),
                    label: 'Sign up with Google',
                    icon: Icons.account_circle_outlined,
                    onPressed: loading ? null : _google,
                  ),
                ],
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
                  google
                      ? 'Your Google email is verified. No password is needed.'
                      : 'Use your email and password to sign in.',
                ),
                _field(
                  'email',
                  'Email address',
                  validator: validateEmail,
                  keyboard: TextInputType.emailAddress,
                  autofill: const [AutofillHints.email],
                ),
                const SizedBox(height: 18),
                if (!google) ...[
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
                ],
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
                            : () => context.push('/terms'),
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
                if (loading && _usingGoogle)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        'Complete sign-in in the Google popup. If it is hidden, check your other browser windows.',
                      ),
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
                PrimaryButton(
                  buttonKey: const Key('createAccount'),
                  label: 'Create account  →',
                  onPressed: _submit,
                  loading: loading,
                  loadingSemanticLabel: 'Creating account',
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: loading
                      ? null
                      : () async {
                          ref
                              .read(authControllerProvider.notifier)
                              .clearError();
                          if (user != null) {
                            await ref
                                .read(authControllerProvider.notifier)
                                .signOut();
                          }
                          if (context.mounted) context.go('/login');
                        },
                  child: Text(
                    user != null
                        ? 'Use another account'
                        : 'Already a neighbour? Sign in',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
