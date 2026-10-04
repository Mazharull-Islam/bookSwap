import '../../domain/models/auth_user.dart';
import '../../domain/models/registration.dart';
import '../../domain/repositories/auth_repository.dart';

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
