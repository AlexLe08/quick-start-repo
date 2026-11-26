#!/usr/bin/env bash
# The pre-commit hook's fast check (.githooks/pre-commit): whitespace and
# layout of the given C# files, without building. scripts/check.sh runs
# the full `dotnet format` (style and analyzers), the build and the tests.
#
# Usage: scripts/check-staged.sh <file>...
set -euo pipefail

cd "$(dirname "$0")/.."

code=()
for file in "$@"; do
  case "$file" in
    *.cs) code+=("$file") ;;
  esac
done
((${#code[@]})) || exit 0

dotnet format whitespace . --folder --verify-no-changes --include "${code[@]}"
