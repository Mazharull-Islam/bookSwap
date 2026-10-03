# bookSwap

Configure Firebase using [the authentication setup guide](docs/firebase-auth-setup.md), then run:

```sh
bash setup.sh
flutter run -d chrome --web-port=5000 --dart-define-from-file=config/firebase.web.json
```

Keep the port fixed: a browser stores the saved sign-in per address, and
`flutter run -d chrome` otherwise picks a new random port each time, which
looks like being signed out on every launch. On a phone or emulator the
sign-in is kept automatically:

```sh
flutter run -d <device-id> --dart-define-from-file=config/firebase.android.json
```

Email/password registration requires email confirmation. Google users must complete the registration form; Google's verified email satisfies verification.
