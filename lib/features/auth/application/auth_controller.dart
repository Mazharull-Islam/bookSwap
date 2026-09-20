import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/demo_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/registration.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => DemoAuthRepository(),
);
final signInProvider = Provider(
  (ref) => SignIn(ref.watch(authRepositoryProvider)),
);
final authControllerProvider = AsyncNotifierProvider<AuthController, AuthUser?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AuthUser?> {
  @override
  AuthUser? build() => null;

  Future<void> signIn(String email, String password) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(signInProvider)(email, password),
    );
  }

  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }

  Future<void> register(Registration data) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => Register(ref.read(authRepositoryProvider))(data),
    );
  }

  Future<void> signOut() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
      return null;
    });
  }
}
