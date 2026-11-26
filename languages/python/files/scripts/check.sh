#!/usr/bin/env bash
# The checks CI runs (.github/workflows/ci.yml, the `check` job): ruff's
# lint and formatting, the type check, then the tests with coverage.
# Prints one line per step; the full output of each goes to
# .logs/<step>.log, and a failing step also prints its last 30 lines.
#
# Usage: scripts/check.sh
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
logs="$root/.logs"
mkdir -p "$logs"
cd "$root"
failed=0

# run <name> <command...>
run() {
  local name=$1
  shift
  local log="$logs/$name.log"
  if "$@" >"$log" 2>&1; then
    echo "pass  $name"
  else
    echo "FAIL  $name  (full log: .logs/$name.log)"
    tail -n 30 "$log"
    failed=1
  fi
}

run lint uv run ruff check .
run format uv run ruff format --check .
run typecheck uv run {{TYPECHECK}}
run test uv run pytest -q

# Spelling, as CI's typos job (spelling.yml) checks it, where typos is
# installed (`brew install typos-cli`).
if command -v typos >/dev/null 2>&1; then
  run spelling typos
else
  echo "skip  spelling  (typos isn't installed)"
fi

exit "$failed"
