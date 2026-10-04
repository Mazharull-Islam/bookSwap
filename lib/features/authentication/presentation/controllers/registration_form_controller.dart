import 'package:flutter/widgets.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/registration.dart';

/// What the member has typed and chosen on the registration form, and how it
/// becomes a [Registration]. The screen only lays the form out.
class RegistrationFormController {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();
  final address = TextEditingController();
  final favoriteBook = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  String gender = 'Prefer not to say';
  List<String> preferences = [];

  /// Fills in what a signed-in account (for example Google) already tells us:
  /// the email, and the name if the member hasn't typed one.
  void prefillFrom(AuthUser? user) {
    if (user == null) return;
    email.text = user.email;
    if (firstName.text.isEmpty) {
      final names = user.name.trim().split(RegExp(r'\s+'));
      firstName.text = names.first;
      lastName.text = names.skip(1).join(' ');
    }
  }

  Registration toRegistration() => Registration(
    firstName: firstName.text,
    lastName: lastName.text,
    email: email.text,
    password: password.text,
    gender: gender,
    mobile: mobile.text,
    address: address.text,
    preferences: preferences,
    favoriteBook: favoriteBook.text,
  );

  void dispose() {
    for (final controller in [
      firstName,
      lastName,
      email,
      mobile,
      address,
      favoriteBook,
      password,
      confirmPassword,
    ]) {
      controller.dispose();
    }
  }
}
