## Commands

TypeScript on Node's latest LTS (`.nvmrc` says `lts/*`, which nvm,
fnm, mise and CI all read), ES modules only, {{PM}} for packages. Use the
package manager the lockfile belongs to: this project has
`{{PM_LOCKFILE}}`, so {{PM}}. Switching to another means replacing the
lockfile, the install in CI and `scripts/`, `packageManager` in
`package.json` and the Dependabot ecosystem, in one PR with a decision
record.

- Install: `{{PM_CI}}` (`{{PM_ADD}} <pkg>` to add one; never install
  globally with `sudo`)
<!-- option:package-manager -->
- `{{PM_RUN}} start` / `{{PM_RUN}} dev`: run `src/index.ts` (once / on every save).
  Node strips the types itself, so nothing is built first.
- `{{PM_RUN}} lint`: ESLint with typescript-eslint's recommended rules, plus
  `no-floating-promises` and `no-misused-promises` (type-aware) on `src/`
- `{{PM_RUN}} format` / `{{PM_RUN}} format:check`: Prettier, with its defaults
- `{{PM_RUN}} typecheck`: `tsc --noEmit`, strict, with
  `noUncheckedIndexedAccess`
<!-- option:test -->
- `{{PM_RUN}} build`: `tsc -p tsconfig.build.json` to `dist/`, without tests
- `scripts/check.sh`: everything CI's `check` job runs, one line per step.
  Done means it passes.
- `scripts/new-worktree.sh <branch>`: the next task's worktree;
  `scripts/setup-worktree.sh` (`{{PM_CI}}`, and the main checkout's `.env`)
  runs inside it.
- `scripts/cleanup-merged.sh [--apply]`: after a merge, lists (or with
  `--apply` removes) worktrees and local branches whose PR merged.

## Code rules

- Relative imports name the `.ts` file (`./greet.ts`); the build rewrites
  them to `.js`. Only erasable syntax (`erasableSyntaxOnly`): no `enum`,
  `namespace`, or constructor parameter properties.
- Tests sit beside the code as `src/*.test.ts`. Coverage thresholds sit
  just under the current numbers; raise them when coverage rises, never
  lower them to pass.
- `@types/node` follows the LTS's major. When a new LTS lands (each
  October), raise it by hand; Dependabot skips its majors, which would
  otherwise jump to the newest Node rather than the LTS.
- TypeScript stays on `~6.0` until typescript-eslint supports newer
  (Dependabot ignores 6.1 and up until then).
- Dependency ranges are open upward. When something breaks after a fresh
  install, check the library's changelog first.
