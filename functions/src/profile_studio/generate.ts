/**
 * POST /generateProfileStudio
 *
 * Verifies the caller's Firebase ID token, validates input, then:
 *   1. serves a cached response for an identical (tone, inspiration) if one
 *      is still within its 24h TTL — no model call, no quota spent;
 *   2. atomically RESERVES a per-user daily generation slot (a pending row
 *      inserted under a per-user advisory lock, so concurrent requests can't
 *      all pass the cap — closes the count-then-insert TOCTOU race);
 *   3. calls Claude on Amazon Bedrock, clamps the result to the client's word
 *      limits, finalizes the reservation, caches the response, and returns it.
 *      A failed generation RELEASES the slot so the user isn't charged quota.
 *
 * The rate limit exists to cap (billable) model cost, so a Postgres outage on
 * the cache/reserve path returns a clean 503 rather than failing open into an
 * uncapped endpoint. Post-generation accounting (finalize, cache write) is
 * best-effort and never fails a successful generation.
 *
 * Response shape mirrors the Flutter `ProfileStudioData` model so the
 * client HttpProfileStudioService can consume it without a translation
 * layer.
 */

import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";
import { sql, type Kysely } from "kysely";
import { getDb } from "../db/kysely";
import type { Database } from "../db/schema";
import { AuthError, verifyIdToken } from "../auth/verifyIdToken";
import {
  generateJson,
  LlmValidationError,
} from "../ai/bedrock";
import {
  buildSystemPrompt,
  buildUserMessage,
  clampToLimits,
  isProfileStudioGenerated,
  ProfileStudioGenerated,
  Tone,
} from "./prompt";
import {
  cacheKeyFor,
  DAILY_GENERATION_LIMIT,
  isCacheFresh,
  isRateLimited,
  RATE_LIMIT_WINDOW_MS,
} from "./rate_limit";

type GenerateBody = {
  inspirationText?: unknown;
  tone?: unknown;
};

/** The JSON body returned to the client (and stored in the cache). */
type ProfileStudioResponse = {
  myStory: string;
  interests: string[];
  narratives: { id: string; title: string; content: string }[];
  joinMeFor: string[];
};

const VALID_TONES: readonly Tone[] = ["natural", "elegant"] as const;

const MIN_INPUT_CHARS = 10;
const MAX_INPUT_CHARS = 1000;

export const generateProfileStudio = onRequest(
  {
    region: "asia-south1",
    // Bedrock calls can take a few seconds cold — bump default 60s.
    timeoutSeconds: 45,
    // Small memory bump so streaming/parse isn't tight on cold start.
    memory: "512MiB",
  },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method not allowed." });
      return;
    }

    // Auth ------------------------------------------------------------------
    let uid: string;
    try {
      const decoded = await verifyIdToken(req);
      uid = decoded.uid;
    } catch (e) {
      if (e instanceof AuthError) {
        res.status(e.status).json({ error: e.message });
        return;
      }
      throw e;
    }

    // Input validation -------------------------------------------------------
    const body = (req.body ?? {}) as GenerateBody;

    const inspirationText =
      typeof body.inspirationText === "string" ? body.inspirationText.trim() : "";
    const toneRaw = typeof body.tone === "string" ? body.tone : "";
    const tone = VALID_TONES.find((t) => t === toneRaw);

    if (inspirationText.length < MIN_INPUT_CHARS) {
      res.status(400).json({
        error: `Add at least ${MIN_INPUT_CHARS} characters of inspiration.`,
      });
      return;
    }
    if (inspirationText.length > MAX_INPUT_CHARS) {
      res.status(400).json({
        error: `Inspiration must be at most ${MAX_INPUT_CHARS} characters.`,
      });
      return;
    }
    if (!tone) {
      res.status(400).json({
        error: `tone must be one of: ${VALID_TONES.join(", ")}.`,
      });
      return;
    }

    const db = getDb();
    const key = cacheKeyFor(tone, inspirationText);

    // Cache read + slot reservation both hit Postgres. Because the rate limit
    // guards (billable) model cost, a DB outage here is a hard failure (503) —
    // we refuse rather than fail open into an uncapped endpoint.
    let reservation: ReserveResult;
    try {
      const cached = await readFreshCache(db, key);
      if (cached) {
        logger.info("profile-studio.generate.cache_hit", { uid, tone });
        res.status(200).json(cached);
        return;
      }
      reservation = await reserveSlot(db, uid, tone, inspirationText.length);
    } catch (e) {
      logger.error("profile-studio.generate.db_unavailable", {
        uid,
        message: e instanceof Error ? e.message : String(e),
      });
      res.status(503).json({
        error:
          "Profile Studio is temporarily unavailable. Please try again shortly.",
      });
      return;
    }

    if (reservation.status === "no_user") {
      res
        .status(404)
        .json({ error: "Complete account setup before using Profile Studio." });
      return;
    }
    if (reservation.status === "rate_limited") {
      logger.info("profile-studio.generate.rate_limited", { uid });
      res.set("Retry-After", String(reservation.retryAfterSec));
      res.status(429).json({
        error:
          `You've reached today's limit of ${DAILY_GENERATION_LIMIT} ` +
          "generations. Come back tomorrow.",
      });
      return;
    }

    // Generation ------------------------------------------------------------
    const startedAt = Date.now();
    let generated: ProfileStudioGenerated;
    try {
      generated = await generateJson<ProfileStudioGenerated>({
        system: buildSystemPrompt(tone),
        user: buildUserMessage(inspirationText),
        validate: isProfileStudioGenerated,
      });
    } catch (e) {
      // Free the reserved slot — a failed generation must not consume quota.
      await releaseSlot(db, reservation.generationId).catch((err) =>
        logger.error("profile-studio.generate.release_failed", {
          message: err instanceof Error ? err.message : String(err),
        }),
      );

      if (e instanceof LlmValidationError) {
        logger.error("profile-studio.generate.llm_validation", {
          uid,
          tone,
          message: e.message,
          rawSample: e.rawOutput.slice(0, 500),
        });
        res.status(502).json({
          error: "The generator returned malformed output. Please try again.",
        });
        return;
      }
      logger.error("profile-studio.generate.llm_error", {
        uid,
        tone,
        message: e instanceof Error ? e.message : String(e),
      });
      res.status(502).json({
        error: "The generator is unavailable right now. Please try again.",
      });
      return;
    }

    const clamped = clampToLimits(generated);
    const durationMs = Date.now() - startedAt;

    // Finalize the reservation (mark succeeded + record duration). Best-effort:
    // an accounting failure must not fail a successful generation.
    await finalizeSlot(db, reservation.generationId, durationMs).catch((err) =>
      logger.error("profile-studio.generate.finalize_failed", {
        message: err instanceof Error ? err.message : String(err),
      }),
    );

    // Response --------------------------------------------------------------
    // Shape matches Flutter HttpProfileStudioService._parseResponse().
    const payload: ProfileStudioResponse = {
      myStory: clamped.myStory,
      interests: clamped.interests,
      narratives: clamped.narratives.map((nn, i) => ({
        id: idFor(nn.title, i),
        title: nn.title,
        content: nn.content,
      })),
      joinMeFor: clamped.joinMeFor,
    };

    // Cache the response for identical future requests (best-effort).
    await writeCache(db, key, payload).catch((err) =>
      logger.error("profile-studio.generate.cache_write_failed", {
        message: err instanceof Error ? err.message : String(err),
      }),
    );

    logger.info("profile-studio.generate.success", {
      uid,
      tone,
      durationMs,
      inputChars: inspirationText.length,
      myStoryChars: clamped.myStory.length,
    });

    res.status(200).json(payload);
  },
);

// ---------------------------------------------------------------------------
// Store access
// ---------------------------------------------------------------------------

type ReserveResult =
  | { status: "ok"; userId: string; generationId: string }
  | { status: "no_user" }
  | { status: "rate_limited"; retryAfterSec: number };

/** Returns the cached response if one exists and is still within its TTL. */
async function readFreshCache(
  db: Kysely<Database>,
  key: string,
): Promise<ProfileStudioResponse | undefined> {
  const cached = await db
    .selectFrom("profile_studio_cache")
    .select(["response", "created_at"])
    .where("cache_key", "=", key)
    .executeTakeFirst();

  if (cached && isCacheFresh(new Date(cached.created_at), new Date())) {
    return cached.response as ProfileStudioResponse;
  }
  return undefined;
}

/**
 * Atomically reserves a daily generation slot for the caller.
 *
 * Runs in a transaction holding a per-user advisory lock so the
 * count-then-insert is serialized across concurrent requests (closes the
 * TOCTOU race). The inserted row is "pending" (`succeeded=false`) and counts
 * against the window immediately, so parallel callers can't all pass the cap.
 */
async function reserveSlot(
  db: Kysely<Database>,
  firebaseUid: string,
  tone: string,
  inputChars: number,
): Promise<ReserveResult> {
  return db.transaction().execute(async (trx): Promise<ReserveResult> => {
    const user = await trx
      .selectFrom("users")
      .select(["id"])
      .where("firebase_uid", "=", firebaseUid)
      .executeTakeFirst();
    if (!user) return { status: "no_user" };

    // Serialize concurrent requests for THIS user (released at txn end).
    await sql`SELECT pg_advisory_xact_lock(hashtext(${user.id}))`.execute(trx);

    const agg = await trx
      .selectFrom("profile_studio_generations")
      .select((eb) => [
        eb.fn.countAll<string>().as("n"),
        eb.fn.min("created_at").as("oldest"),
      ])
      .where("user_id", "=", user.id)
      .where("created_at", ">", sql<Date>`NOW() - INTERVAL '24 hours'`)
      .executeTakeFirstOrThrow();

    if (isRateLimited(Number(agg.n))) {
      // The user can generate again once the oldest windowed row ages out.
      const oldest = agg.oldest ? new Date(agg.oldest as unknown as string) : new Date();
      const retryAfterSec = Math.max(
        1,
        Math.ceil((oldest.getTime() + RATE_LIMIT_WINDOW_MS - Date.now()) / 1000),
      );
      return { status: "rate_limited", retryAfterSec };
    }

    const row = await trx
      .insertInto("profile_studio_generations")
      .values({
        user_id: user.id,
        tone,
        input_chars: inputChars,
        duration_ms: 0,
        succeeded: false,
      })
      .returning("id")
      .executeTakeFirstOrThrow();

    return { status: "ok", userId: user.id, generationId: row.id };
  });
}

/** Marks a reserved slot as a successful generation. */
async function finalizeSlot(
  db: Kysely<Database>,
  generationId: string,
  durationMs: number,
): Promise<void> {
  await db
    .updateTable("profile_studio_generations")
    .set({ succeeded: true, duration_ms: durationMs })
    .where("id", "=", generationId)
    .execute();
}

/** Frees a reserved slot (failed generation) so it doesn't consume quota. */
async function releaseSlot(
  db: Kysely<Database>,
  generationId: string,
): Promise<void> {
  await db
    .deleteFrom("profile_studio_generations")
    .where("id", "=", generationId)
    .execute();
}

/**
 * Writes/refreshes the cache entry, plus an occasional opportunistic sweep of
 * expired rows to bound table growth. (A scheduled retention job is the
 * production-grade approach; this keeps things cheap without one.)
 */
async function writeCache(
  db: Kysely<Database>,
  key: string,
  payload: ProfileStudioResponse,
): Promise<void> {
  const responseJson = sql`${JSON.stringify(payload)}::jsonb`;
  await db
    .insertInto("profile_studio_cache")
    .values({ cache_key: key, response: responseJson })
    .onConflict((oc) =>
      oc.column("cache_key").doUpdateSet({
        response: responseJson,
        created_at: sql`NOW()`,
      }),
    )
    .execute();

  if (Math.random() < 0.1) {
    await db
      .deleteFrom("profile_studio_cache")
      .where("created_at", "<", sql<Date>`NOW() - INTERVAL '24 hours'`)
      .execute();
    // Generation rows older than the window are no longer counted; prune them.
    await db
      .deleteFrom("profile_studio_generations")
      .where("created_at", "<", sql<Date>`NOW() - INTERVAL '48 hours'`)
      .execute();
  }
}

/**
 * Deterministic narrative id — stable across regenerations of the same
 * title so the Flutter Edit sheet can key on it without collisions.
 */
function idFor(title: string, fallbackIndex: number): string {
  const slug = title
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_|_$/g, "");
  return slug.length > 0 ? slug : `narrative_${fallbackIndex}`;
}
