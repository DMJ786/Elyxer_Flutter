/**
 * POST /finalizePhotoUpload
 *
 * Called by the client after it has uploaded the bytes via the presigned POST.
 * Verifies the path belongs to the caller (403 otherwise), reads the object's
 * REAL size + content-type from S3 (404 if absent; 413/400 if it violates the
 * limits — never trusting client-supplied metadata), then records the photo. A
 * slot that already holds a photo returns 409, and the just-uploaded object is
 * deleted so it doesn't orphan in the bucket.
 *
 * Body: `{ storagePath, position, isSelfie, widthPx?, heightPx? }`.
 */

import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";
import { getDb } from "../db/kysely";
import { AuthError, verifyIdToken } from "../auth/verifyIdToken";
import { isPathOwnedBy, MAX_PHOTO_BYTES, validateFinalizeBody } from "./storage";
import { deleteObject, headObject } from "./s3";

/** Postgres unique-violation SQLSTATE. */
const UNIQUE_VIOLATION = "23505";

export const finalizePhotoUpload = onRequest(
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

    const validation = validateFinalizeBody(req.body);
    if (!validation.ok) {
      res.status(400).json({ error: validation.error });
      return;
    }
    const data = validation.value;

    // The path must live under the caller's own prefix.
    if (!isPathOwnedBy(data.storagePath, uid)) {
      res.status(403).json({ error: "storagePath is not owned by the caller." });
      return;
    }

    let userId: string;
    let sizeBytes: number;
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
      userId = user.id;

      // Server-verified metadata: the object must exist, be a JPEG, and be
      // within the size cap. The client-supplied size is never trusted.
      const meta = await headObject(data.storagePath);
      if (!meta) {
        res.status(404).json({ error: "Uploaded object not found in storage." });
        return;
      }
      if (meta.sizeBytes <= 0 || meta.sizeBytes > MAX_PHOTO_BYTES) {
        await deleteObject(data.storagePath);
        res.status(413).json({ error: "Uploaded photo exceeds the size limit." });
        return;
      }
      if (meta.contentType && !meta.contentType.startsWith("image/")) {
        await deleteObject(data.storagePath);
        res.status(400).json({ error: "Uploaded object is not an image." });
        return;
      }
      sizeBytes = meta.sizeBytes;
    } catch (e) {
      logger.error("photos.finalize.unavailable", {
        uid,
        message: e instanceof Error ? e.message : String(e),
      });
      res.status(503).json({
        error: "Photo upload is temporarily unavailable. Please try again.",
      });
      return;
    }

    try {
      const photo = await getDb()
        .insertInto("user_photos")
        .values({
          user_id: userId,
          storage_path: data.storagePath,
          is_selfie: data.isSelfie,
          position: data.position,
          width_px: data.widthPx,
          height_px: data.heightPx,
          size_bytes: sizeBytes,
        })
        .returning([
          "id",
          "user_id",
          "storage_path",
          "is_selfie",
          "position",
          "width_px",
          "height_px",
          "size_bytes",
          "created_at",
        ])
        .executeTakeFirstOrThrow();

      res.status(201).json({ photo });
    } catch (e) {
      // The upload doesn't belong to any accepted row now — delete it so it
      // doesn't orphan in the bucket (the 409-replace path hits this too).
      await deleteObject(data.storagePath);

      // (user_id, position) or storage_path already exists.
      if ((e as { code?: string }).code === UNIQUE_VIOLATION) {
        res.status(409).json({
          error: "A photo already occupies this slot. Replace it first.",
        });
        return;
      }
      throw e;
    }
  },
);
