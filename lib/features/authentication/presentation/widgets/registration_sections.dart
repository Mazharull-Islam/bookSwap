import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/registration.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/registration_form_controller.dart';
import 'form_layout.dart';
import 'gender_dropdown.dart';
import 'genre_preferences_field.dart';
import 'password_input.dart';

/// Name, gender, mobile number and area.
class AboutYouSection extends StatelessWidget {
  const AboutYouSection({super.key, required this.form, required this.enabled});
  final RegistrationFormController form;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const FormSectionHeading(
        '01  About you',
        'All fields are required unless marked optional.',
      ),
      FieldPair(
        AppTextField(
          fieldKey: const Key('firstName'),
          controller: form.firstName,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          validator: (v) => requiredText(v, 'first name'),
          autofillHints: const [AutofillHints.givenName],
          label: 'First name',
        ),
        AppTextField(
          fieldKey: const Key('lastName'),
          controller: form.lastName,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          validator: (v) => requiredText(v, 'last name'),
          autofillHints: const [AutofillHints.familyName],
          label: 'Last name',
        ),
      ),
      const SizedBox(height: 18),
      FieldPair(
        GenderDropdown(
          key: const Key('gender'),
          value: form.gender,
          enabled: enabled,
          onChanged: (value) => form.gender = value,
        ),
        AppTextField(
          fieldKey: const Key('mobile'),
          controller: form.mobile,
          enabled: enabled,
          validator: validateMobile,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.telephoneNumber],
          label: 'Mobile number',
          hint: '+880 1XXXXXXXXX',
        ),
      ),
      const SizedBox(height: 18),
      AppTextField(
        fieldKey: const Key('address'),
        controller: form.address,
        enabled: enabled,
        validator: (v) => requiredText(v, 'area and city'),
        textInputAction: TextInputAction.next,
        maxLines: 2,
        label: 'Address (area and city)',
        hint: 'e.g. Board Bazar, Gazipur',
      ),
      const SizedBox(height: 6),
      const Text(
        'Your neighbourhood is enough. Do not enter your exact home address.',
        style: TextStyle(fontSize: 12),
      ),
    ],
  );
}

/// Genre preferences and a favourite book.
class ReadingWorldSection extends StatelessWidget {
  const ReadingWorldSection({
    super.key,
    required this.form,
    required this.enabled,
  });
  final RegistrationFormController form;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const FormSectionHeading(
        '02  Your reading world',
        'Choose at least one genre. You can choose more than one.',
      ),
      GenrePreferencesField(
        initialValue: const [],
        enabled: enabled,
        onChanged: (next) => form.preferences = next,
      ),
      const SizedBox(height: 18),
      AppTextField(
        fieldKey: const Key('favoriteBook'),
        controller: form.favoriteBook,
        enabled: enabled,
        textInputAction: TextInputAction.next,
        label: 'Favorite book (optional)',
        hint: 'The book you always recommend',
      ),
    ],
  );
}

/// Email, and (unless Google has already verified it) a password.
class AccountSection extends StatelessWidget {
  const AccountSection({
    super.key,
    required this.form,
    required this.enabled,
    required this.emailEnabled,
    required this.google,
  });
  final RegistrationFormController form;
  final bool enabled;

  /// False once an account is signed in: its email is fixed.
  final bool emailEnabled;
  final bool google;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      FormSectionHeading(
        '03  Your account',
        google
            ? 'Your Google email is verified. No password is needed.'
            : 'Use your email and password to sign in.',
      ),
      AppTextField(
        fieldKey: const Key('email'),
        controller: form.email,
        enabled: emailEnabled,
        validator: validateEmail,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        label: 'Email address',
      ),
      const SizedBox(height: 18),
      if (!google) ...[
        FieldPair(
          PasswordInput(
            fieldKey: const Key('password'),
            controller: form.password,
            label: 'Password',
            validator: validateNewPassword,
            enabled: enabled,
            newPassword: true,
          ),
          PasswordInput(
            fieldKey: const Key('confirmPassword'),
            controller: form.confirmPassword,
            label: 'Confirm password',
            validator: (v) => v == null || v.isEmpty
                ? 'Confirm your password.'
                : v != form.password.text
                ? 'Passwords do not match.'
                : null,
            enabled: enabled,
            newPassword: true,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'At least 8 characters, including a letter and a number.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    ],
  );
}
