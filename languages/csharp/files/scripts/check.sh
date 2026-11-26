#!/usr/bin/env bash
# The checks CI runs (.github/workflows/ci.yml, the `check` job):
# formatting, the build (warnings and analyzer findings are errors) and
# the tests.
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

run format dotnet format --verify-no-changes
run build dotnet build
run test dotnet test --no-build

exit "$failed"
