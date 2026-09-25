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
        _ => 'Unable to authenticate. Please try again.',
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
    // Do not authorize membership from an offline/cached profile.
    final document = await _network(
      _store
          .collection('profiles')
          .doc(user.uid)
          .get(const GetOptions(source: Source.server)),
    );
    final data = document.data();
    ReaderProfile? profile;
    if (data != null) {
      profile = ReaderProfile.fromMap({
        ...data,
        'acceptedTermsAt': (data['acceptedTermsAt'] as Timestamp)
            .toDate()
            .toUtc()
            .toIso8601String(),
      });
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

  @override
  Future<AuthUser?> restoreSession() => _request(() async {
    final user = await _network(_auth.authStateChanges().first);
    if (user == null) return null;
    return refreshSession();
  });

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
        final credential = firebase.GoogleAuthProvider.credential(
          idToken: account.authentication.idToken,
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
            'acceptedTermsAt': FieldValue.serverTimestamp(),
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
  Future<AuthUser> refreshSession() => _request(() async {
    final user = _auth.currentUser;
    if (user == null) throw const AuthFailure('Please sign in again.');
    await _network(user.reload());
    final fresh = _auth.currentUser;
    if (fresh == null) throw const AuthFailure('Please sign in again.');
    await _network(fresh.getIdToken(true));
    return _readUser(fresh);
  });

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
}
