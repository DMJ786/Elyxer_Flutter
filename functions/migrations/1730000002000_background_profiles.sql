-- Background profiles for Module 4 (education level, profession, location).
--
-- Location is stored as a PostGIS GEOGRAPHY(POINT, 4326) so it can be reused
-- for Module 7 discovery / distance filters. One row per user, upserted by
-- the submitBackground endpoint.

-- Up Migration

CREATE TYPE education_level AS ENUM (
  'high_school', 'undergraduate', 'postgraduate',
  'doctorate', 'studying', 'prefer_not_to_say'
);

CREATE TABLE background_profiles (
  user_id            UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  industry           TEXT,
  role               TEXT,
  education_level    education_level,
  location_query     TEXT,
  location_point     GEOGRAPHY(POINT, 4326),
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX background_profiles_location_idx
  ON background_profiles USING GIST (location_point);

CREATE TRIGGER background_profiles_set_updated_at
  BEFORE UPDATE ON background_profiles
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at();

-- Down Migration

DROP TABLE IF EXISTS background_profiles;
DROP TYPE IF EXISTS education_level;
