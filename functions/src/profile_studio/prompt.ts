/**
 * Profile Studio prompt + response schema.
 *
 * The Flutter app sends `{ inspirationText, tone }`. This module turns
 * that into a Claude system+user message pair and validates the JSON
 * that comes back so the endpoint can respond with a strongly-typed
 * result.
 *
 * Word-limit constants mirror the Flutter WordLimits class so the
 * server never generates fields the client would truncate.
 */

export type Tone = "natural" | "elegant";

export type ProfileStudioGenerated = {
  myStory: string;
  interests: string[];
  narratives: Array<{ title: string; content: string }>;
  joinMeFor: string[];
};

// Mirrors lib/models/profile_studio_models.dart :: WordLimits.
export const LIMITS = {
  myStory: 25,
  interestsMax: 6,
  interestWordLimit: 2,
  narrativeTitle: 4,
  narrativeContent: 25,
  joinMeForMax: 3,
  joinMeForWordLimit: 5,
} as const;

const TONE_INSTRUCTIONS: Record<Tone, string> = {
  natural:
    "Casual and warm — like the user talking to a close friend. First-person voice. Concrete over abstract. No corporate or salesy language.",
  elegant:
    "Refined and considered — a curated introduction. First-person voice, slightly more literary phrasing, but never pretentious. Values patience, taste, and depth.",
};

/**
 * Build the system prompt for a given tone.
 *
 * Pinning the response shape as a strict JSON schema inside the system
 * prompt gives us reliable structured output without needing the
 * separate tool-use flow. Claude is very good at obeying inline schemas.
 */
export function buildSystemPrompt(tone: Tone): string {
  return [
    "You are a warm, thoughtful ghostwriter for a modern dating app called Elyxer.",
    "Given a few sentences of user inspiration, you write a complete curated dating profile in a specific tone.",
    "",
    `Tone for THIS profile: ${tone.toUpperCase()}. ${TONE_INSTRUCTIONS[tone]}`,
    "",
    "STRICT RULES:",
    `- "myStory": one short paragraph, at most ${LIMITS.myStory} words, first-person, no name, no age, no location.`,
    `- "interests": ${LIMITS.interestsMax} short chips, each 1-${LIMITS.interestWordLimit} words. Capitalise the first letter of each chip. No hashtags. No emojis.`,
    `- "narratives": exactly 2 items. Each has "title" (${LIMITS.narrativeTitle} words max, TITLE-CASE UPPER, evocative) and "content" (${LIMITS.narrativeContent} words max, one sentence, first-person).`,
    `- "joinMeFor": exactly ${LIMITS.joinMeForMax} items, each ${LIMITS.joinMeForWordLimit} words max, describing a shared activity (not a place). Present tense, no first-person pronoun.`,
    "",
    "NEVER include: last names, phone numbers, emails, exact locations, links, drug/alcohol references, political or religious identifiers, sexual content, or anything about minors.",
    "",
    "Reply with a single JSON object matching this TypeScript type — no prose, no code fence, just JSON:",
    "{ myStory: string; interests: string[]; narratives: { title: string; content: string }[]; joinMeFor: string[] }",
  ].join("\n");
}

/**
 * Build the user message. Trims and clamps input length so a runaway
 * paste can't blow past the model's context window.
 */
export function buildUserMessage(inspirationText: string): string {
  const trimmed = inspirationText.trim().slice(0, 1000);
  return `User inspiration:\n"""\n${trimmed}\n"""\n\nWrite the profile now.`;
}

/**
 * Runtime type guard for the model's JSON response. Used by
 * `generateJson()` — returning false makes the SDK wrapper throw
 * `LlmValidationError`.
 */
export function isProfileStudioGenerated(
  raw: unknown,
): raw is ProfileStudioGenerated {
  if (!raw || typeof raw !== "object") return false;
  const o = raw as Record<string, unknown>;

  if (typeof o.myStory !== "string" || o.myStory.trim().length === 0) return false;

  if (!Array.isArray(o.interests) || o.interests.some((s) => typeof s !== "string")) {
    return false;
  }

  if (!Array.isArray(o.narratives) || o.narratives.length !== 2) return false;
  for (const n of o.narratives) {
    if (!n || typeof n !== "object") return false;
    const nn = n as Record<string, unknown>;
    if (typeof nn.title !== "string" || typeof nn.content !== "string") return false;
  }

  if (!Array.isArray(o.joinMeFor) || o.joinMeFor.some((s) => typeof s !== "string")) {
    return false;
  }

  return true;
}

/**
 * Post-generation clamp. The prompt asks the model to respect limits,
 * but we defensively enforce them so a chatty response never surprises
 * the client UI (which would truncate silently).
 */
export function clampToLimits(g: ProfileStudioGenerated): ProfileStudioGenerated {
  return {
    myStory: clampWords(g.myStory, LIMITS.myStory),
    interests: g.interests
      .slice(0, LIMITS.interestsMax)
      .map((i) => clampWords(i, LIMITS.interestWordLimit)),
    narratives: g.narratives.map((n) => ({
      title: clampWords(n.title, LIMITS.narrativeTitle),
      content: clampWords(n.content, LIMITS.narrativeContent),
    })),
    joinMeFor: g.joinMeFor
      .slice(0, LIMITS.joinMeForMax)
      .map((j) => clampWords(j, LIMITS.joinMeForWordLimit)),
  };
}

function clampWords(s: string, max: number): string {
  const words = s.trim().split(/\s+/);
  if (words.length <= max) return s.trim();
  return words.slice(0, max).join(" ");
}
