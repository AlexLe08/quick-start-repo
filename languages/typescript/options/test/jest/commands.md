- `{{PM_TEST}}`: Jest with coverage, `src/**/*.test.ts`, compiled by ts-jest
  and run as ES modules behind Node's `--experimental-vm-modules` flag;
  fails below the thresholds in `jest.config.js`
  (`{{PM_RUN}} test:watch` watches). Import `describe`, `it` and `expect`
  from `@jest/globals`.
