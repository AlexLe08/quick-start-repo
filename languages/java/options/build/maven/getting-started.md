Java 25 (`mise use -g java@temurin-25`, or your own way); `./mvnw`
downloads Maven itself. Then:

```sh
# build, test, check
./mvnw -B verify
# run it
java -jar target/{{PROJECT_NAME}}-0.1.0-SNAPSHOT.jar
# what CI runs
scripts/check.sh
```
