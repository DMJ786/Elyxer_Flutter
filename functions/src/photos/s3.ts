/**
 * S3 client + object helpers for the photos pipeline.
 *
 * Credentials come from the standard AWS provider chain (an IAM role on the
 * BFF compute in prod, or `aws configure` / SSO / AWS_* locally). Setting
 * `AWS_ENDPOINT_URL` (+ path-style addressing) points it at LocalStack for
 * local dev — see functions/localstack/README.md.
 */

import {
  S3Client,
  HeadObjectCommand,
  DeleteObjectCommand,
} from "@aws-sdk/client-s3";
import { createPresignedPost } from "@aws-sdk/s3-presigned-post";
import { MAX_PHOTO_BYTES, SIGNED_URL_TTL_MS } from "./storage";

let client: S3Client | undefined;

function s3(): S3Client {
  if (client) return client;
  const endpoint = process.env.AWS_ENDPOINT_URL; // set → LocalStack/local dev
  client = new S3Client({
    region: process.env.AWS_REGION || "ap-south-1",
    // LocalStack needs path-style addressing + an explicit endpoint.
    ...(endpoint ? { endpoint, forcePathStyle: true } : {}),
  });
  return client;
}

function bucket(): string {
  const b = process.env.PHOTOS_BUCKET;
  if (!b) throw new Error("PHOTOS_BUCKET is not set.");
  return b;
}

/** A browser/mobile-ready presigned POST: form-encode [fields] + the file. */
export type UploadTicket = { url: string; fields: Record<string, string> };

/**
 * Presigned POST for [key] that only accepts a JPEG within the size cap. The
 * `content-length-range` condition makes S3 REJECT an over-limit body at
 * upload time — the size cap is enforced by storage, not trusted from the
 * client.
 */
export async function createUploadPost(key: string): Promise<UploadTicket> {
  const { url, fields } = await createPresignedPost(s3(), {
    Bucket: bucket(),
    Key: key,
    Conditions: [
      ["content-length-range", 1, MAX_PHOTO_BYTES],
      ["eq", "$Content-Type", "image/jpeg"],
    ],
    Fields: { "Content-Type": "image/jpeg" },
    Expires: Math.floor(SIGNED_URL_TTL_MS / 1000),
  });
  return { url, fields };
}

export type ObjectMeta = { sizeBytes: number; contentType: string | undefined };

/** HEADs an object; returns its real size + content-type, or null if absent. */
export async function headObject(key: string): Promise<ObjectMeta | null> {
  try {
    const out = await s3().send(
      new HeadObjectCommand({ Bucket: bucket(), Key: key }),
    );
    return { sizeBytes: out.ContentLength ?? 0, contentType: out.ContentType };
  } catch (e) {
    const err = e as { name?: string; $metadata?: { httpStatusCode?: number } };
    if (err.name === "NotFound" || err.$metadata?.httpStatusCode === 404) {
      return null;
    }
    throw e;
  }
}

/** Best-effort delete (orphan cleanup on a failed finalize). Never throws. */
export async function deleteObject(key: string): Promise<void> {
  try {
    await s3().send(new DeleteObjectCommand({ Bucket: bucket(), Key: key }));
  } catch {
    // best-effort — a leftover object is swept by the bucket lifecycle rule.
  }
}
