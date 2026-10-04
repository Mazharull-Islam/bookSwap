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

**Features are independent blocks.** One feature may use another's `domain/`
(entities and rules) and its `presentation/providers/` (its state API), but
never its widgets, screens, data or application code:

- UI that several features need lives in `lib/shared/widgets`
  (for example `BookCoverImage`, `GenrePillList`, `RatingBadge`).
- Screens link to each other by route (for example `/forum/post/:postId`).
- A widget a feature shouldn't own is handed in by the router, as Discover
  receives the Book of the Month banner.
- Rules several features share, like the book match key, live in
  `lib/shared/domain`.

Common UI pieces live in `lib/shared/widgets` and should be used instead of
re-writing them: `EmptyState` (nothing-to-show screens), `StatusChip`
(status and count pills), `showMessage` (snackbars) and `showConfirmDialog`
(yes/no questions). A test fails if a screen builds its own.

`test/architecture_test.dart` enforces all of this, so a stray import (for
example Flutter or Firestore inside `domain/`, or one feature importing another
feature's widget) fails the test run. The few remaining exceptions are listed
by name in that file and the test fails if one becomes unnecessary.

After changing a DTO, regenerate its code with:

```bash
dart run build_runner build --delete-conflicting-outputs
```
