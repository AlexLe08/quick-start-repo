package dev.alexle.{{PACKAGE_NAME}};

/** The program's entry point. */
public final class App {
  private App() {}

  /** Prints a greeting. */
  public static void main(String[] args) {
    System.out.println(Greeter.greet("{{PROJECT_NAME}}"));
  }
}
