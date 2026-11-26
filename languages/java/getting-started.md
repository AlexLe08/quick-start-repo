## Getting started

<!-- option:build -->

Settings come from environment variables, each listed in `.env.example`.
`cp .env.example .env` and fill in your own values; `.env` is gitignored.
`set -a && . ./.env && set +a` loads it into your shell before you run
the program.

In VS Code, F5 runs the program under the debugger, and the Testing view
runs or debugs a single test.
