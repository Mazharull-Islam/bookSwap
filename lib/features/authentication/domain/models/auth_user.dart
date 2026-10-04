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
