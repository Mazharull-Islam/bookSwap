import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/features/auth/data/demo_auth_repository.dart';
import 'package:bookswap_login/features/auth/domain/auth_repository.dart';

void main() {
  test('Rejects malformed input before authenticating', () {
    expect(validateEmail('wrong'), isNotNull);
    expect(validateEmail(' reader@bookswap.app '), isNull);
    expect(validatePassword(''), isNotNull);
  });
  test('Demo sign-in accepts trimmed email and exact password', () async {
    final user = await SignIn(DemoAuthRepository())(
      ' reader@bookswap.app ',
      DemoAuthRepository.password,
    );
    expect(user.id, 'demo-reader');
  });
  test('Wrong passwords never create a demo session', () async {
    await expectLater(
      SignIn(DemoAuthRepository())(DemoAuthRepository.email, 'wrong'),
      throwsA(isA<AuthFailure>()),
    );
  });
}
