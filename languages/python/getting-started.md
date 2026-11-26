## Getting started

[uv](https://docs.astral.sh/uv/) (`brew install uv`, or its installer)
installs the Python in `.python-version` (3.13) by itself. Then:

```sh
# .venv with the dev tools
uv sync
# run the program
uv run {{PROJECT_NAME}}
# lint, format, type check, tests: what CI runs
scripts/check.sh
```

Settings come from environment variables, each listed in `.env.example`.
`cp .env.example .env` and fill in your own values; `.env` is gitignored.
`uv run --env-file .env {{PROJECT_NAME}}` loads it, and so does VS Code's
Python extension when it runs or debugs the code.

In VS Code, F5 runs the program under the debugger, and the Testing view
runs or debugs a single test.
