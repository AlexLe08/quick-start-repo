#!/usr/bin/env bash
# The pre-commit hook's fast check (.githooks/pre-commit): formatting
# (Spotless, google-java-format) when a Java file is staged.
# `./gradlew spotlessApply` fixes it. scripts/check.sh runs the full set.
#
# Usage: scripts/check-staged.sh <file>...
set -euo pipefail

cd "$(dirname "$0")/.."

for file in "$@"; do
  case "$file" in
    *.java) exec ./gradlew --quiet spotlessCheck ;;
  esac
done
