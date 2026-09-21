import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/features/auth/application/auth_controller.dart';
import 'package:bookswap_login/features/auth/domain/auth_repository.dart';
import 'support/demo_auth_repository.dart';
import 'registration_test.dart' show details;

void main() {
  test('Cancelled Google sign-in does not create a session', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(DemoAuthRepository()),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authControllerProvider.future);
    await container.read(authControllerProvider.notifier).signInWithGoogle();
    expect(container.read(authControllerProvider).valueOrNull, isNull);
    expect(container.read(authControllerProvider).hasError, isFalse);
  });

  test(
    'Failed verification refresh keeps the pending account recoverable',
    () async {
      final repository = DemoAuthRepository();
      await repository.register(details());
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);
      repository.failRefresh = true;
      await container.read(authControllerProvider.notifier).refreshSession();
      expect(container.read(authControllerProvider).hasError, isTrue);
      expect(
        container.read(authControllerProvider).valueOrNull!.email,
        'sam@example.com',
      );
      expect(
        container.read(authControllerProvider).valueOrNull!.isMember,
        isFalse,
      );
      repository.failRefresh = false;
      repository.verifyEmail('sam@example.com');
      await container.read(authControllerProvider.notifier).refreshSession();
      expect(
        container.read(authControllerProvider).valueOrNull!.isMember,
        isTrue,
      );
    },
  );

  test(
    'Google identity without a profile remains outside membership',
    () async {
      final repository = DemoAuthRepository()
        ..nextGoogleUser = const AuthUser(
          id: 'google',
          email: 'sam@example.com',
          name: 'Sam Reader',
          emailVerified: true,
          usesGoogle: true,
        );
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);
      await container.read(authControllerProvider.notifier).signInWithGoogle();
      expect(
        container.read(authControllerProvider).valueOrNull!.isMember,
        isFalse,
      );
      await container.read(authControllerProvider.notifier).register(details());
      expect(
        container.read(authControllerProvider).valueOrNull!.isMember,
        isTrue,
      );
      expect(repository.verificationEmails, 0);
    },
  );
}
