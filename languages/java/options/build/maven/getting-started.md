Java 25, which `.java-version` names: `mise install` with
[mise](https://mise.jdx.dev) (once per machine,
`mise settings add idiomatic_version_file_enable_tools java` lets it read
`.java-version`; it installs Temurin, as CI does), or your own way.
`./mvnw` downloads Maven itself. Then:

```sh
# build, test, check
./mvnw -B verify
# run it
java -jar target/{{PROJECT_NAME}}-0.1.0-SNAPSHOT.jar
# what CI runs
scripts/check.sh
```
