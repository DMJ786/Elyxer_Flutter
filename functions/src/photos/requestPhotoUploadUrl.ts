/**
 * POST /requestPhotoUploadUrl
 *
 * Issues a short-lived (5 min) Cloud Storage signed URL the client PUTs the
 * image bytes to directly, keeping the function out of the upload path. The
 * object path is always scoped to the caller's UID
 * (`users/<uid>/photos/<uuid>.jpg`), so a client can never obtain a URL for
 * someone else's prefix.
 *
 * Body: `{ position, isSelfie }`. Returns `{ uploadUrl, storagePath }`.
 */

import { randomUUID } from "crypto";
import { onRequest } from "firebase-functions/v2/https";
import { getStorage } from "firebase-admin/storage";
import { getDb } from "../db/kysely";
import { AuthError, verifyIdToken } from "../auth/verifyIdToken";
import { photoObjectPath, SIGNED_URL_TTL_MS, validateSlot } from "./storage";

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

    const user = await getDb()
      .selectFrom("users")
      .select(["id"])
      .where("firebase_uid", "=", uid)
      .executeTakeFirst();

    if (!user) {
      res.status(404).json({ error: "Complete account setup before uploading." });
      return;
    }

    // Path is derived server-side and scoped to the UID — the client never
    // supplies it, so it can't target another user's prefix.
    const storagePath = photoObjectPath(uid, randomUUID());

    const [uploadUrl] = await getStorage()
      .bucket()
      .file(storagePath)
      .getSignedUrl({
        version: "v4",
        action: "write",
        expires: Date.now() + SIGNED_URL_TTL_MS,
        contentType: "image/jpeg",
      });

    res.status(200).json({
      uploadUrl,
      storagePath,
      contentType: "image/jpeg",
      expiresInMs: SIGNED_URL_TTL_MS,
    });
  },
);
