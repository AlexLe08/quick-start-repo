import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    include: ["src/**/*.test.ts"],
    coverage: {
      include: ["src/**/*.ts"],
      // The entry point only wires things together; test what it calls.
      exclude: ["src/index.ts"],
      // Raise these as coverage rises; never lower them to pass.
      thresholds: { lines: 80, functions: 80, branches: 80, statements: 80 },
    },
  },
});
