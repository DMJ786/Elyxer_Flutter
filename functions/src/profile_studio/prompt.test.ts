/**
 * Unit tests for the Profile Studio prompt + response validator.
 * These run offline; no Vertex call happens.
 */

import {
  buildSystemPrompt,
  buildUserMessage,
  clampToLimits,
  isProfileStudioGenerated,
  LIMITS,
  ProfileStudioGenerated,
} from "./prompt";

describe("buildSystemPrompt", () => {
  it("mentions both tone descriptors so the model can distinguish", () => {
    const natural = buildSystemPrompt("natural");
    const elegant = buildSystemPrompt("elegant");
    expect(natural).toContain("NATURAL");
    expect(elegant).toContain("ELEGANT");
    expect(natural).not.toBe(elegant);
  });

  it("pins every word limit so the model has explicit ceilings", () => {
    const p = buildSystemPrompt("natural");
    expect(p).toContain(String(LIMITS.myStory));
    expect(p).toContain(String(LIMITS.interestsMax));
    expect(p).toContain(String(LIMITS.narrativeTitle));
    expect(p).toContain(String(LIMITS.narrativeContent));
    expect(p).toContain(String(LIMITS.joinMeForMax));
  });

  it("names the excluded content categories explicitly", () => {
    const p = buildSystemPrompt("natural");
    expect(p.toLowerCase()).toMatch(/last names|phone|email|location/);
    expect(p.toLowerCase()).toMatch(/minors/);
  });
});

describe("buildUserMessage", () => {
  it("clamps very long inspiration to a safe length", () => {
    const msg = buildUserMessage("x".repeat(5000));
    expect(msg.length).toBeLessThan(1200);
  });

  it("preserves the actual inspiration text inside the quote block", () => {
    const msg = buildUserMessage("weekends on trails");
    expect(msg).toContain("weekends on trails");
  });
});

describe("isProfileStudioGenerated", () => {
  const valid: ProfileStudioGenerated = {
    myStory: "I hike, I bake, I have strong coffee opinions.",
    interests: ["Trails", "Baking", "Coffee"],
    narratives: [
      { title: "QUIET MORNINGS", content: "First light, second brew, third try." },
      { title: "SLOW WEEKENDS", content: "Books, bakery, back trails, no rush." },
    ],
    joinMeFor: ["a slow trail hike", "a coffee tasting", "a bakery crawl"],
  };

  it("accepts a well-formed response", () => {
    expect(isProfileStudioGenerated(valid)).toBe(true);
  });

  it.each([
    ["missing myStory", { ...valid, myStory: undefined }],
    ["empty myStory", { ...valid, myStory: "  " }],
    ["wrong narrative count", { ...valid, narratives: [valid.narratives[0]] }],
    ["non-string interest", { ...valid, interests: ["ok", 42] }],
    ["missing narrative title", {
      ...valid,
      narratives: [{ content: "no title" }, valid.narratives[1]],
    }],
    ["joinMeFor not array", { ...valid, joinMeFor: "not an array" }],
  ])("rejects: %s", (_label, bad) => {
    expect(isProfileStudioGenerated(bad)).toBe(false);
  });
});

describe("clampToLimits", () => {
  it("truncates over-long myStory to the word ceiling", () => {
    const long = Array.from({ length: 60 }, () => "word").join(" ");
    const out = clampToLimits({
      myStory: long,
      interests: ["ok"],
      narratives: [
        { title: "OK", content: "one two three" },
        { title: "OK", content: "one two three" },
      ],
      joinMeFor: ["ok"],
    });
    expect(out.myStory.split(/\s+/).length).toBe(LIMITS.myStory);
  });

  it("caps interests at LIMITS.interestsMax", () => {
    const many = Array.from({ length: 20 }, (_, i) => `Chip${i}`);
    const out = clampToLimits({
      myStory: "ok",
      interests: many,
      narratives: [
        { title: "OK", content: "ok" },
        { title: "OK", content: "ok" },
      ],
      joinMeFor: [],
    });
    expect(out.interests).toHaveLength(LIMITS.interestsMax);
  });

  it("caps joinMeFor items at LIMITS.joinMeForMax", () => {
    const out = clampToLimits({
      myStory: "ok",
      interests: [],
      narratives: [
        { title: "OK", content: "ok" },
        { title: "OK", content: "ok" },
      ],
      joinMeFor: ["a", "b", "c", "d", "e"],
    });
    expect(out.joinMeFor).toHaveLength(LIMITS.joinMeForMax);
  });
});
