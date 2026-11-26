## Commands

Java 25 (`.java-version`; mise reads it, set to Temurin), built with
Maven 3.9+ (`pom.xml`). Classes live under the `dev.alexle.{{PACKAGE_NAME}}`
package.

- `mvn -B verify`: compile with every warning as an error
  (`-Xlint:all -Werror`), run the JUnit 6 tests in `src/test/java/`,
  check formatting, and fail below the coverage minimum (JaCoCo, report
  in `target/site/jacoco/`)
- `mvn spotless:apply`: format with google-java-format;
  `mvn spotless:check` only checks
- `mvn -B package && java -jar target/{{PROJECT_NAME}}-0.1.0-SNAPSHOT.jar`:
  build and run the program (`App.java`)
- `scripts/check.sh`: everything CI's `check` job runs, one line per step.
  Done means it passes.
- `scripts/new-worktree.sh <branch>`: the next task's worktree;
  `scripts/setup-worktree.sh` (Maven's downloads, and the main
  checkout's `.env`) runs inside it.
- `scripts/cleanup-merged.sh [--apply]`: after a merge, lists (or with
  `--apply` removes) worktrees and local branches whose PR merged.

## Code rules

- Plugin and dependency versions are pinned in `pom.xml`; Dependabot
  proposes updates monthly.
- Tests mirror the main tree: `src/test/java/…/GreeterTest.java` tests
  `src/main/java/…/Greeter.java`.
- The coverage minimum in `pom.xml` sits just under the current number;
  raise it when coverage rises, never lower it to pass.
