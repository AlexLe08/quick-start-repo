## Getting started

Java 25 and Maven 3.9+ (`mise use java@temurin-25` and
`brew install maven`, or your own way), then:

```sh
mvn -B verify                                         # build, test, check
java -jar target/{{PROJECT_NAME}}-0.1.0-SNAPSHOT.jar  # run it
scripts/check.sh                                      # what CI runs
```
