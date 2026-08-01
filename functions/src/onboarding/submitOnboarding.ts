/**
 * POST /submitOnboarding
 *
 * Persists a user's Module 1 (age, gender, pronouns) and Module 2
 * (sexual orientation, dating preferences, dating goals) selections into
 * `onboarding_profiles`. Follows the `submitUsername` template: verify the
 * Firebase ID token, resolve the caller's `users.id`, validate the body,
 * then upsert keyed on `user_id` so re-submitting is idempotent.
 */

import { onRequest } from "firebase-functions/v2/https";
import { getDb } from "../db/kysely";
import type {
  DatingPreference,
  Gender,
  SexualOrientation,
} from "../db/schema";
import { AuthError, verifyIdToken } from "../auth/verifyIdToken";

const GENDERS = new Set<Gender>(["man", "woman", "non_binary", "other"]);
const ORIENTATIONS = new Set<SexualOrientation>([
  "straight",
  "gay",
  "lesbian",
  "bisexual",
  "pansexual",
  "asexual",
  "queer",
]);
const PREFERENCES = new Set<DatingPreference>([
  "men",
  "women",
  "non_binary",
  "open_to_all",
]);

const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/;

/** Shape written to `onboarding_profiles` (snake_case columns). */
export type NormalizedOnboarding = {
  birthdate: string | null;
  gender: Gender | null;
  custom_gender_identity: string | null;
  gender_identity_option_ids: string[];
  pronouns: string[];
  custom_pronoun: string | null;
  show_gender_on_profile: boolean;
  show_pronouns_on_profile: boolean;
  sexual_orientation: SexualOrientation | null;
  show_sexual_orientation_on_profile: boolean;
  dating_preferences: DatingPreference[];
  dating_goal_ids: string[];
};

export type ValidationResult =
  | { ok: true; value: NormalizedOnboarding }
  | { ok: false; error: string };

function asBool(v: unknown): boolean {
  return v === true;
}

function asStringOrNull(v: unknown): string | null {
  if (typeof v !== "string") return null;
  const trimmed = v.trim();
  return trimmed.length > 0 ? trimmed : null;
}

/** Returns the string array, or `null` if the value is present but malformed. */
function asStringArray(v: unknown): string[] | null {
  if (v === undefined || v === null) return [];
  if (!Array.isArray(v)) return null;
  if (!v.every((e) => typeof e === "string")) return null;
  return v as string[];
}

/**
 * Pure request-body validator. Kept separate from the handler so it can be
 * unit-tested without Firebase or a database.
 */
export function validateOnboardingBody(body: unknown): ValidationResult {
  const b = (body ?? {}) as Record<string, unknown>;

  // birthdate — optional, but must be a real ISO date if present.
  let birthdate: string | null = null;
  if (b.birthdate !== undefined && b.birthdate !== null) {
    if (typeof b.birthdate !== "string" || !ISO_DATE.test(b.birthdate)) {
      return { ok: false, error: "birthdate must be an ISO date (YYYY-MM-DD)." };
    }
    const parsed = new Date(`${b.birthdate}T00:00:00Z`);
    if (Number.isNaN(parsed.getTime())) {
      return { ok: false, error: "birthdate is not a valid calendar date." };
    }
    birthdate = b.birthdate;
  }

  // gender — optional enum.
  let gender: Gender | null = null;
  if (b.gender !== undefined && b.gender !== null) {
    if (typeof b.gender !== "string" || !GENDERS.has(b.gender as Gender)) {
      return { ok: false, error: `Invalid gender: ${String(b.gender)}` };
    }
    gender = b.gender as Gender;
  }

  // sexual_orientation — optional enum.
  let sexualOrientation: SexualOrientation | null = null;
  if (b.sexualOrientation !== undefined && b.sexualOrientation !== null) {
    if (
      typeof b.sexualOrientation !== "string" ||
      !ORIENTATIONS.has(b.sexualOrientation as SexualOrientation)
    ) {
      return {
        ok: false,
        error: `Invalid sexualOrientation: ${String(b.sexualOrientation)}`,
      };
    }
    sexualOrientation = b.sexualOrientation as SexualOrientation;
  }

  // dating_preferences — array of enum values.
  const rawPrefs = asStringArray(b.datingPreferences);
  if (rawPrefs === null) {
    return { ok: false, error: "datingPreferences must be an array of strings." };
  }
  for (const p of rawPrefs) {
    if (!PREFERENCES.has(p as DatingPreference)) {
      return { ok: false, error: `Invalid dating preference: ${p}` };
    }
  }
  const datingPreferences = rawPrefs as DatingPreference[];

  // Free-form string arrays.
  const genderIdentityOptionIds = asStringArray(b.genderIdentityOptionIds);
  if (genderIdentityOptionIds === null) {
    return {
      ok: false,
      error: "genderIdentityOptionIds must be an array of strings.",
    };
  }
  const pronouns = asStringArray(b.pronouns);
  if (pronouns === null) {
    return { ok: false, error: "pronouns must be an array of strings." };
  }
  const datingGoalIds = asStringArray(b.datingGoalIds);
  if (datingGoalIds === null) {
    return { ok: false, error: "datingGoalIds must be an array of strings." };
  }

  return {
    ok: true,
    value: {
      birthdate,
      gender,
      custom_gender_identity: asStringOrNull(b.customGenderIdentity),
      gender_identity_option_ids: genderIdentityOptionIds,
      pronouns,
      custom_pronoun: asStringOrNull(b.customPronoun),
      show_gender_on_profile: asBool(b.showGenderOnProfile),
      show_pronouns_on_profile: asBool(b.showPronounsOnProfile),
      sexual_orientation: sexualOrientation,
      show_sexual_orientation_on_profile: asBool(
        b.showSexualOrientationOnProfile,
      ),
      dating_preferences: datingPreferences,
      dating_goal_ids: datingGoalIds,
    },
  };
}

export const submitOnboarding = onRequest(
  { region: "asia-south1" },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method not allowed." });
      return;
    }

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

    const validation = validateOnboardingBody(req.body);
    if (!validation.ok) {
      res.status(400).json({ error: validation.error });
      return;
    }
    const data = validation.value;

    const db = getDb();

    // Onboarding attaches to an existing user (created by the username step).
    const user = await db
      .selectFrom("users")
      .select(["id"])
      .where("firebase_uid", "=", uid)
      .executeTakeFirst();

    if (!user) {
      res
        .status(404)
        .json({ error: "Complete account setup before onboarding." });
      return;
    }

    const profile = await db
      .insertInto("onboarding_profiles")
      .values({ user_id: user.id, ...data })
      .onConflict((oc) => oc.column("user_id").doUpdateSet(data))
      .returningAll()
      .executeTakeFirstOrThrow();

    res.status(200).json({ profile });
  },
);
