#!/usr/bin/env bash
# The checks CI runs (.github/workflows/ci.yml, the `check` job): lint,
# formatting, unused code, type-check, tests with coverage, then the
# build.
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

run lint {{PM_RUN}} lint
run format {{PM_RUN}} format:check
run unused {{PM_RUN}} knip
run typecheck {{PM_RUN}} typecheck
run test {{PM_TEST}}
run build {{PM_RUN}} build

# Spelling, as CI's typos job (spelling.yml) checks it, where typos is
# installed (`brew install typos-cli`).
if command -v typos >/dev/null 2>&1; then
  run spelling typos
else
  echo "skip  spelling  (typos isn't installed)"
fi

exit "$failed"
