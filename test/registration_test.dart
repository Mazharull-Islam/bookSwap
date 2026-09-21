import 'package:flutter_test/flutter_test.dart';
import 'support/demo_auth_repository.dart';
import 'package:bookswap_login/features/auth/domain/auth_repository.dart';
import 'package:bookswap_login/features/auth/domain/registration.dart';

Registration details({
  bool accepted = true,
  String email = 'sam@example.com',
  List<String> preferences = const ['Fiction'],
}) => Registration(
  firstName: 'Sam',
  lastName: 'Reader',
  email: email,
  password: 'Reading123',
  gender: 'Prefer not to say',
  mobile: '+8801712345678',
  address: 'Gazipur',
  preferences: preferences,
  favoriteBook: 'The Hobbit',
  acceptedTerms: accepted,
);

void main() {
  test(
    'Registration records profile and consent, then supports sign-in',
    () async {
      final repo = DemoAuthRepository();
      final user = await Register(repo)(details());
      expect(user.profile!.preferences, ['Fiction']);
      expect(user.profile!.acceptedTermsVersion, termsVersion);
      expect(user.profile!.acceptedTermsAt.isUtc, isTrue);
      expect(user.isMember, isFalse);
      expect(repo.verificationEmails, 1);
      repo.verifyEmail(user.email);
      await repo.signOut();
      expect(
        (await SignIn(repo)(' SAM@EXAMPLE.COM ', 'Reading123')).id,
        user.id,
      );
    },
  );
  test('Missing consent and empty preferences are rejected before saving', () {
    final register = Register(DemoAuthRepository());
    expect(
      () => register(details(accepted: false)),
      throwsA(isA<AuthFailure>()),
    );
    expect(
      () => register(details(preferences: [])),
      throwsA(isA<AuthFailure>()),
    );
  });
  test('Duplicate email cannot replace an account', () async {
    final register = Register(DemoAuthRepository());
    await register(details());
    await expectLater(
      register(details(email: ' SAM@example.com ')),
      throwsA(isA<AuthFailure>()),
    );
  });
  test('Restart clears temporary accounts', () async {
    await Register(DemoAuthRepository())(details());
    await expectLater(
      SignIn(DemoAuthRepository())('sam@example.com', 'Reading123'),
      throwsA(isA<AuthFailure>()),
    );
  });
  test('Invalid phone and weak passwords are rejected', () {
    expect(validateMobile('abc01712345678'), isNotNull);
    expect(validateMobile('123'), isNotNull);
    expect(validateNewPassword('abcdefgh'), isNotNull);
    expect(validateNewPassword('Reading123'), isNull);
  });
}
