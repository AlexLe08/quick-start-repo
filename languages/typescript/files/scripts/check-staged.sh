#!/usr/bin/env bash
# The pre-commit hook's fast checks (.githooks/pre-commit): Prettier and
# ESLint on the given files only. scripts/check.sh runs the full set.
#
# Usage: scripts/check-staged.sh <file>...
set -euo pipefail

cd "$(dirname "$0")/.."
bin=node_modules/.bin
if [[ ! -x "$bin/prettier" ]]; then
  echo "check-staged: node_modules is missing; run {{PM_CI}} first" >&2
  exit 1
fi

failed=0
# Skips files Prettier has no parser for, and those in .prettierignore.
"$bin/prettier" --check --ignore-unknown --log-level warn "$@" || failed=1

code=()
for file in "$@"; do
  case "$file" in
    *.ts | *.mts | *.cts | *.js | *.mjs | *.cjs) code+=("$file") ;;
  esac
done
if ((${#code[@]})); then
  "$bin/eslint" --no-warn-ignored "${code[@]}" || failed=1
fi

exit "$failed"
