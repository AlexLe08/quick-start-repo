Java 25, which `.java-version` names: `mise install` with
[mise](https://mise.jdx.dev) (once per machine,
`mise settings add idiomatic_version_file_enable_tools java` lets it read
`.java-version`; it installs Temurin, as CI does), or your own way.
`./gradlew` downloads Gradle itself. Then:

```sh
# build, test, check
./gradlew build
# run it
./gradlew run
# what CI runs
scripts/check.sh
```
