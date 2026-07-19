/**
 * POST /generateProfileStudio
 *
 * Verifies the caller's Firebase ID token, validates input, then:
 *   1. serves a cached response for an identical (tone, inspiration) if one
 *      is still within its 24h TTL — no model call;
 *   2. enforces a per-user daily generation cap (Postgres event log);
 *   3. otherwise calls Claude on Amazon Bedrock, clamps the result to the
 *      client's word limits, records the generation, caches the response,
 *      and returns it.
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

    // Resolve the caller's user row (needed for rate-limit accounting).
    const user = await db
      .selectFrom("users")
      .select(["id"])
      .where("firebase_uid", "=", uid)
      .executeTakeFirst();

    if (!user) {
      res
        .status(404)
        .json({ error: "Complete account setup before using Profile Studio." });
      return;
    }

    // Cache -----------------------------------------------------------------
    // Identical (tone, inspiration) within the TTL skips the model entirely and
    // does not count against the daily quota.
    const key = cacheKeyFor(tone, inspirationText);
    const cached = await db
      .selectFrom("profile_studio_cache")
      .select(["response", "created_at"])
      .where("cache_key", "=", key)
      .executeTakeFirst();

    if (cached && isCacheFresh(new Date(cached.created_at), new Date())) {
      logger.info("profile-studio.generate.cache_hit", { uid, tone });
      res.status(200).json(cached.response);
      return;
    }

    // Rate limit ------------------------------------------------------------
    const { n } = await db
      .selectFrom("profile_studio_generations")
      .select((eb) => eb.fn.countAll<string>().as("n"))
      .where("user_id", "=", user.id)
      .where("created_at", ">", sql<Date>`NOW() - INTERVAL '24 hours'`)
      .executeTakeFirstOrThrow();

    const dailyCount = Number(n);
    if (isRateLimited(dailyCount)) {
      logger.info("profile-studio.generate.rate_limited", {
        uid,
        count: dailyCount,
      });
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
      await recordGeneration(db, {
        userId: user.id,
        tone,
        inputChars: inspirationText.length,
        durationMs: Date.now() - startedAt,
        succeeded: false,
      });

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

    await recordGeneration(db, {
      userId: user.id,
      tone,
      inputChars: inspirationText.length,
      durationMs,
      succeeded: true,
    });

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

    // Cache the response for identical future requests (refresh TTL on write).
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

    logger.info("profile-studio.generate.success", {
      uid,
      tone,
      durationMs,
      dailyCount: dailyCount + 1,
      inputChars: inspirationText.length,
      myStoryChars: clamped.myStory.length,
    });

    res.status(200).json(payload);
  },
);

/**
 * Append a row to the generation log for rate-limit accounting. Never
 * throws — a logging failure must not fail the user's request.
 */
async function recordGeneration(
  db: Kysely<Database>,
  row: {
    userId: string;
    tone: string;
    inputChars: number;
    durationMs: number;
    succeeded: boolean;
  },
): Promise<void> {
  try {
    await db
      .insertInto("profile_studio_generations")
      .values({
        user_id: row.userId,
        tone: row.tone,
        input_chars: row.inputChars,
        duration_ms: row.durationMs,
        succeeded: row.succeeded,
      })
      .execute();
  } catch (e) {
    logger.error("profile-studio.generate.log_failed", {
      message: e instanceof Error ? e.message : String(e),
    });
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
