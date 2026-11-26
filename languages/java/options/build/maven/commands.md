Built with Maven 3.9+ (`pom.xml`, where every plugin and dependency
version is pinned; Dependabot proposes updates monthly).

- `mvn -B verify`: compile with every warning as an error
  (`-Xlint:all -Werror`), run the JUnit 6 tests in `src/test/java/`,
  check formatting, and fail below the coverage minimum in `pom.xml`
  (JaCoCo, report in `target/site/jacoco/`)
- `mvn spotless:apply`: format with google-java-format;
  `mvn spotless:check` only checks
- `mvn -B package && java -jar target/{{PROJECT_NAME}}-0.1.0-SNAPSHOT.jar`:
  build and run the program (`App.java`)
