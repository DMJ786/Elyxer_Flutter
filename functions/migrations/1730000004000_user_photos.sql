-- Module 5 photo records. The image bytes live in Cloud Storage; this table
-- only records the final object path + metadata after a successful upload.
--
-- position 0..4 = regular grid photos, 5 = selfie. The unique (user_id,
-- position) index enforces one photo per slot — the client must replace
-- (delete + re-upload) to change a slot.

-- Up Migration

CREATE TABLE user_photos (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  storage_path  TEXT NOT NULL UNIQUE,
  is_selfie     BOOLEAN NOT NULL DEFAULT false,
  position      SMALLINT NOT NULL,
  width_px      INTEGER,
  height_px     INTEGER,
  size_bytes    INTEGER,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX user_photos_user_position_idx
  ON user_photos (user_id, position);

-- Down Migration

DROP TABLE IF EXISTS user_photos;
