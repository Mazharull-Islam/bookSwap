import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookswap_login/app/theme.dart';
import 'package:bookswap_login/features/authentication/domain/entities/auth_user.dart';
import 'package:bookswap_login/features/authentication/domain/entities/registration.dart';
import 'package:bookswap_login/features/authentication/presentation/controllers/registration_form_controller.dart';
import 'package:bookswap_login/features/authentication/presentation/widgets/form_layout.dart';
import 'package:bookswap_login/features/authentication/presentation/widgets/gender_dropdown.dart';
import 'package:bookswap_login/features/authentication/presentation/widgets/genre_preferences_field.dart';
import 'package:bookswap_login/features/authentication/presentation/widgets/registration_sections.dart';

Widget host(Widget child, {double width = 800}) => MaterialApp(
  theme: buildTheme(Brightness.light),
  home: Scaffold(
    body: Center(
      child: SizedBox(
        width: width,
        child: SingleChildScrollView(child: child),
      ),
    ),
  ),
);

AuthUser account(String name, {String email = 'sam@example.com'}) =>
    AuthUser(id: 'u', email: email, name: name, emailVerified: true);

void main() {
  group('RegistrationFormController', () {
    late RegistrationFormController form;

    setUp(() => form = RegistrationFormController());
    tearDown(() => form.dispose());

    test('starts blank with the neutral gender choice', () {
      expect(form.firstName.text, isEmpty);
      expect(form.email.text, isEmpty);
      expect(form.gender, 'Prefer not to say');
      expect(form.preferences, isEmpty);
    });

    test('prefilling from an account sets the email and splits the name', () {
      form.prefillFrom(account('Sam Reader'));
      expect(form.email.text, 'sam@example.com');
      expect(form.firstName.text, 'Sam');
      expect(form.lastName.text, 'Reader');
    });

    test('everything after the first name is the last name', () {
      form.prefillFrom(account('Mary Jane Watson'));
      expect(form.firstName.text, 'Mary');
      expect(form.lastName.text, 'Jane Watson');
    });

    test('a single name leaves the last name empty', () {
      form.prefillFrom(account('Cher'));
      expect(form.firstName.text, 'Cher');
      expect(form.lastName.text, isEmpty);
    });

    test('extra spaces in the account name do not matter', () {
      form.prefillFrom(account('  Sam   Reader  '));
      expect(form.firstName.text, 'Sam');
      expect(form.lastName.text, 'Reader');
    });

    test('a name the member already typed is not overwritten', () {
      form.firstName.text = 'Samantha';
      form.lastName.text = 'Typed';
      form.prefillFrom(account('Sam Reader'));
      expect(form.firstName.text, 'Samantha');
      expect(form.lastName.text, 'Typed');
      expect(
        form.email.text,
        'sam@example.com',
        reason: 'the email still follows the account',
      );
    });

    test('prefilling with nobody signed in changes nothing', () {
      form.prefillFrom(null);
      expect(form.email.text, isEmpty);
      expect(form.firstName.text, isEmpty);
    });

    test('builds the registration from what was entered', () {
      form.firstName.text = 'Sam';
      form.lastName.text = 'Reader';
      form.email.text = 'sam@example.com';
      form.password.text = 'Reading123';
      form.mobile.text = '+8801712345678';
      form.address.text = 'Gazipur';
      form.favoriteBook.text = 'The Hobbit';
      form.gender = 'Man';
      form.preferences = ['Fiction', 'Fantasy'];
      final r = form.toRegistration();
      expect(r.firstName, 'Sam');
      expect(r.lastName, 'Reader');
      expect(r.email, 'sam@example.com');
      expect(r.password, 'Reading123');
      expect(r.mobile, '+8801712345678');
      expect(r.address, 'Gazipur');
      expect(r.favoriteBook, 'The Hobbit');
      expect(r.gender, 'Man');
      expect(r.preferences, ['Fiction', 'Fantasy']);
      expect(r.validate(), isNull);
    });

    test('an incomplete form does not validate as a registration', () {
      expect(form.toRegistration().validate(), isNotNull);
    });
  });

  group('GenrePreferencesField', () {
    testWidgets('shows every genre and starts with the given choices', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          GenrePreferencesField(
            initialValue: const ['Fantasy'],
            enabled: true,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.byType(FilterChip), findsNWidgets(bookGenres.length));
      final fantasy = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'Fantasy'),
      );
      expect(fantasy.selected, isTrue);
      final mystery = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'Mystery'),
      );
      expect(mystery.selected, isFalse);
    });

    testWidgets('tapping chips reports the new list, and untapping removes', (
      tester,
    ) async {
      List<String>? latest;
      await tester.pumpWidget(
        host(
          GenrePreferencesField(
            initialValue: const [],
            enabled: true,
            onChanged: (next) => latest = next,
          ),
        ),
      );
      await tester.tap(find.widgetWithText(FilterChip, 'Fantasy'));
      await tester.pump();
      expect(latest, ['Fantasy']);
      await tester.tap(find.widgetWithText(FilterChip, 'Mystery'));
      await tester.pump();
      expect(latest, ['Fantasy', 'Mystery']);
      await tester.tap(find.widgetWithText(FilterChip, 'Fantasy'));
      await tester.pump();
      expect(latest, ['Mystery']);
    });

    testWidgets('choosing nothing fails validation with a clear message', (
      tester,
    ) async {
      final form = GlobalKey<FormState>();
      await tester.pumpWidget(
        host(
          Form(
            key: form,
            child: GenrePreferencesField(
              initialValue: const [],
              enabled: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(form.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Choose at least one book preference.'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilterChip, 'Poetry'));
      await tester.pump();
      expect(form.currentState!.validate(), isTrue);
    });

    testWidgets('when disabled the chips cannot be changed', (tester) async {
      var changes = 0;
      await tester.pumpWidget(
        host(
          GenrePreferencesField(
            initialValue: const [],
            enabled: false,
            onChanged: (_) => changes++,
          ),
        ),
      );
      await tester.tap(
        find.widgetWithText(FilterChip, 'Fantasy'),
        warnIfMissed: false,
      );
      await tester.pump();
      expect(changes, 0);
      expect(
        tester
            .widget<FilterChip>(find.widgetWithText(FilterChip, 'Fantasy'))
            .onSelected,
        isNull,
      );
    });
  });

  group('GenderDropdown', () {
    testWidgets('shows the current choice and reports a new one', (
      tester,
    ) async {
      String? chosen;
      await tester.pumpWidget(
        host(
          GenderDropdown(
            value: 'Prefer not to say',
            enabled: true,
            onChanged: (v) => chosen = v,
          ),
        ),
      );
      expect(find.text('Prefer not to say'), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Woman').last);
      await tester.pumpAndSettle();
      expect(chosen, 'Woman');
    });

    testWidgets('when disabled it cannot be opened', (tester) async {
      await tester.pumpWidget(
        host(GenderDropdown(value: 'Man', enabled: false, onChanged: (_) {})),
      );
      await tester.tap(
        find.byType(DropdownButtonFormField<String>),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(find.text('Woman'), findsNothing);
    });
  });

  group('form layout', () {
    testWidgets('a pair sits side by side when there is room', (tester) async {
      await tester.pumpWidget(
        host(const FieldPair(Text('first'), Text('second')), width: 800),
      );
      final a = tester.getTopLeft(find.text('first'));
      final b = tester.getTopLeft(find.text('second'));
      expect(a.dy, b.dy);
      expect(b.dx, greaterThan(a.dx));
    });

    testWidgets('a pair stacks on a narrow screen', (tester) async {
      await tester.pumpWidget(
        host(const FieldPair(Text('first'), Text('second')), width: 400),
      );
      final a = tester.getCenter(find.text('first'));
      final b = tester.getCenter(find.text('second'));
      expect(b.dy, greaterThan(a.dy));
      expect(b.dx, closeTo(a.dx, 0.5), reason: 'stacked on one centre line');
    });

    testWidgets('a section heading is announced as a heading', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(const FormSectionHeading('01  About you', 'All fields required.')),
      );
      expect(find.text('01  About you'), findsOneWidget);
      expect(find.text('All fields required.'), findsOneWidget);
      expect(
        tester.getSemantics(find.text('01  About you')),
        matchesSemantics(label: '01  About you', isHeader: true),
      );
      handle.dispose();
    });
  });

  group('registration sections', () {
    late RegistrationFormController form;

    setUp(() => form = RegistrationFormController());
    tearDown(() => form.dispose());

    testWidgets('About you has the personal fields, and they are editable', (
      tester,
    ) async {
      await tester.pumpWidget(host(AboutYouSection(form: form, enabled: true)));
      for (final key in [
        'firstName',
        'lastName',
        'gender',
        'mobile',
        'address',
      ]) {
        expect(find.byKey(Key(key)), findsOneWidget, reason: key);
      }
      await tester.enterText(find.byKey(const Key('firstName')), 'Sam');
      expect(form.firstName.text, 'Sam');
    });

    testWidgets('picking a gender updates the form', (tester) async {
      await tester.pumpWidget(host(AboutYouSection(form: form, enabled: true)));
      await tester.tap(find.byKey(const Key('gender')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Non-binary').last);
      await tester.pumpAndSettle();
      expect(form.gender, 'Non-binary');
    });

    testWidgets('Reading world records the chosen genres', (tester) async {
      await tester.pumpWidget(
        host(ReadingWorldSection(form: form, enabled: true)),
      );
      await tester.tap(find.widgetWithText(FilterChip, 'Romance'));
      await tester.pump();
      expect(form.preferences, ['Romance']);
      expect(find.byKey(const Key('favoriteBook')), findsOneWidget);
    });

    testWidgets(
      'Account asks for a password unless Google verified the email',
      (tester) async {
        await tester.pumpWidget(
          host(
            AccountSection(
              form: form,
              enabled: true,
              emailEnabled: true,
              google: false,
            ),
          ),
        );
        expect(find.byKey(const Key('password')), findsOneWidget);
        expect(find.byKey(const Key('confirmPassword')), findsOneWidget);

        await tester.pumpWidget(
          host(
            AccountSection(
              form: form,
              enabled: true,
              emailEnabled: false,
              google: true,
            ),
          ),
        );
        expect(find.byKey(const Key('password')), findsNothing);
        expect(find.textContaining('No password is needed'), findsOneWidget);
      },
    );

    testWidgets('a signed-in account\'s email cannot be edited', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          AccountSection(
            form: form,
            enabled: true,
            emailEnabled: false,
            google: true,
          ),
        ),
      );
      final email = tester.widget<TextFormField>(
        find.byKey(const Key('email')),
      );
      expect(email.enabled, isFalse);
    });

    testWidgets('confirming a different password is an error', (tester) async {
      final key = GlobalKey<FormState>();
      await tester.pumpWidget(
        host(
          Form(
            key: key,
            child: AccountSection(
              form: form,
              enabled: true,
              emailEnabled: true,
              google: false,
            ),
          ),
        ),
      );
      await tester.enterText(find.byKey(const Key('password')), 'Reading123');
      await tester.enterText(
        find.byKey(const Key('confirmPassword')),
        'Different123',
      );
      key.currentState!.validate();
      await tester.pump();
      expect(find.text('Passwords do not match.'), findsOneWidget);
    });

    testWidgets('while busy every field is disabled', (tester) async {
      await tester.pumpWidget(
        host(AboutYouSection(form: form, enabled: false)),
      );
      final first = tester.widget<TextFormField>(
        find.byKey(const Key('firstName')),
      );
      expect(first.enabled, isFalse);
    });
  });
}
