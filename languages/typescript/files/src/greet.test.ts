import { describe, expect, it } from "vitest";
import { greet } from "./greet.ts";

describe("greet", () => {
  it("greets by name", () => {
    expect(greet("Alex")).toBe("Hello, Alex!");
  });
});
