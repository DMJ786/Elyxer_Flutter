/**
 * POST /finalizePhotoUpload
 *
 * Called by the client after it has PUT the bytes to the signed URL. Verifies
 * the path belongs to the caller (403 otherwise), that the object actually
 * exists in the bucket (404 — guards against orphaned rows), then records the
 * photo. A slot that already holds a photo returns 409 (client must replace).
 *
 * Body: `{ storagePath, position, isSelfie, widthPx?, heightPx?, sizeBytes? }`.
 */

import { onRequest } from "firebase-functions/v2/https";
import { getStorage } from "firebase-admin/storage";
import { getDb } from "../db/kysely";
import { AuthError, verifyIdToken } from "../auth/verifyIdToken";
import { isPathOwnedBy, validateFinalizeBody } from "./storage";

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

    const user = await getDb()
      .selectFrom("users")
      .select(["id"])
      .where("firebase_uid", "=", uid)
      .executeTakeFirst();

    if (!user) {
      res.status(404).json({ error: "Complete account setup before uploading." });
      return;
    }

    // Guard against orphaned rows: the object must actually be in the bucket.
    const [exists] = await getStorage().bucket().file(data.storagePath).exists();
    if (!exists) {
      res.status(404).json({ error: "Uploaded object not found in storage." });
      return;
    }

    try {
      const photo = await getDb()
        .insertInto("user_photos")
        .values({
          user_id: user.id,
          storage_path: data.storagePath,
          is_selfie: data.isSelfie,
          position: data.position,
          width_px: data.widthPx,
          height_px: data.heightPx,
          size_bytes: data.sizeBytes,
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
