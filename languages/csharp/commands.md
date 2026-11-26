## Commands

.NET 10 (`global.json` pins the SDK band; mise or the official installer).
One solution, `{{PASCAL_NAME}}.slnx`: the program in `src/{{PASCAL_NAME}}/`,
its xUnit v3 tests in `tests/{{PASCAL_NAME}}.Tests/`.

- `dotnet restore`: restore packages. Each project's `packages.lock.json`
  is committed; CI restores with `--locked-mode`, so commit the lock
  files after changing a package.
- `dotnet run --project src/{{PASCAL_NAME}}`: run the program
- `dotnet build`: compile; every warning and recommended analyzer
  finding is an error (`Directory.Build.props`)
- `dotnet test`: the tests
- `dotnet format`: format and apply the `.editorconfig` style;
  `dotnet format --verify-no-changes` only checks
- `scripts/check.sh`: everything CI's `check` job runs, one line per step.
  Done means it passes.
- `scripts/new-worktree.sh <branch>`: the next task's worktree;
  `scripts/setup-worktree.sh` (`dotnet restore --locked-mode`, and the
  main checkout's `.env`) runs inside it.
- `scripts/cleanup-merged.sh [--apply]`: after a merge, lists (or with
  `--apply` removes) worktrees and local branches whose PR merged.

## Code rules

- Package versions live only in `Directory.Packages.props` (central
  package management); a project names a package without a version.
- Settings every project shares go in `Directory.Build.props`, not in
  each `.csproj`.
- Nullable reference types are on: no `!` to silence a warning without
  a comment saying why it can't be null.
- Tests mirror the source: `tests/{{PASCAL_NAME}}.Tests/GreeterTests.cs`
  tests `src/{{PASCAL_NAME}}/Greeter.cs`.
