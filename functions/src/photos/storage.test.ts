import {
  isPathOwnedBy,
  photoObjectPath,
  SELFIE_POSITION,
  validateFinalizeBody,
  validateSlot,
} from "./storage";

describe("photoObjectPath", () => {
  it("scopes the object under the user's photos prefix", () => {
    expect(photoObjectPath("uid-123", "abc")).toBe(
      "users/uid-123/photos/abc.jpg",
    );
  });
});

describe("isPathOwnedBy", () => {
  it("accepts a well-formed path under the caller's prefix", () => {
    expect(isPathOwnedBy("users/uid-1/photos/abc.jpg", "uid-1")).toBe(true);
  });

  it("rejects another user's prefix", () => {
    expect(isPathOwnedBy("users/uid-2/photos/abc.jpg", "uid-1")).toBe(false);
  });

  it("rejects path traversal", () => {
    expect(isPathOwnedBy("users/uid-1/photos/../../secret.jpg", "uid-1")).toBe(
      false,
    );
  });

  it("rejects nested subdirectories under the prefix", () => {
    expect(isPathOwnedBy("users/uid-1/photos/sub/abc.jpg", "uid-1")).toBe(false);
  });

  it("rejects the bare prefix with no object name", () => {
    expect(isPathOwnedBy("users/uid-1/photos/", "uid-1")).toBe(false);
  });

  it("rejects a prefix-collision impostor uid", () => {
    // "uid-1" must not match "uid-12"'s prefix.
    expect(isPathOwnedBy("users/uid-12/photos/abc.jpg", "uid-1")).toBe(false);
  });
});

describe("validateSlot", () => {
  it("accepts regular positions 0..4 with isSelfie false", () => {
    for (let p = 0; p < SELFIE_POSITION; p++) {
      expect(validateSlot(p, false).ok).toBe(true);
    }
  });

  it("accepts the selfie slot (5, isSelfie true)", () => {
    expect(validateSlot(SELFIE_POSITION, true).ok).toBe(true);
  });

  it("rejects a regular photo claiming the selfie slot", () => {
    expect(validateSlot(SELFIE_POSITION, false).ok).toBe(false);
  });

  it("rejects a selfie at a non-5 position", () => {
    expect(validateSlot(2, true).ok).toBe(false);
  });

  it("rejects out-of-range and non-integer positions", () => {
    expect(validateSlot(-1, false).ok).toBe(false);
    expect(validateSlot(6, false).ok).toBe(false);
    expect(validateSlot(1.5, false).ok).toBe(false);
  });

  it("rejects a non-boolean isSelfie", () => {
    expect(validateSlot(0, "no" as unknown).ok).toBe(false);
  });
});

describe("validateFinalizeBody", () => {
  it("normalizes a valid body with metadata", () => {
    const r = validateFinalizeBody({
      storagePath: "  users/uid-1/photos/abc.jpg  ",
      position: 0,
      isSelfie: false,
      widthPx: 1080,
      heightPx: 1920,
    });
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value).toEqual({
      storagePath: "users/uid-1/photos/abc.jpg", // trimmed
      position: 0,
      isSelfie: false,
      widthPx: 1080,
      heightPx: 1920,
    });
  });

  it("ignores a client-supplied sizeBytes (size is server-verified)", () => {
    const r = validateFinalizeBody({
      storagePath: "users/uid-1/photos/abc.jpg",
      position: 0,
      isSelfie: false,
      sizeBytes: 999999999,
    });
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value).not.toHaveProperty("sizeBytes");
  });

  it("defaults missing metadata to null", () => {
    const r = validateFinalizeBody({
      storagePath: "users/uid-1/photos/abc.jpg",
      position: 5,
      isSelfie: true,
    });
    expect(r.ok).toBe(true);
    if (!r.ok) return;
    expect(r.value.widthPx).toBeNull();
    expect(r.value.heightPx).toBeNull();
  });

  it("rejects a missing storagePath", () => {
    expect(validateFinalizeBody({ position: 0, isSelfie: false }).ok).toBe(false);
  });

  it("rejects negative or non-integer metadata", () => {
    expect(
      validateFinalizeBody({
        storagePath: "users/uid-1/photos/abc.jpg",
        position: 0,
        isSelfie: false,
        heightPx: -1,
      }).ok,
    ).toBe(false);
    expect(
      validateFinalizeBody({
        storagePath: "users/uid-1/photos/abc.jpg",
        position: 0,
        isSelfie: false,
        widthPx: 10.5,
      }).ok,
    ).toBe(false);
  });

  it("propagates slot validation errors", () => {
    expect(
      validateFinalizeBody({
        storagePath: "users/uid-1/photos/abc.jpg",
        position: 5,
        isSelfie: false,
      }).ok,
    ).toBe(false);
  });
});
