import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_page.dart';
import '../widgets/password_input.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => PopScope(
    canPop: !ref.watch(authControllerProvider).isLoading,
    child: const AuthPage(child: _LoginForm()),
  );
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();
  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authControllerProvider).isLoading) return;
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authControllerProvider.notifier)
        .signIn(_email.text, _password.text);
  }

  bool _usingGoogle = false;

  Future<void> _google() async {
    if (ref.read(authControllerProvider).isLoading) return;
    setState(() => _usingGoogle = true);
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    setState(() => _usingGoogle = false);
  }

  Future<void> _passwordHelp() async {
    await ref.read(authControllerProvider.notifier).resetPassword(_email.text);
    if (!mounted || ref.read(authControllerProvider).hasError) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'If an account uses this email, you will receive a password reset link.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final loading = auth.isLoading;
    final error = auth.error;
    return AutofillGroup(
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'YOUR NEXT CHAPTER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.3,
                color: forest,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Welcome back.',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              'Sign in and find a story worth sharing.',
              style: TextStyle(color: Color(0xFF617065), fontSize: 16),
            ),
            const SizedBox(height: 30),
            AppTextField(
              fieldKey: const Key('email'),
              controller: _email,
              enabled: !loading,
              validator: validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              autocorrect: false,
              label: 'Email address',
              hint: 'you@example.com',
              prefixIcon: Icons.mail_outline_rounded,
            ),
            const SizedBox(height: 18),
            PasswordInput(
              fieldKey: const Key('password'),
              controller: _password,
              label: 'Password',
              validator: validatePassword,
              enabled: !loading,
              onSubmitted: _submit,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: loading
                            ? null
                            : () {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .clearError();
                                context.push('/register').then((_) {
                                  if (mounted) {
                                    ref
                                        .read(authControllerProvider.notifier)
                                        .clearError();
                                  }
                                });
                              },
                        child: const Text('Register new user'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: loading ? null : _passwordHelp,
                        child: const Text('Forgot password?'),
                      ),
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
            if (error != null) ...[
              Semantics(
                liveRegion: true,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    error is AuthFailure
                        ? error.message
                        : 'Something went wrong. Please try again.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            PrimaryButton(
              buttonKey: const Key('signIn'),
              label: 'Sign in  →',
              onPressed: _submit,
              loading: loading,
              loadingSemanticLabel: 'Signing in',
            ),
            const SizedBox(height: 26),
            SecondaryButton(
              buttonKey: const Key('googleSignIn'),
              label: 'Sign in with Google',
              icon: Icons.account_circle_outlined,
              onPressed: loading ? null : _google,
            ),
            const SizedBox(height: 12),
            const Text(
              'New here? Google sign-up still requires the registration form. Existing members can use the same Google email to sign in.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF617065)),
            ),
            const SizedBox(height: 26),
            const Text(
              'Borrow a book. Share a little possibility.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF617065)),
            ),
          ],
        ),
      ),
    );
  }
}
