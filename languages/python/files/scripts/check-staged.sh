#!/usr/bin/env bash
# The pre-commit hook's fast checks (.githooks/pre-commit): ruff's
# formatter and linter on the given Python files only. scripts/check.sh
# runs the full set.
#
# Usage: scripts/check-staged.sh <file>...
set -euo pipefail

cd "$(dirname "$0")/.."

code=()
for file in "$@"; do
  case "$file" in
    *.py | *.pyi) code+=("$file") ;;
  esac
done
((${#code[@]})) || exit 0

failed=0
# --force-exclude keeps ruff's own excludes for files named here.
uv run --quiet ruff format --check --force-exclude "${code[@]}" || failed=1
uv run --quiet ruff check --force-exclude "${code[@]}" || failed=1

exit "$failed"
