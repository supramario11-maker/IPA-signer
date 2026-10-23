#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 || ! -f "$1" ]]; then
  echo "Usage: $0 path/to/app.ipa" >&2
  exit 2
fi
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
unzip -t "$1"
unzip -q "$1" -d "$TMP"
APP=$(find "$TMP/Payload" -maxdepth 1 -type d -name '*.app' -print -quit)
[[ -n "$APP" ]] || { echo "Error: no Payload/*.app bundle found" >&2; exit 1; }
if command -v plutil >/dev/null 2>&1; then
  plutil -extract CFBundleIdentifier raw "$APP/Info.plist"
  plutil -extract CFBundleExecutable raw "$APP/Info.plist"
else
  echo "Found app bundle: $APP"
  echo "Install plutil to inspect Info.plist fields."
fi
