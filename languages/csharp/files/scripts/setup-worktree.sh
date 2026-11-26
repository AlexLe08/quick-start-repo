#!/usr/bin/env bash
# Prepares a fresh checkout (usually a git worktree under .claude/worktrees/)
# to run: NuGet packages restored (into ~/.nuget/packages, shared by
# every checkout), and the main checkout's .env, if it has one. Safe to
# re-run; an existing .env in the worktree is left alone.
#
# Usage: scripts/setup-worktree.sh
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd -P)"
# The first entry of `git worktree list` is always the main checkout.
main_checkout="$(git -C "$root" worktree list --porcelain | head -n 1 | sed 's/^worktree //')"

echo "dotnet restore --locked-mode"
(cd "$root" && dotnet restore --locked-mode)

if [[ "$root" != "$main_checkout" && -f "$main_checkout/.env" && ! -e "$root/.env" ]]; then
  cp "$main_checkout/.env" "$root/.env"
  echo "copied .env from the main checkout"
fi

echo "ready"
