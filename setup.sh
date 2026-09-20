#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if ! command -v flutter >/dev/null 2>&1; then
  echo 'Flutter is not on PATH. Install Flutter or open a terminal with Flutter available.' >&2
  exit 1
fi
# Generate native wrappers with YOUR Flutter SDK, preserving supplied Dart files.
staging_dir="$(mktemp -d)"
trap 'rm -rf "$staging_dir"' EXIT
flutter create --no-pub --platforms=android,ios,web --project-name=bookswap_login "$staging_dir/app"
for platform in android ios web; do
  if [ ! -d "$platform" ]; then
    cp -R "$staging_dir/app/$platform" "$platform"
  fi
done
if [ ! -f .metadata ]; then cp "$staging_dir/app/.metadata" .metadata; fi
flutter pub get
dart format lib test
flutter analyze
flutter test
echo 'Ready. Run: flutter run -d chrome'
