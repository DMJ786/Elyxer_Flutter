/**
 * Firebase ID-token verification helper.
 *
 * Every authenticated endpoint expects a bearer token in the
 * Authorization header. This helper returns the decoded token or
 * throws a typed HttpError so callers can respond with the right
 * status.
 */

import { getAuth, type DecodedIdToken } from "firebase-admin/auth";
import type { Request } from "firebase-functions/v2/https";

export class AuthError extends Error {
  constructor(
    public readonly status: 401 | 403,
    message: string,
  ) {
    super(message);
    this.name = "AuthError";
  }
}

export async function verifyIdToken(req: Request): Promise<DecodedIdToken> {
  const header = req.header("authorization") ?? req.header("Authorization");
  if (!header) {
    throw new AuthError(401, "Missing Authorization header.");
  }

  const [scheme, token] = header.split(" ", 2);
  if (scheme?.toLowerCase() !== "bearer" || !token) {
    throw new AuthError(401, "Expected Authorization: Bearer <id-token>.");
  }

  try {
    return await getAuth().verifyIdToken(token);
  } catch {
    throw new AuthError(401, "Invalid or expired ID token.");
  }
}
