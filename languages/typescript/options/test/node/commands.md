- `{{PM_TEST}}`: Node's built-in test runner (`node:test`, asserts from
  `node:assert/strict`) with coverage, `src/**/*.test.ts`; fails below
  the `--test-coverage-*` thresholds in `package.json`'s `test` script
  (`{{PM_RUN}} test:watch` watches)
