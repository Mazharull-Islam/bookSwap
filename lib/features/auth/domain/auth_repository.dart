import 'registration.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.profile,
    this.emailVerified = false,
    this.usesGoogle = false,
    this.notice,
  });
  final String id;
  final String email;
  final String name;
  final ReaderProfile? profile;
  final bool emailVerified;
  final bool usesGoogle;
  final String? notice;
  bool get isMember => profile != null && emailVerified;
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}

abstract interface class AuthRepository {
  Future<AuthUser?> restoreSession();
  Future<AuthUser> signIn(String email, String password);
  Future<AuthUser?> signInWithGoogle();
  Future<AuthUser> register(Registration registration);
  Future<AuthUser> refreshSession();
  Future<void> resendVerification();
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

String? validateEmail(String? input) {
  final value = input?.trim() ?? '';
  if (value.isEmpty) return 'Enter your email address.';
  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? validatePassword(String? input) =>
    input == null || input.isEmpty ? 'Enter your password.' : null;

class SignIn {
  const SignIn(this.repository);
  final AuthRepository repository;

  Future<AuthUser> call(String email, String password) {
    final error = validateEmail(email) ?? validatePassword(password);
    if (error != null) throw AuthFailure(error);
    return repository.signIn(email.trim(), password);
  }
}

class Register {
  const Register(this.repository);
  final AuthRepository repository;
  Future<AuthUser> call(Registration data, {bool requirePassword = true}) {
    final error = data.validate(requirePassword: requirePassword);
    if (error != null) throw AuthFailure(error);
    return repository.register(data);
  }
}
