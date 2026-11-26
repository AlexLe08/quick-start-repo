Built with Gradle through its wrapper (`./gradlew`, which downloads the
Gradle version in `gradle/wrapper/gradle-wrapper.properties`; never a
system `gradle`). The build is `build.gradle.kts`; every dependency and
plugin version is in `gradle/libs.versions.toml`, and Dependabot proposes
updates monthly.

- `./gradlew build`: compile with every warning as an error
  (`-Xlint:all -Werror`), run the JUnit 6 tests in `src/test/java/`,
  check formatting, and fail below the coverage minimum in
  `build.gradle.kts` (JaCoCo, report in `build/reports/jacoco/`)
- `./gradlew spotlessApply`: format with google-java-format;
  `./gradlew spotlessCheck` only checks
- `./gradlew run`: build and run the program (`App.java`)
- `./gradlew wrapper --gradle-version <version>`: move to another Gradle
  version (run it twice: the second run updates the wrapper itself)
