/**
 * Pure helpers for Profile Studio rate limiting + response caching.
 *
 * Kept free of Firebase / DB so the quota threshold, cache key, and TTL
 * logic can be unit-tested (including with a faked clock).
 */

import { createHash } from "crypto";

/** Max successful-or-failed generations allowed per user per rolling 24h. */
export const DAILY_GENERATION_LIMIT = 5;

/** Cache time-to-live: identical (tone, inspiration) is reused for 24h. */
export const CACHE_TTL_MS = 24 * 60 * 60 * 1000;

/**
 * Deterministic cache key for a request. Same tone + inspiration (after
 * trimming) always hashes to the same key; any difference changes it.
 */
export function cacheKeyFor(tone: string, inspirationText: string): string {
  return createHash("sha256")
    .update(`${tone}:${inspirationText.trim()}`)
    .digest("hex");
}

/**
 * Whether a cache entry created at [createdAt] is still fresh at [now].
 * Entries exactly at the TTL boundary are considered stale.
 */
export function isCacheFresh(
  createdAt: Date,
  now: Date,
  ttlMs: number = CACHE_TTL_MS,
): boolean {
  const ageMs = now.getTime() - createdAt.getTime();
  return ageMs >= 0 && ageMs < ttlMs;
}

/** Whether [count] generations in the window has reached the daily cap. */
export function isRateLimited(count: number): boolean {
  return count >= DAILY_GENERATION_LIMIT;
}
