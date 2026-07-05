/**
 * POST /auth/username
 *
 * First real DB-backed endpoint — proof that the Kysely + Postgres
 * pipeline is wired end-to-end. Verifies the caller's Firebase ID
 * token, upserts a row in `users` keyed on `firebase_uid`, and returns
 * the persisted user.
 *
 * Later PRs replace the rest of `lib/services/verification_service.dart`
 * one endpoint at a time using this file as the template.
 */

import { onRequest } from "firebase-functions/v2/https";
import { getDb } from "../db/kysely";
import { AuthError, verifyIdToken } from "./verifyIdToken";

type SubmitUsernameBody = {
  username?: unknown;
  firstName?: unknown;
  lastName?: unknown;
};

const USERNAME_REGEX = /^[a-zA-Z0-9_.]{3,24}$/;

export const submitUsername = onRequest(
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

    const body = (req.body ?? {}) as SubmitUsernameBody;
    const username = typeof body.username === "string" ? body.username.trim() : "";
    const firstName =
      typeof body.firstName === "string" ? body.firstName.trim() : null;
    const lastName =
      typeof body.lastName === "string" ? body.lastName.trim() : null;

    if (!USERNAME_REGEX.test(username)) {
      res.status(400).json({
        error:
          "Username must be 3-24 chars, letters/numbers/underscore/dot only.",
      });
      return;
    }

    const db = getDb();

    // Reject if the username is taken by a *different* firebase_uid.
    // Same uid re-submitting the same username is fine (idempotent).
    const conflict = await db
      .selectFrom("users")
      .select(["firebase_uid"])
      .where("username", "=", username)
      .where("firebase_uid", "!=", uid)
      .executeTakeFirst();

    if (conflict) {
      res.status(409).json({ error: "Username is taken." });
      return;
    }

    const user = await db
      .insertInto("users")
      .values({
        firebase_uid: uid,
        username,
        first_name: firstName,
        last_name: lastName,
      })
      .onConflict((oc) =>
        oc.column("firebase_uid").doUpdateSet({
          username,
          first_name: firstName,
          last_name: lastName,
        }),
      )
      .returning([
        "id",
        "firebase_uid",
        "username",
        "first_name",
        "last_name",
        "created_at",
        "updated_at",
      ])
      .executeTakeFirstOrThrow();

    res.status(200).json({ user });
  },
);
