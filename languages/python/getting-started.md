## Getting started

[uv](https://docs.astral.sh/uv/) installs the Python in
`.python-version` (3.13) by itself:

```sh
uv sync                    # .venv with the dev tools
uv run {{PROJECT_NAME}}    # runs the program
scripts/check.sh           # lint, format, tests
```
