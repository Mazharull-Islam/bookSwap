# bookSwap

Configure Firebase using [the authentication setup guide](docs/firebase-auth-setup.md), then run:

```sh
bash setup.sh
flutter run -d chrome --dart-define-from-file=config/firebase.web.json
```

Email/password registration requires email confirmation. Google users must complete the registration form; Google's verified email satisfies verification.
