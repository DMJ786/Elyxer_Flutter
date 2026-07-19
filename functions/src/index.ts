/**
 * Elyxer Cloud Functions BFF — entry point.
 *
 * Functions are organized by feature area:
 *   - auth/      Phone OTP fallback, email OTP, username submit, email prefs
 *   - onboarding/ Onboarding submit + validation
 *   - photos/    Upload presigned URLs, NSFW moderation, face match
 *
 * Each subfolder exports its callables here so the deploy bundle has a
 * single entry point. Bundle 0 (this PR) ships an empty index — feature
 * functions are added in PRs #2, #3, #4.
 */

// Load .env for local dev before anything reads process.env. In
// production Cloud Functions, env vars come from Firebase config /
// Secret Manager and dotenv is a no-op.
import "dotenv/config";

import { initializeApp } from "firebase-admin/app";

// Initialize the Admin SDK once for the whole function bundle.
// Subsequent imports will reuse the default app.
initializeApp();

// === Bundle 1 (Verification flow) ===
// submitUsername is the first DB-backed endpoint — it proves the
// Kysely + Postgres pipeline is wired end-to-end. The remaining
// verification-flow endpoints land in follow-up PRs.
export { submitUsername } from "./auth/submitUsername";
// export { sendEmailOTP } from "./auth/sendEmailOTP";
// export { verifyEmailOTP } from "./auth/verifyEmailOTP";
// export { updateEmailPrefs } from "./auth/updateEmailPrefs";
// export { sendPhoneOTPMSG91 } from "./auth/sendPhoneOTPMSG91";

// === Bundle 2 (Onboarding + location) ===
// submitOnboarding persists Module 1 + 2 selections to onboarding_profiles.
export { submitOnboarding } from "./onboarding/submitOnboarding";

// === Bundle 3 (Photos pipeline) — added in PR #4 ===
// export { requestUploadUrl } from "./photos/requestUploadUrl";
// export { finalizeUpload } from "./photos/finalizeUpload";
// export { verifySelfie } from "./photos/verifySelfie";

// === Bundle 4 (Profile Studio LLM) ===
// generateProfileStudio turns a few sentences of user inspiration into
// a full structured dating profile via Claude Haiku 4.5 on Vertex AI.
export { generateProfileStudio } from "./profile_studio/generate";

// Bundle 0 ships a single placeholder so the deploy isn't empty (Firebase
// rejects deploys with zero functions). Remove once PR #2 lands.
import { onRequest } from "firebase-functions/v2/https";

export const healthcheck = onRequest(
  { region: "asia-south1", invoker: "public" },
  (_req, res) => {
    res.json({ status: "ok", bundle: "0-foundation" });
  },
);
