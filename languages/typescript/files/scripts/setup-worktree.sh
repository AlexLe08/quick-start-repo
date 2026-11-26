#!/usr/bin/env bash
# Prepares a fresh checkout (usually a git worktree under .claude/worktrees/)
# to run: node_modules from the lockfile, and the main checkout's .env, if
# it has one. Safe to re-run; an existing .env in the worktree is left
# alone.
# Also turns on the pre-commit hook (.githooks/pre-commit).
#
# Usage: scripts/setup-worktree.sh
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd -P)"
# The first entry of `git worktree list` is always the main checkout.
main_checkout="$(git -C "$root" worktree list --porcelain | head -n 1 | sed 's/^worktree //')"

echo "{{PM_CI}}"
(cd "$root" && {{PM_CI}})

if [[ "$root" != "$main_checkout" && -f "$main_checkout/.env" && ! -e "$root/.env" ]]; then
  cp "$main_checkout/.env" "$root/.env"
  echo "copied .env from the main checkout"
fi

# The pre-commit hook in .githooks/. The setting is shared by every
# worktree; the path is relative, so each one runs its own copy.
git -C "$root" config core.hooksPath .githooks

echo "ready"
