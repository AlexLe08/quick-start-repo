## Getting started

The .NET 10 SDK, the version in `global.json`
([download](https://dotnet.microsoft.com/download/dotnet/10.0), or
`brew install --cask dotnet-sdk`). Then:

```sh
# restore the locked packages
dotnet restore
# run it
dotnet run --project src/{{PASCAL_NAME}}
# format, build, tests: what CI runs
scripts/check.sh
```
