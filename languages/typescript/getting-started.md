## Getting started

Node's latest LTS, which `.nvmrc` names: `mise install` with
[mise](https://mise.jdx.dev) (once per machine,
`mise settings add idiomatic_version_file_enable_tools node` lets it read
`.nvmrc`), or `nvm install` with [nvm](https://github.com/nvm-sh/nvm).
Either leaves your global Node alone.
<!-- option:package-manager -->
Then:

```sh
# install the locked dependencies
{{PM_CI}}
# run src/index.ts, restarting on save
{{PM_RUN}} dev
# lint, format, typecheck, tests and build: what CI runs
scripts/check.sh
```

Settings come from environment variables, each listed in `.env.example`.
`cp .env.example .env` and fill in your own values; `.env` is gitignored,
and `start` and `dev` load it when it exists.

In VS Code, F5 runs `src/index.ts` under the debugger. To debug a test,
run its command in a JavaScript Debug Terminal; it stops at your
breakpoints.
