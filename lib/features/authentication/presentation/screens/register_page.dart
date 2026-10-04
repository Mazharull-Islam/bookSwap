import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/registration_form_controller.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_page.dart';
import '../widgets/registration_header.dart';
import '../widgets/registration_sections.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});
  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _form = GlobalKey<FormState>();
  final _fields = RegistrationFormController();
  bool _usingGoogle = false;

  @override
  void initState() {
    super.initState();
    _fields.prefillFrom(ref.read(authControllerProvider).valueOrNull);
  }

  @override
  void dispose() {
    _fields.dispose();
    super.dispose();
  }

  Future<void> _google() async {
    if (ref.read(authControllerProvider).isLoading) return;
    setState(() => _usingGoogle = true);
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    setState(() {
      _usingGoogle = false;
      _fields.prefillFrom(ref.read(authControllerProvider).valueOrNull);
    });
  }

  Future<void> _submit() async {
    if (ref.read(authControllerProvider).isLoading ||
        !_form.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    await ref
        .read(authControllerProvider.notifier)
        .register(_fields.toRegistration());
  }

  Future<void> _signInInstead() async {
    final auth = ref.read(authControllerProvider.notifier);
    auth.clearError();
    if (ref.read(authControllerProvider).valueOrNull != null) {
      await auth.signOut();
    }
    if (mounted) context.go('/login');
  }

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
                RegistrationHeader(google: google),
                if (user == null) ...[
                  const SizedBox(height: 16),
                  SecondaryButton(
                    buttonKey: const Key('googleSignUp'),
                    label: 'Sign up with Google',
                    icon: Icons.account_circle_outlined,
                    onPressed: loading ? null : _google,
                  ),
                ],
                AboutYouSection(form: _fields, enabled: !loading),
                ReadingWorldSection(form: _fields, enabled: !loading),
                AccountSection(
                  form: _fields,
                  enabled: !loading,
                  emailEnabled: !loading && user == null,
                  google: google,
                ),
                const SizedBox(height: 20),
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
                  onPressed: loading ? null : _signInInstead,
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
