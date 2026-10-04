import 'package:bookswap_login/features/authentication/domain/entities/auth_user.dart';
import 'package:bookswap_login/features/authentication/domain/entities/registration.dart';
import 'package:bookswap_login/features/authentication/domain/repositories/auth_repository.dart';
import 'package:bookswap_login/features/authentication/data/models/reader_profile_dto.dart';

/// Prototype only: all accounts and credentials disappear on app restart.
/// Do not enter real personal information or reuse a real password.
class DemoAuthRepository implements AuthRepository {
  DemoAuthRepository() {
    _users[email] = AuthUser(
      id: 'demo-reader',
      email: email,
      name: 'Reader',
      emailVerified: true,
      profile: ReaderProfile(
        Registration(
          firstName: 'Reader',
          lastName: 'Demo',
          email: email,
          password: password,
          gender: 'Prefer not to say',
          mobile: '01712345678',
          address: 'Gazipur',
          preferences: ['Fiction'],
          favoriteBook: '',
        ),
      ),
    );
    _passwords[email] = password;
  }
  static const email = 'reader@bookswap.app';
  static const password = 'BookSwap123!';
  AuthUser? currentUser;
  AuthUser? nextGoogleUser;
  bool failRefresh = false;
  bool failResend = false;
  int verificationEmails = 0;

  /// When set, restoreSession throws it (a saved session that couldn't be
  /// restored at launch).
  Object? restoreError;

  @override
  Future<AuthUser?> restoreSession() async {
    if (restoreError != null) throw restoreError!;
    return currentUser;
  }

  @override
  Future<AuthUser?> signInWithGoogle() async {
    if (nextGoogleUser == null) return null;
    return currentUser = nextGoogleUser;
  }

  @override
  Future<AuthUser> refreshSession() async {
    if (failRefresh) {
      throw const AuthFailure('Check your connection and try again.');
    }
    return currentUser = _users[currentUser!.email]!;
  }

  @override
  Future<void> resendVerification() async {
    if (failResend) {
      throw const AuthFailure(
        'Too many attempts. Please wait before trying again.',
      );
    }
    verificationEmails++;
  }

  @override
  Future<void> resetPassword(String email) async {}

  void verifyEmail(String email) {
    final user = _users[email]!;
    _users[email] = AuthUser(
      id: user.id,
      email: user.email,
      name: user.name,
      profile: user.profile,
      emailVerified: true,
      usesGoogle: user.usesGoogle,
    );
  }

  final _users = <String, AuthUser>{};
  final _passwords = <String, String>{};

  @override
  Future<AuthUser> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final key = email.trim().toLowerCase();
    if (!_users.containsKey(key) || _passwords[key] != password) {
      throw const AuthFailure('Email or password is incorrect. Try again.');
    }
    return currentUser = _users[key]!;
  }

  @override
  Future<AuthUser> register(Registration registration) async {
    final error = registration.validate(
      requirePassword: !(currentUser?.usesGoogle ?? false),
    );
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
      emailVerified: currentUser?.emailVerified ?? false,
      usesGoogle: currentUser?.usesGoogle ?? false,
    );
    _users[key] = user;
    _passwords[key] = registration.password;
    if (!user.emailVerified) verificationEmails++;
    return currentUser = user;
  }

  @override
  Future<void> signOut() async {
    currentUser = null;
  }

  @override
  Future<void> updateMaxDistance(double? km) async {}

  ProfileUpdate? lastProfileUpdate;

  @override
  Future<void> updateProfile(ProfileUpdate update) async {
    final error = update.validate();
    if (error != null) throw AuthFailure(error);
    final user = currentUser!;
    lastProfileUpdate = update;
    final saved = AuthUser(
      id: user.id,
      email: user.email,
      name: update.firstName.trim(),
      profile: ReaderProfileDto.parse({
        ...user.profile!.toMap(),
        ...update.toMap(),
      }),
      emailVerified: user.emailVerified,
      usesGoogle: user.usesGoogle,
    );
    _users[user.email] = saved;
    currentUser = saved;
  }
}
