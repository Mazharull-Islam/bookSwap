import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'features/auth/application/auth_controller.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/welcome_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'features/auth/presentation/terms_page.dart';

void main() => runApp(const ProviderScope(child: BookSwapApp()));

class BookSwapApp extends StatelessWidget {
  const BookSwapApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'BookSwap',
    debugShowCheckedModeBanner: false,
    theme: buildTheme(),
    initialRoute: '/',
    routes: {
      '/': (_) => const WelcomePage(),
      '/login': (_) => const LoginPage(),
      '/register': (_) => const RegisterPage(),
      '/terms': (_) => const TermsPage(),
      '/home': (_) => const AuthGate(),
    },
  );
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final user = auth.asData?.value;
    if (auth.isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (user == null) return const LoginPage();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 72,
                    color: forest,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome, ${user.name}.',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Demo sign-in successful.\nYour next chapter starts here.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Book discovery and your shelf will be added in the next stage.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (context.mounted)
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/login', (_) => false);
                    },
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
