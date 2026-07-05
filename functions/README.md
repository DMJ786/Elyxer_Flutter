# Elyxer Cloud Functions BFF

TypeScript Firebase Cloud Functions (Node 20, `asia-south1`) that
sit between the Flutter app and the Postgres database, Cloud Storage,
and third-party services.

## Stack

| Layer | Choice | Why |
|---|---|---|
| Runtime | Firebase Cloud Functions (v2) | Same project as Auth + Storage; simple deploy |
| Language | TypeScript strict | Refactor safety across the API surface |
| DB engine | Postgres 16 + PostGIS 3.4 | Geospatial for Module 7 discovery, JSONB for flexible fields |
| Query layer | [Kysely](https://kysely.dev/) | Typed queries that read like SQL, no ORM overhead / no cold-start penalty |
| Driver | `pg` | Native, well-supported |
| Migrations | [`node-pg-migrate`](https://github.com/salsita/node-pg-migrate) | Plain SQL files checked into `migrations/` |
| Local dev DB | Docker Compose | Reproducible, one-command spin-up |
| Prod DB | Google Cloud SQL for Postgres | IAM auth, VPC access from Functions |

## Local development

### One-time setup

```bash
# From repo root:
cd functions
cp .env.example .env             # local defaults are already correct
npm install
npm run db:up                    # starts Postgres in Docker
npm run db:migrate               # applies all migrations
```

### Everyday commands

| Command | What it does |
|---|---|
| `npm run db:up` | Start the local Postgres container |
| `npm run db:down` | Stop the container (data persists) |
| `npm run db:reset` | **Wipes data** and re-creates the container |
| `npm run db:logs` | Follow Postgres logs |
| `npm run db:psql` | Open a psql shell against the local DB |
| `npm run db:migrate` | Apply pending migrations |
| `npm run db:migrate:down` | Roll back the most recent migration |
| `npm run db:migrate:create -- <name>` | Scaffold a new SQL migration file |
| `npm run build` | Compile TypeScript to `lib/` |
| `npm run serve` | Build + start the Firebase emulator (Functions on :5001) |

### Adding a new endpoint

1. Add a file under `src/<area>/<endpoint>.ts` — see `src/auth/submitUsername.ts` for the template
2. Export it from `src/index.ts`
3. If it needs new columns/tables:
   1. `npm run db:migrate:create -- <descriptive-name>`
   2. Fill in the `-- Up Migration` and `-- Down Migration` sections
   3. Add the matching types to `src/db/schema.ts` (**no codegen — keep manual**)
   4. `npm run db:migrate`
4. Wire it into the Flutter service in `lib/services/`

## Directory layout

```
functions/
├── docker-compose.yml         # Local Postgres 16 + PostGIS 3.4
├── migrations/                # SQL migrations, timestamped filenames
│   └── 1730000000000_init.sql
├── src/
│   ├── index.ts               # Function exports (Firebase entry point)
│   ├── db/
│   │   ├── pool.ts            # pg connection pool singleton
│   │   ├── kysely.ts          # Kysely instance
│   │   └── schema.ts          # Typed schema for Kysely
│   └── auth/
│       ├── verifyIdToken.ts   # Firebase ID-token verification helper
│       └── submitUsername.ts  # POST /auth/username
└── package.json
```

## Production deploy

Cloud SQL production values are in **Google Secret Manager** and
injected at deploy time via `firebase functions:secrets:set`. Do not
put prod credentials in `.env`, `.runtimeconfig.json`, or source.

```bash
# From repo root:
npm --prefix functions run build
firebase deploy --only functions
```

Migrations against Cloud SQL are a manual step (Cloud SQL Auth Proxy
+ `npm run db:migrate` with the prod `DATABASE_URL`) — automated
migration deploys are deferred until we have a staging environment.

## Testing an endpoint locally

```bash
# Terminal 1: DB
npm run db:up
npm run db:migrate

# Terminal 2: Functions emulator
npm run serve

# Terminal 3: hit the endpoint (you'll need a valid Firebase ID token)
curl -X POST http://localhost:5001/<project-id>/asia-south1/submitUsername \
  -H "Authorization: Bearer <id-token>" \
  -H "Content-Type: application/json" \
  -d '{"username":"dhili","firstName":"Dhili"}'
```
