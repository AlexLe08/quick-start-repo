package dev.alexle.{{PACKAGE_NAME}};

/** Builds greetings. */
public final class Greeter {
  private Greeter() {}

  /** Returns a greeting for {@code name}. */
  public static String greet(String name) {
    return "Hello, " + name + "!";
  }
}
