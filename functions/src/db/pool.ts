/**
 * Singleton `pg` connection pool.
 *
 * Cloud Functions instances are short-lived (autoscaled to zero) but a
 * warm instance may serve many requests, so a small pool (max 3) is
 * the sweet spot: enough for a few concurrent queries, few enough that
 * Cloud SQL isn't saturated by connection churn.
 *
 * The pool is created lazily on first import and shared across all
 * imports within a single Node process.
 */

import { Pool } from "pg";

let pool: Pool | undefined;

export function getPool(): Pool {
  if (pool) return pool;

  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error(
      "DATABASE_URL is not set. Copy functions/.env.example to " +
        "functions/.env for local dev, or configure Secret Manager for " +
        "prod deploys.",
    );
  }

  pool = new Pool({
    connectionString,
    max: 3,
    idleTimeoutMillis: 10_000,
    connectionTimeoutMillis: 5_000,
  });

  return pool;
}

/** Test-only: dispose the pool so a fresh one can be created. */
export async function resetPoolForTesting(): Promise<void> {
  if (!pool) return;
  await pool.end();
  pool = undefined;
}
