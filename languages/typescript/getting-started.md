## Getting started

Node's latest LTS (`.nvmrc`; `nvm install` or `mise install` picks it
up).
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
