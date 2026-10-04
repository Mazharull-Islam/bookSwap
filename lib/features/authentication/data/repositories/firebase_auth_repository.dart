import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/models/auth_user.dart';
import '../../domain/models/registration.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    firebase.FirebaseAuth? auth,
    FirebaseFirestore? store,
    this.requestTimeout = const Duration(seconds: 20),
    this.googleTimeout = const Duration(minutes: 2),
  }) : _auth = auth ?? firebase.FirebaseAuth.instance,
       _store = store ?? FirebaseFirestore.instance;

  final firebase.FirebaseAuth _auth;
  final FirebaseFirestore _store;
  Future<void>? _googleInitialization;
  final Duration requestTimeout;
  final Duration googleTimeout;

  // Bound each SDK call separately: a timed-out step must not continue into
  // profile writes or membership activation when its late result arrives.
  Future<T> _network<T>(Future<T> request) => request.timeout(requestTimeout);

  Future<T> _request<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on firebase.FirebaseAuthException catch (error) {
      // Members only see a friendly sentence; developers need the real code
      // to tell a misconfigured Firebase app from a user mistake.
      if (kDebugMode) {
        debugPrint('[auth] ${error.code}: ${error.message}');
      }
      throw AuthFailure(switch (error.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' => 'Email or password is incorrect. Try again.',
        'email-already-in-use' =>
          'An account already uses this email. Sign in instead.',
        'account-exists-with-different-credential' =>
          'This email uses a different sign-in method. Sign in with your existing password.',
        'credential-already-in-use' =>
          'This Google account belongs to another account. Sign out and use that account.',
        'user-disabled' => 'This account has been disabled.',
        'weak-password' =>
          'Choose a stronger password with letters and numbers.',
        'too-many-requests' =>
          'Too many attempts. Please wait before trying again.',
        'network-request-failed' => 'Check your connection and try again.',
        'popup-blocked' =>
          'Allow pop-ups for BookSwap and try Google sign-in again.',
        'operation-not-allowed' || 'unauthorized-domain' =>
          'This sign-in method is not configured yet. Please contact BookSwap.',
        'requires-recent-login' => 'Sign in again before continuing.',
        // Debug builds name the Firebase code on screen so a misconfigured
        // app (SHA-1, API key, client ID) is diagnosable without logcat.
        _ =>
          kDebugMode
              ? 'Unable to authenticate (${error.code}: ${error.message}). '
                    'Please try again.'
              : 'Unable to authenticate. Please try again.',
      });
    } on TimeoutException {
      throw const AuthFailure(
        'The connection took too long. Check your internet connection and try again.',
      );
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied') {
        throw const AuthFailure(
          'BookSwap cannot access your account profile yet. Please contact support to finish the database setup.',
        );
      }
      throw const AuthFailure(
        'Unable to load or save your account. Check your connection and try again.',
      );
    } on GoogleSignInException catch (_) {
      throw const AuthFailure(
        'Google sign-in could not finish. Please try again.',
      );
    }
  }

  Future<AuthUser> _readUser(firebase.User user, {String? notice}) async {
    // Sign-in and registration never authorize membership from an
    // offline/cached profile.
    final document = await _network(
      _store
          .collection('profiles')
          .doc(user.uid)
          .get(const GetOptions(source: Source.server)),
    );
    return _authUserFrom(user, document.data(), notice: notice);
  }

  AuthUser _authUserFrom(
    firebase.User user,
    Map<String, dynamic>? data, {
    String? notice,
  }) {
    ReaderProfile? profile;
    if (data != null) {
      // Profiles created before the Terms were removed still carry
      // acceptedTerms* fields; they are simply ignored.
      profile = ReaderProfile.fromMap(data);
    }
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      name: profile?.firstName ?? user.displayName ?? '',
      profile: profile,
      emailVerified: user.emailVerified,
      usesGoogle: user.providerData.any((p) => p.providerId == 'google.com'),
      notice: notice,
    );
  }

  /// Failures that mean "can't reach the server right now" rather than "this
  /// session is no longer valid".
  bool _isOffline(Object error) =>
      error is TimeoutException ||
      (error is FirebaseException &&
          const {
            'network-request-failed',
            'unavailable',
            'deadline-exceeded',
          }.contains(error.code));

  /// The member's profile from the on-device cache, or null when there isn't
  /// one (web keeps no offline cache, and a first launch has nothing yet).
  Future<AuthUser?> _cachedUser(firebase.User user) async {
    try {
      final document = await _store
          .collection('profiles')
          .doc(user.uid)
          .get(const GetOptions(source: Source.cache));
      if (!document.exists) return null;
      return _authUserFrom(user, document.data());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AuthUser?> restoreSession() async {
    try {
      return await _request(() async {
        final user = await _network(_auth.authStateChanges().first);
        if (user == null) return null;
        try {
          return await _refresh();
        } catch (error) {
          // Firebase still holds the session. A flaky or missing connection
          // at launch must not look like a sign-out, so fall back to the
          // cached profile; the live listeners catch up once back online.
          // Anything else (disabled account, revoked token) still fails.
          if (_isOffline(error)) {
            final cached = await _cachedUser(user);
            if (cached != null) return cached;
          }
          rethrow;
        }
      });
    } on AuthFailure catch (e) {
      if (kDebugMode) debugPrint('[auth] session restore failed: ${e.message}');
      throw SessionRestoreFailure(e.message);
    }
  }

  @override
  Future<AuthUser> signIn(String email, String password) => _request(() async {
    final result = await _network(
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password),
    );
    return _readUser(result.user!);
  });

  @override
  Future<AuthUser?> signInWithGoogle() => _request(() async {
    firebase.UserCredential result;
    try {
      if (kIsWeb) {
        final provider = firebase.GoogleAuthProvider()
          ..setCustomParameters({'prompt': 'select_account'});
        result = await _auth
            .signInWithPopup(provider)
            .timeout(
              googleTimeout,
              onTimeout: () {
                throw const AuthFailure(
                  'Google sign-in timed out. Close the Google window, then try again and complete sign-in in the popup.',
                );
              },
            );
      } else {
        _googleInitialization ??= GoogleSignIn.instance.initialize(
          clientId: const String.fromEnvironment('GOOGLE_IOS_CLIENT_ID').isEmpty
              ? null
              : const String.fromEnvironment('GOOGLE_IOS_CLIENT_ID'),
          serverClientId:
              const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID').isEmpty
              ? null
              : const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
        );
        await _network(_googleInitialization!);
        final account = await GoogleSignIn.instance.authenticate().timeout(
          googleTimeout,
          onTimeout: () {
            throw const AuthFailure(
              'Google sign-in timed out. Close Google sign-in and try again.',
            );
          },
        );
        final idToken = account.authentication.idToken;
        if (idToken == null || idToken.isEmpty) {
          // google_sign_in only returns an ID token when the web OAuth client
          // ID is passed as serverClientId; without it Firebase would be
          // handed an empty credential and fail with an opaque channel-error.
          throw AuthFailure(
            kDebugMode
                ? 'Google returned no ID token. Set GOOGLE_WEB_CLIENT_ID in '
                      'your --dart-define-from-file config to the web OAuth '
                      'client ID.'
                : 'Google sign-in is not available right now. Please use '
                      'email and password.',
          );
        }
        final credential = firebase.GoogleAuthProvider.credential(
          idToken: idToken,
        );
        result = await _network(_auth.signInWithCredential(credential));
      }
    } on firebase.FirebaseAuthException catch (error) {
      if ([
        'popup-closed-by-user',
        'cancelled-popup-request',
        'web-context-cancelled',
      ].contains(error.code)) {
        return null;
      }
      rethrow;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
    await _network(result.user!.reload());
    await _network(_auth.currentUser!.getIdToken(true));
    return _readUser(_auth.currentUser!);
  });

  @override
  Future<AuthUser> register(Registration registration) => _request(() async {
    var user = _auth.currentUser;
    final google =
        user?.providerData.any((p) => p.providerId == 'google.com') ?? false;
    final error = registration.validate(requirePassword: !google);
    if (error != null) throw AuthFailure(error);
    if (user == null) {
      user = (await _network(
        _auth.createUserWithEmailAndPassword(
          email: registration.email.trim(),
          password: registration.password,
        ),
      )).user!;
    } else if (user.email?.toLowerCase() !=
        registration.email.trim().toLowerCase()) {
      throw const AuthFailure(
        'Use the email of the account you signed in with, or sign out first.',
      );
    }
    final profile = _store.collection('profiles').doc(user.uid);
    // A minimal, member-readable doc so other users can see who owns a
    // book without ever reaching the full profile (phone/address/email) —
    // that one stays owner-only. Contact details are only ever revealed
    // through the borrow-request flow, not discovery.
    final publicProfile = _store.collection('public_profiles').doc(user.uid);
    // A retry can finish a partially-created account, but never replaces a profile.
    await _network(
      _store.runTransaction((transaction) async {
        final existing = await transaction.get(profile);
        if (!existing.exists) {
          transaction.set(profile, {
            ...ReaderProfile(registration).toMap(),
            'email': user!.email!.toLowerCase(),
          });
          transaction.set(publicProfile, {
            'firstName': registration.firstName.trim(),
          });
        }
      }),
    );
    String? notice;
    if (!user.emailVerified) {
      try {
        await _network(user.sendEmailVerification());
      } on Exception catch (_) {
        notice =
            'Your registration was saved, but the confirmation email could not be sent. Please use Resend email.';
      }
    }
    return _readUser(user, notice: notice);
  });

  @override
  Future<AuthUser> refreshSession() => _request(_refresh);

  Future<AuthUser> _refresh() async {
    final user = _auth.currentUser;
    if (user == null) throw const AuthFailure('Please sign in again.');
    await _network(user.reload());
    final fresh = _auth.currentUser;
    if (fresh == null) throw const AuthFailure('Please sign in again.');
    await _network(fresh.getIdToken(true));
    return _readUser(fresh);
  }

  @override
  Future<void> resendVerification() => _request(() async {
    final user = _auth.currentUser;
    if (user == null) throw const AuthFailure('Please sign in again.');
    await _network(user.reload());
    if (!_auth.currentUser!.emailVerified) {
      await _network(_auth.currentUser!.sendEmailVerification());
    }
  });

  @override
  Future<void> resetPassword(String email) => _request(
    () => _network(_auth.sendPasswordResetEmail(email: email.trim())),
  );

  @override
  Future<void> signOut() => _request(() => _network(_auth.signOut()));

  @override
  Future<void> updateMaxDistance(double? km) => _request(() async {
    final user = _auth.currentUser;
    if (user == null) throw const AuthFailure('Please sign in again.');
    await _network(
      _store.collection('profiles').doc(user.uid).update({'maxDistanceKm': km}),
    );
  });

  @override
  Future<void> updateProfile(ProfileUpdate update) => _request(() async {
    final error = update.validate();
    if (error != null) throw AuthFailure(error);
    final user = _auth.currentUser;
    if (user == null) throw const AuthFailure('Please sign in again.');
    final batch = _store.batch();
    batch.update(_store.collection('profiles').doc(user.uid), update.toMap());
    // Merge-set: accounts that predate public_profiles get the doc created.
    batch.set(_store.collection('public_profiles').doc(user.uid), {
      'firstName': update.firstName.trim(),
    }, SetOptions(merge: true));
    await _network(batch.commit());
  });
}
