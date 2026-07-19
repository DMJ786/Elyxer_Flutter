/**
 * POST /submitBackground
 *
 * Persists a user's Module 4 selections — education level, profession
 * (industry + role), and location — into `background_profiles`. The
 * location arrives as lat/lng and is stored as a PostGIS
 * GEOGRAPHY(POINT, 4326) so it can drive distance filters later.
 *
 * Same shape as submitOnboarding: verify the Firebase ID token, resolve
 * the caller's `users.id`, validate the body, then upsert on `user_id`.
 */

import { onRequest } from "firebase-functions/v2/https";
import { sql } from "kysely";
import { getDb } from "../db/kysely";
import type { EducationLevel } from "../db/schema";
import { AuthError, verifyIdToken } from "../auth/verifyIdToken";

const EDUCATION_LEVELS = new Set<EducationLevel>([
  "high_school",
  "undergraduate",
  "postgraduate",
  "doctorate",
  "studying",
  "prefer_not_to_say",
]);

/** Normalized, validated body ready to write to `background_profiles`. */
export type NormalizedBackground = {
  industry: string | null;
  role: string | null;
  education_level: EducationLevel | null;
  location_query: string | null;
  location: { lat: number; lng: number } | null;
};

export type ValidationResult =
  | { ok: true; value: NormalizedBackground }
  | { ok: false; error: string };

function asStringOrNull(v: unknown): string | null {
  if (typeof v !== "string") return null;
  const trimmed = v.trim();
  return trimmed.length > 0 ? trimmed : null;
}

function isNullish(v: unknown): boolean {
  return v === undefined || v === null;
}

/**
 * Pure request-body validator — no Firebase or DB. Enforces the enum and
 * the lat/lng ranges, and that lat/lng are supplied together.
 */
export function validateBackgroundBody(body: unknown): ValidationResult {
  const b = (body ?? {}) as Record<string, unknown>;

  let educationLevel: EducationLevel | null = null;
  if (!isNullish(b.educationLevel)) {
    if (
      typeof b.educationLevel !== "string" ||
      !EDUCATION_LEVELS.has(b.educationLevel as EducationLevel)
    ) {
      return {
        ok: false,
        error: `Invalid educationLevel: ${String(b.educationLevel)}`,
      };
    }
    educationLevel = b.educationLevel as EducationLevel;
  }

  // Location — lat and lng must be supplied together, each within range.
  const hasLat = !isNullish(b.latitude);
  const hasLng = !isNullish(b.longitude);
  let location: { lat: number; lng: number } | null = null;

  if (hasLat !== hasLng) {
    return {
      ok: false,
      error: "latitude and longitude must be provided together.",
    };
  }

  if (hasLat && hasLng) {
    const lat = b.latitude;
    const lng = b.longitude;
    if (
      typeof lat !== "number" ||
      typeof lng !== "number" ||
      !Number.isFinite(lat) ||
      !Number.isFinite(lng)
    ) {
      return { ok: false, error: "latitude and longitude must be numbers." };
    }
    if (lat < -90 || lat > 90) {
      return { ok: false, error: "latitude must be between -90 and 90." };
    }
    if (lng < -180 || lng > 180) {
      return { ok: false, error: "longitude must be between -180 and 180." };
    }
    location = { lat, lng };
  }

  return {
    ok: true,
    value: {
      industry: asStringOrNull(b.industry),
      role: asStringOrNull(b.role),
      education_level: educationLevel,
      location_query: asStringOrNull(b.locationQuery),
      location,
    },
  };
}

export const submitBackground = onRequest(
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

    const validation = validateBackgroundBody(req.body);
    if (!validation.ok) {
      res.status(400).json({ error: validation.error });
      return;
    }
    const data = validation.value;

    const db = getDb();

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

    // lat/lng -> geography point, or NULL when no location was provided.
    const locationPoint =
      data.location === null
        ? null
        : sql`ST_SetSRID(ST_MakePoint(${data.location.lng}, ${data.location.lat}), 4326)::geography`;

    const columns = {
      industry: data.industry,
      role: data.role,
      education_level: data.education_level,
      location_query: data.location_query,
      location_point: locationPoint,
    };

    const profile = await db
      .insertInto("background_profiles")
      .values({ user_id: user.id, ...columns })
      .onConflict((oc) => oc.column("user_id").doUpdateSet(columns))
      .returning([
        "user_id",
        "industry",
        "role",
        "education_level",
        "location_query",
        // Project the point back to plain coordinates for the client.
        sql<number | null>`ST_X(location_point::geometry)`.as("longitude"),
        sql<number | null>`ST_Y(location_point::geometry)`.as("latitude"),
        "created_at",
        "updated_at",
      ])
      .executeTakeFirstOrThrow();

    res.status(200).json({ profile });
  },
);
