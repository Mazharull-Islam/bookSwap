import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/authentication/domain/models/auth_user.dart';
import '../features/authentication/presentation/providers/auth_providers.dart';
import '../features/authentication/presentation/screens/login_page.dart';
import '../features/authentication/presentation/screens/profile_page.dart';
import '../features/authentication/presentation/screens/register_page.dart';
import '../features/authentication/presentation/screens/terms_page.dart';
import '../features/authentication/presentation/screens/verification_page.dart';
import '../features/authentication/presentation/screens/welcome_page.dart';
import '../features/books/domain/models/book.dart';
import '../features/books/presentation/screens/add_book_page.dart';
import '../features/books/presentation/screens/my_shelf_page.dart';

enum _AuthStage {
  loading,
  unauthenticated,
  needsProfile,
  needsVerification,
  authenticated,
}

_AuthStage _stageOf(AsyncValue<AuthUser?> state) {
  if (state.isLoading && !state.hasValue) return _AuthStage.loading;
  final user = state.valueOrNull;
  if (user == null) return _AuthStage.unauthenticated;
  if (user.profile == null) return _AuthStage.needsProfile;
  if (!user.emailVerified) return _AuthStage.needsVerification;
  return _AuthStage.authenticated;
}

/// Where a location must be for a given auth stage — null means "stay put".
String? _redirectFor(_AuthStage stage, String location) {
  if (location == '/terms') return null;
  switch (stage) {
    case _AuthStage.loading:
      return null;
    case _AuthStage.unauthenticated:
      return {'/', '/login', '/register'}.contains(location) ? null : '/';
    case _AuthStage.needsProfile:
      return location == '/register' ? null : '/register';
    case _AuthStage.needsVerification:
      return location == '/verify' ? null : '/verify';
    case _AuthStage.authenticated:
      return location.startsWith('/shelf') || location == '/profile'
          ? null
          : '/shelf';
  }
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) => _redirectFor(
      _stageOf(ref.read(authControllerProvider)),
      state.matchedLocation,
    ),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const _RootPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) => const VerificationPage(),
      ),
      GoRoute(path: '/terms', builder: (context, state) => const TermsPage()),
      GoRoute(
        path: '/shelf/add',
        builder: (context, state) =>
            AddBookPage(existing: state.extra as Book?),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/shelf',
            builder: (context, state) => const MyShelfPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
});

class _RootPage extends ConsumerWidget {
  const _RootPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider);
    if (session.isLoading && session.valueOrNull == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return const WelcomePage();
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  static const _tabs = ['/shelf', '/profile'];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _tabs.indexOf(location);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index < 0 ? 0 : index,
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'My Shelf',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
