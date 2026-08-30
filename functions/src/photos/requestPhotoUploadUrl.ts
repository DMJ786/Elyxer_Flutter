/**
 * POST /requestPhotoUploadUrl
 *
 * Issues a short-lived (5 min) S3 presigned POST the client uploads the image
 * bytes to directly, keeping the function out of the upload path. The object
 * key is always scoped to the caller's UID (`users/<uid>/photos/<uuid>.jpg`),
 * so a client can never obtain a ticket for someone else's prefix. The POST
 * policy locks content-type to image/jpeg AND enforces the size cap
 * (`content-length-range`), so an over-limit body is rejected by S3.
 *
 * Body: `{ position, isSelfie }`.
 * Returns `{ upload: { url, fields }, storagePath, contentType, maxBytes,
 *            expiresInMs }`.
 */

import { randomUUID } from "crypto";
import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";
import { getDb } from "../db/kysely";
import { AuthError, verifyIdToken } from "../auth/verifyIdToken";
import {
  MAX_PHOTO_BYTES,
  photoObjectPath,
  SIGNED_URL_TTL_MS,
  validateSlot,
} from "./storage";
import { createUploadPost } from "./s3";

export const requestPhotoUploadUrl = onRequest(
  { region: "asia-south1" },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({ error: "Method not allowed." });
      return;
    }

    let uid: string;
    try {
      const decoded = await verifyIdToken(req);
      uid = decoded.uid;
    } catch (e) {
      if (e instanceof AuthError) {
        res.status(e.status).json({ error: e.message });
        return;
      }
      throw e;
    }

    const body = (req.body ?? {}) as Record<string, unknown>;
    const slot = validateSlot(body.position, body.isSelfie);
    if (!slot.ok) {
      res.status(400).json({ error: slot.error });
      return;
    }

    let storagePath: string;
    let upload: { url: string; fields: Record<string, string> };
    try {
      const user = await getDb()
        .selectFrom("users")
        .select(["id"])
        .where("firebase_uid", "=", uid)
        .executeTakeFirst();

      if (!user) {
        res
          .status(404)
          .json({ error: "Complete account setup before uploading." });
        return;
      }

      // Key is derived server-side and scoped to the UID — the client never
      // supplies it, so it can't target another user's prefix.
      storagePath = photoObjectPath(uid, randomUUID());
      upload = await createUploadPost(storagePath);
    } catch (e) {
      logger.error("photos.request_upload.unavailable", {
        uid,
        message: e instanceof Error ? e.message : String(e),
      });
      res.status(503).json({
        error: "Photo upload is temporarily unavailable. Please try again.",
      });
      return;
    }

    res.status(200).json({
      upload,
      storagePath,
      contentType: "image/jpeg",
      maxBytes: MAX_PHOTO_BYTES,
      expiresInMs: SIGNED_URL_TTL_MS,
    });
  },
);
