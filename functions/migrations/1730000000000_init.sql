-- Initial schema for the Elyxer BFF.
--
-- Enables extensions we'll need before data volume makes migrations
-- painful (postgis for geo; pgcrypto for gen_random_uuid()), and adds
-- the users table plus a generic updated_at trigger.

-- Up Migration

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  firebase_uid  TEXT NOT NULL UNIQUE,
  phone_number  TEXT UNIQUE,
  email         TEXT UNIQUE,
  username      TEXT UNIQUE,
  first_name    TEXT,
  last_name     TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX users_username_lower_idx ON users (LOWER(username));

CREATE TRIGGER users_set_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at();

-- Down Migration

DROP TRIGGER IF EXISTS users_set_updated_at ON users;
DROP INDEX IF EXISTS users_username_lower_idx;
DROP TABLE IF EXISTS users;
DROP FUNCTION IF EXISTS set_updated_at();
-- Extensions are left in place — dropping them can break other schemas
-- and re-installing PostGIS is expensive.
