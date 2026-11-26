## Getting started

Node's latest LTS: [nvm](https://github.com/nvm-sh/nvm)'s `nvm install`
reads `.nvmrc`, or with [mise](https://mise.jdx.dev),
`mise use -g node@lts`.
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
