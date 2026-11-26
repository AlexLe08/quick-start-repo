import { defineConfig, globalIgnores } from "eslint/config";
import tseslint from "typescript-eslint";

export default defineConfig([
  // Build and test output, and scratch files and other worktrees.
  globalIgnores(["dist/", "coverage/", ".logs/", ".claude/"]),
  tseslint.configs.recommended,
  {
    // A promise nobody awaits or catches becomes an unhandled rejection,
    // which crashes the Node process. These rules need type information.
    files: ["src/**/*.ts"],
    languageOptions: { parserOptions: { projectService: true } },
    rules: {
      "@typescript-eslint/no-floating-promises": "error",
      "@typescript-eslint/no-misused-promises": "error",
    },
  },
]);
