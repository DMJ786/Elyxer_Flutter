/**
 * TypeScript definitions of the Postgres schema — the source of truth
 * for Kysely's type inference. Every column here corresponds to a real
 * column in a migration under `functions/migrations/`.
 *
 * When you add a column via migration, add it here too. There is no
 * codegen step; keep them in sync manually. Compiler errors at the
 * call sites are the safety net.
 */

import type { ColumnType, Generated } from "kysely";

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

export interface Database {
  users: UsersTable;
  onboarding_profiles: OnboardingProfilesTable;
}
