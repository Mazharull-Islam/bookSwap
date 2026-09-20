import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../application/auth_controller.dart';
import '../data/demo_auth_repository.dart';
import '../domain/auth_repository.dart';

import 'auth_widgets.dart';

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
  final _hidden = ValueNotifier(true);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _hidden.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authControllerProvider).isLoading) return;
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authControllerProvider.notifier)
        .signIn(_email.text, _password.text);
    if (!mounted) return;
    if (ref.read(authControllerProvider).asData?.value != null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
    }
  }

  void _passwordHelp() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password help'),
        content: const Text(
          'This version uses a demo account. No reset email is sent.\n\nEmail: reader@bookswap.app\nPassword: BookSwap123!\n\nFor a newly registered demo account, use the password you chose. Email recovery will be available when Firebase Authentication is connected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
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
            TextFormField(
              key: const Key('email'),
              controller: _email,
              enabled: !loading,
              validator: validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Email address',
                hintText: 'you@example.com',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
            const SizedBox(height: 18),
            ValueListenableBuilder<bool>(
              valueListenable: _hidden,
              builder: (context, hidden, child) => TextFormField(
                key: const Key('password'),
                controller: _password,
                enabled: !loading,
                validator: validatePassword,
                obscureText: hidden,
                autocorrect: false,
                enableSuggestions: false,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    tooltip: hidden ? 'Show password' : 'Hide password',
                    onPressed: loading ? null : () => _hidden.value = !hidden,
                    icon: Icon(
                      hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
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
                                Navigator.pushNamed(context, '/register').then((
                                  _,
                                ) {
                                  if (mounted)
                                    ref
                                        .read(authControllerProvider.notifier)
                                        .clearError();
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
            FilledButton(
              key: const Key('signIn'),
              onPressed: loading ? null : _submit,
              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        semanticsLabel: 'Signing in',
                      ),
                    )
                  : const Text('Sign in  →'),
            ),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF1E8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Take a look around',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Try the login flow with a demo account. No real account is needed.',
                  ),
                  TextButton.icon(
                    onPressed: loading
                        ? null
                        : () {
                            _email.text = DemoAuthRepository.email;
                            _password.text = DemoAuthRepository.password;
                          },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('Fill demo details'),
                  ),
                ],
              ),
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
