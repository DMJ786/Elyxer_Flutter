/**
 * POST /generateProfileStudio
 *
 * Verifies the caller's Firebase ID token, validates input, calls
 * Claude via Vertex AI Model Garden, defensively clamps the result to
 * the Flutter client's word limits, logs the event for rate-limit
 * accounting, and returns the structured profile.
 *
 * Response shape mirrors the Flutter `ProfileStudioData` model so the
 * client HttpProfileStudioService can consume it without a translation
 * layer.
 */

import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";
import { AuthError, verifyIdToken } from "../auth/verifyIdToken";
import {
  generateJson,
  LlmValidationError,
} from "../ai/vertex";
import {
  buildSystemPrompt,
  buildUserMessage,
  clampToLimits,
  isProfileStudioGenerated,
  ProfileStudioGenerated,
  Tone,
} from "./prompt";

type GenerateBody = {
  inspirationText?: unknown;
  tone?: unknown;
};

const VALID_TONES: readonly Tone[] = ["natural", "elegant"] as const;

const MIN_INPUT_CHARS = 10;
const MAX_INPUT_CHARS = 1000;

export const generateProfileStudio = onRequest(
  {
    region: "asia-south1",
    // Vertex AI calls can take a few seconds cold — bump default 60s.
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

    logger.info("profile-studio.generate.success", {
      uid,
      tone,
      durationMs,
      inputChars: inspirationText.length,
      myStoryChars: clamped.myStory.length,
    });

    // Response --------------------------------------------------------------
    // Shape matches Flutter HttpProfileStudioService._parseResponse().
    res.status(200).json({
      myStory: clamped.myStory,
      interests: clamped.interests,
      narratives: clamped.narratives.map((n, i) => ({
        id: idFor(n.title, i),
        title: n.title,
        content: n.content,
      })),
      joinMeFor: clamped.joinMeFor,
    });
  },
);

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
