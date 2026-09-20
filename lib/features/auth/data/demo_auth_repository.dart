import '../domain/auth_repository.dart';
import '../domain/registration.dart';

/// Prototype only: all accounts and credentials disappear on app restart.
/// Do not enter real personal information or reuse a real password.
class DemoAuthRepository implements AuthRepository {
  DemoAuthRepository() {
    _users[email] = const AuthUser(
      id: 'demo-reader',
      email: email,
      name: 'Reader',
    );
    _passwords[email] = password;
  }
  static const email = 'reader@bookswap.app';
  static const password = 'BookSwap123!';
  final _users = <String, AuthUser>{};
  final _passwords = <String, String>{};

  @override
  Future<AuthUser> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final key = email.trim().toLowerCase();
    if (!_users.containsKey(key) || _passwords[key] != password) {
      throw const AuthFailure('Email or password is incorrect. Try again.');
    }
    return _users[key]!;
  }

  @override
  Future<AuthUser> register(Registration registration) async {
    final error = registration.validate();
    if (error != null) throw AuthFailure(error);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final key = registration.email.trim().toLowerCase();
    if (_users.containsKey(key)) {
      throw const AuthFailure(
        'An account already uses this email. Sign in instead.',
      );
    }
    final user = AuthUser(
      id: 'demo-${_users.length}',
      email: key,
      name: registration.firstName.trim(),
      profile: ReaderProfile(registration),
    );
    _users[key] = user;
    _passwords[key] = registration.password;
    return user;
  }

  @override
  Future<void> signOut() async {}
}
