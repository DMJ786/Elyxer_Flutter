-- Rate limiting + response caching for /generateProfileStudio.
--
-- profile_studio_generations is an append-only event log used to enforce
-- a per-user daily generation cap (survives Cloud Function warm/cold
-- cycles). profile_studio_cache memoises (tone, inspiration) -> response
-- for a 24h TTL so identical requests skip Vertex.

-- Up Migration

CREATE TABLE profile_studio_generations (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  tone         TEXT NOT NULL,
  input_chars  INTEGER NOT NULL,
  duration_ms  INTEGER NOT NULL,
  succeeded    BOOLEAN NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX profile_studio_gens_user_created_idx
  ON profile_studio_generations (user_id, created_at DESC);

CREATE TABLE profile_studio_cache (
  cache_key    TEXT PRIMARY KEY,
  response     JSONB NOT NULL,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Down Migration

DROP TABLE IF EXISTS profile_studio_cache;
DROP TABLE IF EXISTS profile_studio_generations;
