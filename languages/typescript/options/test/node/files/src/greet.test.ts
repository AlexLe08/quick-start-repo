import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { greet } from "./greet.ts";

describe("greet", () => {
  it("greets by name", () => {
    assert.equal(greet("Alex"), "Hello, Alex!");
  });
});
