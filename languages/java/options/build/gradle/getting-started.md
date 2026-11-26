Java 25 (`mise use -g java@temurin-25`, or your own way); `./gradlew`
downloads Gradle itself. Then:

```sh
# build, test, check
./gradlew build
# run it
./gradlew run
# what CI runs
scripts/check.sh
```
