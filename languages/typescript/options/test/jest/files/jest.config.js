// The project is ES modules, which Jest runs only behind Node's
// --experimental-vm-modules flag (set in package.json's test scripts);
// ts-jest compiles each test file with tsconfig.json.
/** @type {import('jest').Config} */
export default {
  testEnvironment: "node",
  roots: ["<rootDir>/src"],
  testMatch: ["**/*.test.ts"],
  extensionsToTreatAsEsm: [".ts"],
  transform: { "^.+\\.ts$": ["ts-jest", { useESM: true }] },
  // ts-jest rewrites `./greet.ts` imports to `./greet.js`, as tsc does for
  // the build; map them back so Jest finds the .ts source.
  moduleNameMapper: { "^(\\.{1,2}/.*)\\.js$": "$1" },
  coverageProvider: "v8",
  // The entry point only wires things together; test what it calls.
  collectCoverageFrom: ["src/**/*.ts", "!src/**/*.test.ts", "!src/index.ts"],
  // Raise these as coverage rises; never lower them to pass.
  coverageThreshold: {
    global: { lines: 80, functions: 80, branches: 80, statements: 80 },
  },
};
