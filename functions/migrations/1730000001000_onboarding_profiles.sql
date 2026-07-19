-- Onboarding profiles for Module 1 (age, gender, pronouns) and Module 2
-- (sexual orientation, dating preferences, dating goals).
--
-- One row per user, keyed on users.id. Upserted by the submitOnboarding
-- endpoint so re-submitting is idempotent (bumps updated_at via trigger).

-- Up Migration

CREATE TYPE gender AS ENUM ('man', 'woman', 'non_binary', 'other');
CREATE TYPE sexual_orientation AS ENUM (
  'straight', 'gay', 'lesbian', 'bisexual',
  'pansexual', 'asexual', 'queer'
);
CREATE TYPE dating_preference AS ENUM ('men', 'women', 'non_binary', 'open_to_all');

CREATE TABLE onboarding_profiles (
  user_id                            UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  birthdate                          DATE,
  gender                             gender,
  custom_gender_identity             TEXT,
  gender_identity_option_ids         TEXT[] NOT NULL DEFAULT '{}',
  pronouns                           TEXT[] NOT NULL DEFAULT '{}',
  custom_pronoun                     TEXT,
  show_gender_on_profile             BOOLEAN NOT NULL DEFAULT false,
  show_pronouns_on_profile           BOOLEAN NOT NULL DEFAULT false,
  sexual_orientation                 sexual_orientation,
  show_sexual_orientation_on_profile BOOLEAN NOT NULL DEFAULT false,
  dating_preferences                 dating_preference[] NOT NULL DEFAULT '{}',
  dating_goal_ids                    TEXT[] NOT NULL DEFAULT '{}',
  created_at                         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER onboarding_profiles_set_updated_at
  BEFORE UPDATE ON onboarding_profiles
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at();

-- Down Migration

DROP TABLE IF EXISTS onboarding_profiles;
DROP TYPE IF EXISTS dating_preference;
DROP TYPE IF EXISTS sexual_orientation;
DROP TYPE IF EXISTS gender;
