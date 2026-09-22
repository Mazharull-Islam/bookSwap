import '../repositories/auth_repository.dart';

const termsVersion = '1.1';
const bookGenres = [
  'Fiction',
  'Mystery',
  'Fantasy',
  'Science fiction',
  'Romance',
  'History',
  'Biography',
  'Self-development',
  'Science & technology',
  'Academic',
  'Poetry',
  'Other',
];
const genders = [
  'Woman',
  'Man',
  'Non-binary',
  'Self-described / other',
  'Prefer not to say',
];

String? requiredText(String? value, String label) {
  if (value == null || value.trim().isEmpty) return 'Enter your $label.';
  final limit = label == 'area and city' ? 200 : 100;
  return value.trim().length > limit
      ? 'Use at most $limit characters for your $label.'
      : null;
}

String? validateMobile(String? input) {
  final value = input?.trim() ?? '';
  if (value.isEmpty) return 'Enter your mobile number.';
  if (value.length > 32 || !RegExp(r'^\+?[0-9 ()-]+$').hasMatch(value)) {
    return 'Use a valid mobile number.';
  }
  final digits = value.replaceAll(RegExp(r'\D'), '');
  return digits.length < 10 || digits.length > 15
      ? 'Use 10–15 digits, including country code if needed.'
      : null;
}

String? validateNewPassword(String? input) {
  if (input == null || input.length < 8) return 'Use at least 8 characters.';
  if (!RegExp(r'[A-Za-z]').hasMatch(input) ||
      !RegExp(r'[0-9]').hasMatch(input)) {
    return 'Include a letter and a number.';
  }
  return null;
}

class Registration {
  Registration({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.mobile,
    required this.address,
    required List<String> preferences,
    required this.favoriteBook,
    required this.acceptedTerms,
  }) : preferences = List.unmodifiable(preferences);
  final String firstName,
      lastName,
      email,
      password,
      gender,
      mobile,
      address,
      favoriteBook;
  final List<String> preferences;
  final bool acceptedTerms;

  String? validate({bool requirePassword = true}) {
    return requiredText(firstName, 'first name') ??
        requiredText(lastName, 'last name') ??
        validateEmail(email) ??
        (requirePassword ? validateNewPassword(password) : null) ??
        (!genders.contains(gender) ? 'Choose a gender option.' : null) ??
        validateMobile(mobile) ??
        requiredText(address, 'area and city') ??
        (favoriteBook.trim().length > 200
            ? 'Use at most 200 characters for your favorite book.'
            : null) ??
        (preferences.isEmpty || preferences.any((p) => !bookGenres.contains(p))
            ? 'Choose at least one book preference.'
            : null) ??
        (!acceptedTerms ? 'Accept the Terms & Conditions to continue.' : null);
  }
}

class ReaderProfile {
  ReaderProfile.fromMap(Map<String, dynamic> data)
    : firstName = data['firstName'] as String,
      lastName = data['lastName'] as String,
      gender = data['gender'] as String,
      mobile = data['mobile'] as String,
      address = data['address'] as String,
      preferences = List<String>.unmodifiable(data['preferences'] as List),
      favoriteBook = data['favoriteBook'] as String,
      acceptedTermsVersion = data['acceptedTermsVersion'] as String,
      acceptedTermsAt = DateTime.parse(
        data['acceptedTermsAt'] as String,
      ).toUtc();

  Map<String, dynamic> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'gender': gender,
    'mobile': mobile,
    'address': address,
    'preferences': preferences,
    'favoriteBook': favoriteBook,
    'acceptedTermsVersion': acceptedTermsVersion,
    'acceptedTermsAt': acceptedTermsAt.toIso8601String(),
  };

  ReaderProfile(Registration data)
    : firstName = data.firstName.trim(),
      lastName = data.lastName.trim(),
      gender = data.gender,
      mobile = data.mobile.trim(),
      address = data.address.trim(),
      preferences = List.unmodifiable(data.preferences),
      favoriteBook = data.favoriteBook.trim(),
      acceptedTermsVersion = termsVersion,
      acceptedTermsAt = DateTime.now().toUtc();
  final String firstName, lastName, gender, mobile, address, favoriteBook;
  final List<String> preferences;
  final String acceptedTermsVersion;
  final DateTime acceptedTermsAt;
}
