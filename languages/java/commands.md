## Commands

Java 25, the current LTS (`.java-version`; mise reads it, set to
Temurin; move to the next LTS, 29, when it lands in September 2027).
Classes live under the `dev.alexle.{{PACKAGE_NAME}}` package.

<!-- option:build -->
- `scripts/check.sh`: everything CI's `check` job runs, one line per step.
  Done means it passes.
- `scripts/new-worktree.sh <branch>`: the next task's worktree;
  `scripts/setup-worktree.sh` (the build's downloads, and the main
  checkout's `.env`) runs inside it.
- `scripts/cleanup-merged.sh [--apply]`: after a merge, lists (or with
  `--apply` removes) worktrees and local branches whose PR merged.

## Code rules

- Tests mirror the main tree: `src/test/java/…/GreeterTest.java` tests
  `src/main/java/…/Greeter.java`.
- The coverage minimum sits just under the current number; raise it when
  coverage rises, never lower it to pass.
