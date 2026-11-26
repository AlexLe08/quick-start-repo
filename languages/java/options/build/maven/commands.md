Built with Maven through its wrapper (`./mvnw`, which downloads the
Maven version in `.mvn/wrapper/maven-wrapper.properties`; never a system
`mvn`). The build is `pom.xml`, where every plugin and dependency version
is pinned; Dependabot proposes updates monthly.

- `./mvnw -B verify`: compile with every warning as an error
  (`-Xlint:all -Werror`), run the JUnit 6 tests in `src/test/java/`,
  check formatting, and fail below the coverage minimum in `pom.xml`
  (JaCoCo, report in `target/site/jacoco/`)
- `./mvnw spotless:apply`: format with google-java-format;
  `./mvnw spotless:check` only checks
- `./mvnw -B package && java -jar target/{{PROJECT_NAME}}-0.1.0-SNAPSHOT.jar`:
  build and run the program (`App.java`)
- `./mvnw wrapper:wrapper -Dmaven=<version>`: move to another Maven
  version
