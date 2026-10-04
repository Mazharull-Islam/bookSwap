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

## Architecture

Every feature under `lib/features/<feature>/` is split into four layers that
only depend inwards (`presentation → application → domain ← data`):

| Layer | Contains | May depend on |
|---|---|---|
| `domain/` | **Entities** (plain Dart), repository interfaces, pure rules and helpers | nothing but Dart |
| `application/` | Use cases | the domain |
| `data/` | **DTOs** (freezed + JSON), mappers, repository implementations (Firestore / Hive) | the domain |
| `presentation/` | Screens, widgets, Riverpod providers | the domain and application; only `providers/` may wire up `data/` |

The key split is **entity vs DTO**. An entity (`domain/entities/book.dart`) is
what the app reasons about and knows nothing about storage. A DTO
(`data/models/book_dto.dart`) mirrors how it is stored and owns all the freezed
and JSON code. Repositories convert between the two (`BookDto.parse(map)` and
`entity.toJson()`), so the domain never sees a storage format.

`test/architecture_test.dart` enforces these rules, so a stray import (for
example Flutter or Firestore inside `domain/`) fails the test run.

After changing a DTO, regenerate its code with:

```bash
dart run build_runner build --delete-conflicting-outputs
```
