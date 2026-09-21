# BookSwap authentication setup

BookSwap now uses Firebase Authentication and Cloud Firestore. There is no production demo-account fallback; without configuration, the app shows a setup message. Existing in-memory demo accounts were never stored and must register again.

## Membership flow

- Email/password: complete registration → profile saved → Firebase confirmation email → open the link → return to BookSwap and select **I have verified my email**.
- Google sign-up: select Google account → prefilled, locked email and suggested name → complete all required profile fields and accept terms → membership activated. Google already verifies the email; no extra BookSwap verification email is sent.
- Google sign-in: an existing profile plus verified email opens the home screen. A Google identity without a profile must complete registration first.
- Refresh/restart restores Firebase authentication, fetches the profile from the server, and returns to the correct registration, verification, or home screen.
- Password reset is available from login after entering the email. Verification can be resent; Firebase also enforces its own email rate limits.

Passwords are handled by Firebase Authentication and are never saved in Firestore. Profiles are private to their owner. The production app never uses the in-memory repository in `test/support`.

## Firebase project

1. Create or select your Firebase project. Register a web app (and Android/iOS apps if you will run those platforms).
2. In **Authentication → Sign-in method**, enable **Email/Password** and **Google**, set the Google support email, and keep **one account per email address** enabled. This lets Firebase use the same identity for a registered Gmail address and Google login. Do not enable multiple accounts per email.
3. In **Authentication → Settings → Authorized domains**, add your actual web hostname and `localhost` for local development. Configure OAuth consent/test users if the Google project requires them.
4. In **Authentication → Templates**, customize the verification email's sender display name to BookSwap and its subject/body to explain that the account was created and needs confirmation. Keep Firebase's default email action handler unless you implement another. Check password-reset templates too.
5. Create a **Cloud Firestore** database, then deploy this repository's rules using a Firebase CLI authenticated to the intended project:

   ```sh
   firebase deploy --only firestore:rules --project YOUR_PROJECT_ID
   ```

   Do not leave Firestore in test mode. `profiles/{uid}` accepts only a complete, validated profile with server-timestamped consent. Other users cannot read it or change consent. The `member()` helper requires both an existing profile and a verified Firebase token; `/books` uses it for reads and denies writes until the book feature is implemented. Other collections are denied by default.

6. Copy `config/firebase.example.json` to `config/firebase.web.json`. Fill in the web app's Firebase config:

   | Firebase console field | JSON key |
   | --- | --- |
   | `apiKey` | `FIREBASE_API_KEY` |
   | `appId` | `FIREBASE_APP_ID` |
   | `messagingSenderId` | `FIREBASE_MESSAGING_SENDER_ID` |
   | `projectId` | `FIREBASE_PROJECT_ID` |
   | `authDomain` | `FIREBASE_AUTH_DOMAIN` |
   | `storageBucket` (optional) | `FIREBASE_STORAGE_BUCKET` |

   Firebase client config is public configuration, not a service-account credential. Never add service-account private keys, SMTP passwords, or OAuth client secrets to the app. Local config files are gitignored.

7. Run the web app:

   ```sh
   flutter pub get
   flutter run -d chrome --dart-define-from-file=config/firebase.web.json
   ```

   Web uses Firebase's Google popup flow. Allow popups for the app. For a release build, pass the same configuration to `flutter build web`.

## Android

- Register the Android app using the actual `applicationId` in `android/app/build.gradle.kts` (currently `com.example.bookswap_login`). Use your own app ID before release.
- Add the development and release signing certificates' SHA-1/SHA-256 fingerprints in Firebase project settings.
- Make an Android config file from the example, using the Android Firebase `appId`/API key and the same project/sender ID. Set `GOOGLE_WEB_CLIENT_ID` to the **Web application** OAuth client ID from this Google project, not its Android client ID. The Google Sign-In plugin receives it as its server client ID, so a `google-services.json` Gradle integration is not required for this explicit-configuration path.
- Run `flutter run --dart-define-from-file=config/firebase.android.json` on an Android device with Google Play services.

## iOS

- Register the actual Runner bundle ID in Firebase. Use an iOS config file with its Firebase `appId` and API key; set `FIREBASE_IOS_BUNDLE_ID`, `GOOGLE_IOS_CLIENT_ID`, and `GOOGLE_WEB_CLIENT_ID` from that project.
- In Runner's `Info.plist`, add the URL scheme given by `REVERSED_CLIENT_ID` in the app's downloaded `GoogleService-Info.plist`. The client IDs are passed explicitly during Google initialization, but the callback URL scheme is still required. Never invent this value.
- iOS deployment target is already 15.0. Run on a configured iOS simulator/device with `--dart-define-from-file=config/firebase.ios.json`.

## Verification

```sh
flutter analyze
flutter test
flutter build web --dart-define-from-file=config/firebase.web.json
cd test/firestore
npm ci
npm test
```

The rules tests use the local Firestore emulator and the synthetic `demo-bookswap` project, not production data. Java 21+ is required by recent Firebase emulators.

With the real project configured, manually verify:

1. A new password account receives the email and cannot reach home before confirmation; resend and password reset work.
2. Open the email link, return to the app, refresh verification, and reach home. Repeat after restarting the app.
3. Sign out and select the same Gmail account using Google; the existing BookSwap profile is retained.
4. Select a new Google account; it stays on registration until every required field and terms consent are supplied. No password is requested.
5. Close the Google popup; no new session or error is shown. Wrong passwords, offline access, duplicate emails, and email throttling display useful errors.
6. Repeat the Google flow on each supported native platform after configuring its OAuth callbacks and signing certificates.

## References

- [Firebase Flutter Google authentication](https://firebase.google.com/docs/auth/flutter/federated-auth)
- [Email verification and password reset](https://firebase.google.com/docs/auth/flutter/manage-users)
- [Google Sign-In Android setup](https://pub.dev/packages/google_sign_in_android)
- [Google Sign-In iOS setup](https://pub.dev/packages/google_sign_in_ios)
