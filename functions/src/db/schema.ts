/**
 * TypeScript definitions of the Postgres schema — the source of truth
 * for Kysely's type inference. Every column here corresponds to a real
 * column in a migration under `functions/migrations/`.
 *
 * When you add a column via migration, add it here too. There is no
 * codegen step; keep them in sync manually. Compiler errors at the
 * call sites are the safety net.
 */

import type { ColumnType, Generated, RawBuilder } from "kysely";

/**
 * Wire up a column that Postgres fills automatically (defaults,
 * triggers) so Kysely knows it's optional on insert but required on
 * select.
 */
type AutoTimestamp = ColumnType<Date, string | undefined, string | undefined>;

/**
 * Postgres ENUM types — keep these string unions in lockstep with the
 * `CREATE TYPE ... AS ENUM (...)` statements in the migrations.
 */
export type Gender = "man" | "woman" | "non_binary" | "other";
export type SexualOrientation =
  | "straight"
  | "gay"
  | "lesbian"
  | "bisexual"
  | "pansexual"
  | "asexual"
  | "queer";
export type DatingPreference = "men" | "women" | "non_binary" | "open_to_all";
export type EducationLevel =
  | "high_school"
  | "undergraduate"
  | "postgraduate"
  | "doctorate"
  | "studying"
  | "prefer_not_to_say";

export interface UsersTable {
  id: Generated<string>;
  firebase_uid: string;
  phone_number: string | null;
  email: string | null;
  username: string | null;
  first_name: string | null;
  last_name: string | null;
  created_at: AutoTimestamp;
  updated_at: AutoTimestamp;
}

/**
 * A column whose Postgres default (`NOT NULL DEFAULT …`) means it may be
 * omitted on insert but is always present on select.
 */
type WithDefault<T> = ColumnType<T, T | undefined, T>;

export interface OnboardingProfilesTable {
  user_id: string;
  // DATE is read back as a string ("YYYY-MM-DD") and written as one.
  birthdate: ColumnType<string | null, string | null, string | null>;
  gender: Gender | null;
  custom_gender_identity: string | null;
  gender_identity_option_ids: WithDefault<string[]>;
  pronouns: WithDefault<string[]>;
  custom_pronoun: string | null;
  show_gender_on_profile: WithDefault<boolean>;
  show_pronouns_on_profile: WithDefault<boolean>;
  sexual_orientation: SexualOrientation | null;
  show_sexual_orientation_on_profile: WithDefault<boolean>;
  dating_preferences: WithDefault<DatingPreference[]>;
  dating_goal_ids: WithDefault<string[]>;
  created_at: AutoTimestamp;
  updated_at: AutoTimestamp;
}

/**
 * PostGIS GEOGRAPHY column. Kysely has no first-class geo type, so it is
 * written via a raw `ST_SetSRID(ST_MakePoint(...), 4326)::geography`
 * expression (or NULL) and never selected directly — endpoints project
 * `ST_X` / `ST_Y` instead.
 */
type GeographyPoint = ColumnType<
  string | null,
  RawBuilder<unknown> | null,
  RawBuilder<unknown> | null
>;

export interface BackgroundProfilesTable {
  user_id: string;
  industry: string | null;
  role: string | null;
  education_level: EducationLevel | null;
  location_query: string | null;
  location_point: GeographyPoint;
  created_at: AutoTimestamp;
  updated_at: AutoTimestamp;
}

/** Append-only log of Profile Studio generations, for daily rate limiting. */
export interface ProfileStudioGenerationsTable {
  id: Generated<string>;
  user_id: string;
  tone: string;
  input_chars: number;
  duration_ms: number;
  succeeded: boolean;
  created_at: AutoTimestamp;
}

/**
 * JSONB column — written via a raw `${json}::jsonb` expression and read
 * back as a parsed object by the pg driver.
 */
type JsonbColumn<Select> = ColumnType<
  Select,
  RawBuilder<unknown>,
  RawBuilder<unknown>
>;

/** (tone, inspiration) -> cached response, memoised with a 24h TTL. */
export interface ProfileStudioCacheTable {
  cache_key: string;
  response: JsonbColumn<Record<string, unknown>>;
  created_at: AutoTimestamp;
}

/** One row per stored photo; the bytes live in object storage (S3). */
export interface UserPhotosTable {
  id: Generated<string>;
  user_id: string;
  storage_path: string;
  is_selfie: WithDefault<boolean>;
  position: number;
  width_px: number | null;
  height_px: number | null;
  size_bytes: number | null;
  created_at: AutoTimestamp;
}

export interface Database {
  users: UsersTable;
  onboarding_profiles: OnboardingProfilesTable;
  background_profiles: BackgroundProfilesTable;
  profile_studio_generations: ProfileStudioGenerationsTable;
  profile_studio_cache: ProfileStudioCacheTable;
  user_photos: UserPhotosTable;
}
