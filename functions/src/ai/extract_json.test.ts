/**
 * Unit tests for the Vertex/Claude wrapper — only the JSON extraction
 * helper is exercised here (the SDK call itself is an integration test
 * against a live Vertex endpoint, run manually).
 */

import { extractJsonBlock } from "./extract_json";

describe("extractJsonBlock", () => {
  it("returns raw JSON unchanged", () => {
    const src = '{"a":1}';
    expect(extractJsonBlock(src)).toBe(src);
  });

  it("unwraps ```json fences", () => {
    const src = 'Here you go:\n```json\n{"a":1}\n```\n';
    expect(JSON.parse(extractJsonBlock(src))).toEqual({ a: 1 });
  });

  it("unwraps plain ``` fences", () => {
    const src = '```\n{"a":1}\n```';
    expect(JSON.parse(extractJsonBlock(src))).toEqual({ a: 1 });
  });

  it("skips leading prose to find the first object", () => {
    const src = 'Sure! Here is the profile.\n{"myStory":"x"}';
    expect(JSON.parse(extractJsonBlock(src))).toEqual({ myStory: "x" });
  });

  it("handles nested braces correctly", () => {
    const src = '{"a":{"b":{"c":1}},"d":2}';
    expect(JSON.parse(extractJsonBlock(src))).toEqual({
      a: { b: { c: 1 } },
      d: 2,
    });
  });

  it("extracts a top-level array when the response is a list", () => {
    const src = "well ok: [1, [2, 3], 4]";
    expect(JSON.parse(extractJsonBlock(src))).toEqual([1, [2, 3], 4]);
  });
});
