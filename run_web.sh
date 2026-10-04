#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [ ! -f config/firebase.web.json ]; then
  echo 'Create config/firebase.web.json using docs/firebase-auth-setup.md first.' >&2
  exit 1
fi
exec flutter run -d chrome --web-port=7357 --dart-define-from-file=config/firebase.web.json "$@"
