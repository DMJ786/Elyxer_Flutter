#!/bin/bash
# LocalStack init hook (runs once the edge port is ready).
# Seeds the photos bucket + permissive dev CORS so the presigned-URL upload
# flow (request URL -> PUT bytes -> finalize) works end-to-end locally.
#
# `awslocal` is the LocalStack-bundled aws CLI (pre-pointed at :4566).
set -euo pipefail

BUCKET="elyxer-photos"

awslocal s3 mb "s3://${BUCKET}" 2>/dev/null || echo "bucket ${BUCKET} already exists"

awslocal s3api put-bucket-cors --bucket "${BUCKET}" --cors-configuration '{
  "CORSRules": [
    {
      "AllowedMethods": ["GET", "PUT", "HEAD"],
      "AllowedOrigins": ["*"],
      "AllowedHeaders": ["*"],
      "ExposeHeaders": ["ETag"]
    }
  ]
}'

echo "LocalStack bootstrap complete: s3://${BUCKET} (region ap-south-1)"
