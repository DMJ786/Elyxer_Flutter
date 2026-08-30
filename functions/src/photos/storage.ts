/**
 * Pure helpers for the photos pipeline — object-path building, UID scoping,
 * and request validation. No AWS/S3/DB here so the security-relevant rules
 * (path ownership, slot constraints, size cap) are unit-testable.
 */

/** Grid slots 0..4 are regular photos; slot 5 is the selfie. */
export const SELFIE_POSITION = 5;
export const MAX_POSITION = SELFIE_POSITION;

/** Presigned upload tickets are valid for 5 minutes. */
export const SIGNED_URL_TTL_MS = 5 * 60 * 1000;

/**
 * Max accepted photo size. Enforced at S3 via the presigned-POST
 * `content-length-range` policy AND re-checked against the object's real size
 * in finalize — the client-supplied size is never trusted.
 */
export const MAX_PHOTO_BYTES = 10 * 1024 * 1024;

/** Storage object path for a user's photo: `users/<uid>/photos/<id>.jpg`. */
export function photoObjectPath(uid: string, id: string): string {
  return `users/${uid}/photos/${id}.jpg`;
}

/**
 * True only if [path] is a well-formed object inside the caller's own
 * `users/<uid>/photos/` prefix — no traversal, no nested subdirectories.
 * This is the guard that stops a client finalizing a path outside its UID.
 */
export function isPathOwnedBy(path: string, uid: string): boolean {
  if (path.includes("..")) return false;
  const prefix = `users/${uid}/photos/`;
  if (!path.startsWith(prefix)) return false;
  const rest = path.slice(prefix.length);
  return rest.length > 0 && !rest.includes("/");
}

export type PhotoSlot = { position: number; isSelfie: boolean };

type Result<T> = { ok: true; value: T } | { ok: false; error: string };

/**
 * Validates a (position, isSelfie) slot: position is an int in 0..5,
 * and selfie ⇔ position 5 (regular photos may not claim the selfie slot).
 */
export function validateSlot(position: unknown, isSelfie: unknown): Result<PhotoSlot> {
  if (typeof isSelfie !== "boolean") {
    return { ok: false, error: "isSelfie must be a boolean." };
  }
  if (typeof position !== "number" || !Number.isInteger(position)) {
    return { ok: false, error: "position must be an integer." };
  }
  if (position < 0 || position > MAX_POSITION) {
    return { ok: false, error: `position must be between 0 and ${MAX_POSITION}.` };
  }
  if (isSelfie && position !== SELFIE_POSITION) {
    return { ok: false, error: `selfie must use position ${SELFIE_POSITION}.` };
  }
  if (!isSelfie && position === SELFIE_POSITION) {
    return {
      ok: false,
      error: `position ${SELFIE_POSITION} is reserved for the selfie.`,
    };
  }
  return { ok: true, value: { position, isSelfie } };
}

export type FinalizeInput = {
  storagePath: string;
  position: number;
  isSelfie: boolean;
  // Optional client hints (display metadata); size is NOT taken from the
  // client — finalize reads the real object size from S3.
  widthPx: number | null;
  heightPx: number | null;
};

/** Optional non-negative integer, or `null` when absent. `undefined` = invalid. */
function optNonNegInt(v: unknown): number | null | undefined {
  if (v === undefined || v === null) return null;
  if (typeof v !== "number" || !Number.isInteger(v) || v < 0) return undefined;
  return v;
}

/** Validates the `finalizePhotoUpload` body. */
export function validateFinalizeBody(body: unknown): Result<FinalizeInput> {
  const b = (body ?? {}) as Record<string, unknown>;

  if (typeof b.storagePath !== "string" || b.storagePath.trim().length === 0) {
    return { ok: false, error: "storagePath is required." };
  }

  const slot = validateSlot(b.position, b.isSelfie);
  if (!slot.ok) return slot;

  const widthPx = optNonNegInt(b.widthPx);
  if (widthPx === undefined) {
    return { ok: false, error: "widthPx must be a non-negative integer." };
  }
  const heightPx = optNonNegInt(b.heightPx);
  if (heightPx === undefined) {
    return { ok: false, error: "heightPx must be a non-negative integer." };
  }

  return {
    ok: true,
    value: {
      storagePath: b.storagePath.trim(),
      position: slot.value.position,
      isSelfie: slot.value.isSelfie,
      widthPx,
      heightPx,
    },
  };
}
