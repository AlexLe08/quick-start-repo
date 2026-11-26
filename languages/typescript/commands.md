## Commands

TypeScript on Node 24 (`.nvmrc`; mise or nvm read it), ES modules only,
npm. Use the package manager the lockfile belongs to: this project has
`package-lock.json`, so npm. Switching to pnpm (or another) means
replacing the lockfile, `npm ci` in CI and `scripts/`, and the
Dependabot ecosystem, in one PR with a decision record.

- Install: `npm ci` (`npm install <pkg>` to add one; never `sudo npm install -g`)
- `npm start` / `npm run dev`: run `src/index.ts` (once / on every save).
  Node strips the types itself, so nothing is built first.
- `npm run lint`: ESLint with typescript-eslint's recommended rules, plus
  `no-floating-promises` and `no-misused-promises` (type-aware) on `src/`
- `npm run format` / `npm run format:check`: Prettier, with its defaults
- `npm run typecheck`: `tsc --noEmit`, strict, with
  `noUncheckedIndexedAccess`
- `npm test`: Vitest with coverage, `src/**/*.test.ts`; fails below the
  thresholds in `vitest.config.ts` (`npm run test:watch` watches)
- `npm run build`: `tsc -p tsconfig.build.json` to `dist/`, without tests
- `scripts/check.sh`: everything CI's `check` job runs, one line per step.
  Done means it passes.
- `scripts/new-worktree.sh <branch>`: the next task's worktree;
  `scripts/setup-worktree.sh` (`npm ci`, and the main checkout's `.env`)
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
- TypeScript stays on `~6.0` until typescript-eslint supports newer
  (Dependabot ignores 6.1 and up until then).
- Dependency ranges are open upward. When something breaks after a fresh
  install, check the library's changelog first.
