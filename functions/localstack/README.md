# LocalStack — local AWS for the BFF (issue #70)

Runs a local AWS emulator so AWS-dependent code (S3 presigned photo uploads,
SSM/Secrets Manager config, SNS) works **before the real AWS account exists**.
Part of the AWS single-cloud migration (#53); unblocks the #49 S3 rework.

## What runs

Defined as the `localstack` service in [`../docker-compose.yml`](../docker-compose.yml):

| Service | Emulated | Notes |
|---|---|---|
| **S3** | ✅ | Photos bucket `elyxer-photos`, seeded on start with dev CORS |
| **SSM / Secrets Manager** | ✅ | For DB connection string + app secrets |
| **SNS** | ✅ | For future SMS OTP wiring |
| **Cognito** | ❌ | Needs **LocalStack Pro** (license token) — see #54 |
| **Bedrock** | ❌ | LocalStack only serves local open models, not Claude — use real Bedrock (#57) or a mock |

Edge port: **`http://localhost:4566`** (all service APIs). Ephemeral
(`PERSISTENCE=0`): the bucket is re-created from
[`init/01-bootstrap.sh`](init/01-bootstrap.sh) on every start.

## Bring it up

```bash
cd functions
npm run db:up            # starts Postgres + LocalStack
npm run localstack:health   # -> {"services": {"s3": "available", ...}}
```

Bring up only LocalStack: `npm run localstack:up`. Tail logs:
`npm run localstack:logs`.

## Point the BFF at it

For local dev, set these in `functions/.env` (git-ignored). LocalStack accepts
any dummy credentials:

```bash
AWS_ENDPOINT_URL=http://localhost:4566   # redirects the AWS SDK to LocalStack
AWS_REGION=ap-south-1
AWS_ACCESS_KEY_ID=test
AWS_SECRET_ACCESS_KEY=test
PHOTOS_BUCKET=elyxer-photos
```

> ⚠️ `AWS_ENDPOINT_URL` redirects **every** AWS SDK client in the process, so
> real Bedrock (#57) and LocalStack S3 can't be used in the same run. Comment
> it out when exercising real Bedrock.

## Verify S3 by hand

```bash
# List the seeded bucket
aws --endpoint-url=http://localhost:4566 --region ap-south-1 s3 ls
# -> 2026-... elyxer-photos

# Round-trip an object
echo hi | aws --endpoint-url=http://localhost:4566 s3 cp - s3://elyxer-photos/hello.txt
aws --endpoint-url=http://localhost:4566 s3 ls s3://elyxer-photos/
```

(Uses your host `aws` CLI with any dummy creds; or run the same commands as
`awslocal ...` inside the container via `docker compose exec localstack`.)
