## Getting started

The .NET 10 SDK, the version in `global.json`: `mise install` with
[mise](https://mise.jdx.dev) (once per machine,
`mise settings add idiomatic_version_file_enable_tools dotnet` lets it
read `global.json`), or Microsoft's
[download](https://dotnet.microsoft.com/download/dotnet/10.0). Then:

```sh
# restore the locked packages
dotnet restore
# run it
dotnet run --project src/{{PASCAL_NAME}}
# format, build, tests: what CI runs
scripts/check.sh
```

Settings come from environment variables, each listed in `.env.example`.
`cp .env.example .env` and fill in your own values; `.env` is gitignored.
`set -a && . ./.env && set +a` loads it into your shell before you run
the program.

In VS Code, F5 runs the program under the debugger, and the Testing view
runs or debugs a single test.
