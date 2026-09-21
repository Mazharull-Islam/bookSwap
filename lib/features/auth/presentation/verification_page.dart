import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/auth_controller.dart';
import '../domain/auth_repository.dart';
import 'auth_widgets.dart';

class VerificationPage extends ConsumerStatefulWidget {
  const VerificationPage({super.key});

  @override
  ConsumerState<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  String? _message;
  DateTime? _lastSent;

  Future<void> _check() async {
    await ref.read(authControllerProvider.notifier).refreshSession();
    if (!mounted) return;
    final state = ref.read(authControllerProvider);
    if (!state.hasError && !(state.valueOrNull?.emailVerified ?? false)) {
      setState(
        () => _message =
            'Your email is not verified yet. Open the link in your inbox, then check again.',
      );
    }
  }

  Future<void> _resend() async {
    if (_lastSent != null &&
        DateTime.now().difference(_lastSent!).inSeconds < 60) {
      setState(
        () => _message =
            'Please wait one minute before requesting another email.',
      );
      return;
    }
    await ref.read(authControllerProvider.notifier).resendVerification();
    if (!mounted) return;
    if (!ref.read(authControllerProvider).hasError) {
      setState(() {
        _lastSent = DateTime.now();
        _message = 'Confirmation email sent. Check your inbox and spam folder.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final user = state.valueOrNull;
    final error = state.error;
    return AuthPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.mark_email_unread_outlined, size: 64),
          const SizedBox(height: 24),
          Text(
            'Verify your email',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Your registration is saved. Open the confirmation link sent to ${user?.email ?? 'your email'} to become a BookSwap member.',
          ),
          const SizedBox(height: 12),
          const Text(
            'Check your spam folder too. After confirming, return here and tap “I have verified my email”.',
          ),
          if (user?.notice != null && _message == null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(user!.notice!),
            ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Semantics(liveRegion: true, child: Text(_message!)),
            ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                error is AuthFailure
                    ? error.message
                    : 'Unable to check your account. Try again.',
              ),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: state.isLoading ? null : _check,
            child: const Text('I have verified my email'),
          ),
          TextButton(
            onPressed: state.isLoading ? null : _resend,
            child: const Text('Resend email'),
          ),
          TextButton(
            onPressed: state.isLoading
                ? null
                : () => ref.read(authControllerProvider.notifier).signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
