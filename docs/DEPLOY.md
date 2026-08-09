# Elyxer — Provisioning & Deploy Runbook

How to stand up the `elyxer-dev` GCP/Firebase project, deploy the Cloud
Functions BFF, and point the Flutter app at it. (GitHub issue #40.)

> **Status:** the repo is pre-wired for this — `.firebaserc` targets
> `elyxer-dev`, `lib/core/config/env.dart` defaults `API_BASE_URL` to the
> deployed URL, and the functions read their config from env with safe
> defaults. What's left is the **console/CLI provisioning** below, which needs a
> GCP account with billing + owner rights.

---

## 0. What gets deployed

| Function | Auth | Needs Cloud SQL (`DATABASE_URL`) | Needs Vertex |
|---|---|---|---|
| `healthcheck` | public | no | no |
| `generateProfileStudio` | Firebase ID token | **yes** (rate-limit + cache) | **yes** |
| `submitUsername` | Firebase ID token | **yes** | no |
| `submitOnboarding` | Firebase ID token | **yes** | no |
| `submitBackground` | Firebase ID token | **yes** | no |
| `requestPhotoUploadUrl` / `finalizePhotoUpload` | Firebase ID token | **yes** + Cloud Storage | no |

> **Important:** every endpoint except `healthcheck` now needs a reachable
> Postgres (`DATABASE_URL`). So **Cloud SQL (§4) is required before the authed
> endpoints work** — a deploy without it still succeeds, but those functions
> will 500 at runtime. `healthcheck` is the only standalone smoke test.

---

## 1. Prerequisites

```bash
gcloud --version      # >= 460
firebase --version    # >= 13   (npm i -g firebase-tools)
gcloud auth login
gcloud auth application-default login
firebase login
```

You need: a **billing account** (Cloud Functions v2 requires it — free tier
still applies) and **owner / project-creator** on the org/folder.

---

## 2. Create the project + enable APIs

```bash
export PROJECT_ID=elyxer-dev
export REGION=asia-south1
export BILLING_ACCOUNT_ID=<from: gcloud beta billing accounts list>

gcloud projects create $PROJECT_ID --name="Elyxer Dev" --set-as-default
gcloud beta billing projects link $PROJECT_ID --billing-account=$BILLING_ACCOUNT_ID

gcloud services enable \
  cloudbuild.googleapis.com cloudfunctions.googleapis.com run.googleapis.com \
  artifactregistry.googleapis.com eventarc.googleapis.com pubsub.googleapis.com \
  storage.googleapis.com firestore.googleapis.com firebasehosting.googleapis.com \
  identitytoolkit.googleapis.com aiplatform.googleapis.com sqladmin.googleapis.com \
  secretmanager.googleapis.com --project=$PROJECT_ID
```

Verify: `gcloud beta billing projects describe $PROJECT_ID` → `billingEnabled: true`.

---

## 3. Register Firebase + enable auth providers

```bash
firebase projects:addfirebase $PROJECT_ID
firebase use --add $PROJECT_ID --alias default   # .firebaserc is already correct; this is a no-op check
```

In the [Firebase Console](https://console.firebase.google.com/) → Authentication → Sign-in method, enable **Google**, **Apple** (needs Apple team ID + key), and **Phone** (billing tier required for SMS).

---

## 4. Cloud SQL (Postgres + PostGIS) — required for the authed endpoints

```bash
gcloud sql instances create elyxer-pg \
  --database-version=POSTGRES_16 --tier=db-f1-micro --region=$REGION \
  --project=$PROJECT_ID
gcloud sql databases create elyxer --instance=elyxer-pg --project=$PROJECT_ID
gcloud sql users set-password postgres --instance=elyxer-pg --password=<STRONG_PW> --project=$PROJECT_ID
# Enable PostGIS + pgcrypto once (via `gcloud sql connect elyxer-pg` psql):
#   CREATE EXTENSION IF NOT EXISTS postgis;  CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

Run the migrations against it (from `functions/`, with `DATABASE_URL` pointing at
the instance — via the Cloud SQL Auth Proxy or a public IP for the one-off):

```bash
DATABASE_URL="postgres://postgres:<PW>@<HOST>:5432/elyxer" npm run db:migrate
```

Store the connection string as a secret and let the functions read it:

```bash
printf 'postgres://postgres:<PW>@/elyxer?host=/cloudsql/%s:%s:elyxer-pg' "$PROJECT_ID" "$REGION" \
  | gcloud secrets create DATABASE_URL --data-file=- --project=$PROJECT_ID
```

(`functions/src/db/pool.ts` reads `process.env.DATABASE_URL`; bind the secret at
deploy — see §7.)

---

## 5. IAM for the functions service account

Cloud Functions v2 runs as `$PROJECT_ID@appspot.gserviceaccount.com`.

```bash
export FN_SA="$PROJECT_ID@appspot.gserviceaccount.com"
for ROLE in aiplatform.user storage.objectAdmin secretmanager.secretAccessor cloudsql.client; do
  gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$FN_SA" --role="roles/$ROLE"
done
```

- `aiplatform.user` → Vertex (LLM), `storage.objectAdmin` → photo uploads (#35),
  `secretmanager.secretAccessor` → read `DATABASE_URL`, `cloudsql.client` → connect.

---

## 6. Enable Claude in Vertex Model Garden (one-time, browser)

Open the [Claude Haiku 4.5 model card](https://console.cloud.google.com/vertex-ai/publishers/anthropic/model-garden/claude-haiku-4-5?project=elyxer-dev),
click **Enable**, accept the Anthropic terms. No API key is stored — the function
uses application-default credentials (`functions/src/ai/vertex.ts`).

---

## 7. Deploy the functions

Runtime config (all non-secret; safe defaults exist in code, set explicitly for
clarity). `GCLOUD_PROJECT` is provided automatically by the runtime.

```bash
cd functions && npm install && npm run build && cd ..

firebase deploy --only functions --project=$PROJECT_ID
```

Set the Vertex knobs + bind the DB secret. Cloud Functions v2 reads
`functions/.env` at deploy (do **not** commit it — see `env.example`), or set on
the console under Functions → Configuration:

```
VERTEX_REGION=asia-south1
CLAUDE_MODEL=claude-haiku-4-5
CLAUDE_MAX_OUTPUT_TOKENS=800
```

Bind the secret so `DATABASE_URL` is injected at runtime (per function, or via
`functions/.env` referencing the secret). Confirm in Functions → Configuration
that `DATABASE_URL` shows as a bound secret.

---

## 8. Verify

```bash
# Public — no auth:
curl https://asia-south1-elyxer-dev.cloudfunctions.net/healthcheck
# Expect: { "status": "ok", "bundle": "0-foundation" }

# Authed — needs a real Firebase ID token (grab one from a signed-in client
# or the Auth emulator):
curl -X POST https://asia-south1-elyxer-dev.cloudfunctions.net/generateProfileStudio \
  -H "Authorization: Bearer <id-token>" -H "Content-Type: application/json" \
  -d '{"inspirationText":"weekends on trails, chai in hand","tone":"natural"}'
# Expect: 200 with a structured profile (or 429 once you hit the daily cap).
```

Logs: `firebase functions:log` or Console → Functions → Logs.

---

## 9. Point the Flutter app at the deployed BFF

`API_BASE_URL` is a compile-time `--dart-define` (default already targets
`elyxer-dev`, so a plain `flutter run` hits dev once it's deployed):

```bash
# Dev (default — can omit the flag):
flutter run --dart-define=API_BASE_URL=https://asia-south1-elyxer-dev.cloudfunctions.net

# Staging / prod (once those projects exist — mirror §2–§7):
flutter build apk --dart-define=API_BASE_URL=https://asia-south1-elyxer-staging.cloudfunctions.net
flutter build apk --dart-define=API_BASE_URL=https://asia-south1-elyxer-prod.cloudfunctions.net
```

The auth interceptor (PR #43) attaches the Firebase ID token automatically, so
no per-endpoint wiring is needed.

---

## 10. Rollback

```bash
firebase functions:delete healthcheck generateProfileStudio submitUsername \
  submitOnboarding submitBackground requestPhotoUploadUrl finalizePhotoUpload \
  --project=$PROJECT_ID
# Nuclear (only when starting over):
gcloud projects delete $PROJECT_ID
```

---

## Already wired in the repo (no action needed)

- `.firebaserc` → default project `elyxer-dev`.
- `lib/core/config/env.dart` → `API_BASE_URL` defaults to the deployed URL,
  overridable per build via `--dart-define`.
- `functions/src/ai/vertex.ts` → `VERTEX_REGION` (→ `asia-south1`),
  `CLAUDE_MODEL` (→ `claude-haiku-4-5`), `CLAUDE_MAX_OUTPUT_TOKENS` (→ `1024`)
  all default sensibly.
- `firebase.json` → functions deploy + emulator config.
- `env.example` → the full `--dart-define` / functions-env reference.

## Follow-ups (separate issues)

- `elyxer-staging` / `elyxer-prod` projects mirroring this one.
- Cloud Storage bucket CORS for the direct photo uploads (#35).
- Move remaining server secrets (Resend/MSG91/etc.) into Secret Manager.
