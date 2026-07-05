/**
 * Kysely instance — the query builder used by every endpoint.
 *
 * Wraps the shared `pg` pool from `pool.ts`. Kysely's PostgresDialect
 * pulls a client from the pool per query (or per transaction) so we
 * don't have to manage connections manually.
 */

import { Kysely, PostgresDialect } from "kysely";
import type { Database } from "./schema";
import { getPool } from "./pool";

let dbInstance: Kysely<Database> | undefined;

export function getDb(): Kysely<Database> {
  if (dbInstance) return dbInstance;

  dbInstance = new Kysely<Database>({
    dialect: new PostgresDialect({ pool: getPool() }),
    log: process.env.DB_DEBUG_LOG === "true" ? ["query", "error"] : ["error"],
  });

  return dbInstance;
}
