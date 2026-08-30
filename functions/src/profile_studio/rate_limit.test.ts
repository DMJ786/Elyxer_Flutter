import {
  cacheKeyFor,
  CACHE_TTL_MS,
  DAILY_GENERATION_LIMIT,
  isCacheFresh,
  isRateLimited,
} from "./rate_limit";

describe("cacheKeyFor", () => {
  it("is deterministic for the same tone + inspiration", () => {
    expect(cacheKeyFor("natural", "trails and chai")).toBe(
      cacheKeyFor("natural", "trails and chai"),
    );
  });

  it("ignores surrounding whitespace on the inspiration", () => {
    expect(cacheKeyFor("natural", "  trails and chai  ")).toBe(
      cacheKeyFor("natural", "trails and chai"),
    );
  });

  it("changes when the tone changes", () => {
    expect(cacheKeyFor("natural", "trails and chai")).not.toBe(
      cacheKeyFor("elegant", "trails and chai"),
    );
  });

  it("changes when the inspiration changes", () => {
    expect(cacheKeyFor("natural", "trails and chai")).not.toBe(
      cacheKeyFor("natural", "trails and coffee"),
    );
  });

  it("produces a 64-char hex sha256 digest", () => {
    expect(cacheKeyFor("natural", "x")).toMatch(/^[0-9a-f]{64}$/);
  });
});

describe("isCacheFresh (faked clock)", () => {
  const created = new Date("2026-01-01T00:00:00Z");

  it("is fresh moments after creation", () => {
    const now = new Date(created.getTime() + 1000);
    expect(isCacheFresh(created, now)).toBe(true);
  });

  it("is fresh just before the 24h boundary", () => {
    const now = new Date(created.getTime() + CACHE_TTL_MS - 1);
    expect(isCacheFresh(created, now)).toBe(true);
  });

  it("is stale exactly at the 24h boundary", () => {
    const now = new Date(created.getTime() + CACHE_TTL_MS);
    expect(isCacheFresh(created, now)).toBe(false);
  });

  it("is stale well past 24h", () => {
    const now = new Date(created.getTime() + CACHE_TTL_MS + 60_000);
    expect(isCacheFresh(created, now)).toBe(false);
  });

  it("treats a future createdAt (clock skew) as not fresh", () => {
    const now = new Date(created.getTime() - 1000);
    expect(isCacheFresh(created, now)).toBe(false);
  });
});

describe("isRateLimited", () => {
  it(`is false below the limit of ${DAILY_GENERATION_LIMIT}`, () => {
    expect(isRateLimited(0)).toBe(false);
    expect(isRateLimited(DAILY_GENERATION_LIMIT - 1)).toBe(false);
  });

  it("is true at and above the limit", () => {
    expect(isRateLimited(DAILY_GENERATION_LIMIT)).toBe(true);
    expect(isRateLimited(DAILY_GENERATION_LIMIT + 3)).toBe(true);
  });
});
