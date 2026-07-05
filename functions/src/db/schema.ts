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

export interface Database {
  users: UsersTable;
}
