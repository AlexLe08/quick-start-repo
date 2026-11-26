import { describe, expect, it } from "@jest/globals";
import { greet } from "./greet.ts";

describe("greet", () => {
  it("greets by name", () => {
    expect(greet("Alex")).toBe("Hello, Alex!");
  });
});
