/**
 * Local Profile Studio smoke test — runs the real prompt through Claude on
 * Amazon Bedrock and prints the structured profile. Bypasses HTTP / Firebase
 * auth / Postgres so you can verify generation works against your AWS account,
 * no BFF deploy required.
 *
 * Setup (one-time): put these in functions/.env (git-ignored, never commit):
 *   BEDROCK_MODEL=...        # exact Claude Haiku 4.5 model / ap-south-1
 *                            # cross-region inference-profile id (Bedrock console)
 *   AWS_REGION=ap-south-1    # optional; defaults to ap-south-1
 *
 * AWS credentials come from the standard chain — `aws configure`, SSO, or
 * AWS_* env vars. The Bedrock model must be enabled for your account/region.
 *
 * Run:
 *   cd functions
 *   npm run try:profile-studio -- "weekends on trails, chai in hand" natural
 *
 * Args: [inspirationText] [tone]   (tone = natural | elegant, default natural)
 */

require("dotenv").config();

const { generateJson } = require("../lib/ai/bedrock.js");
const {
  buildSystemPrompt,
  buildUserMessage,
  clampToLimits,
  isProfileStudioGenerated,
} = require("../lib/profile_studio/prompt.js");

const inspiration =
  process.argv[2] ||
  "weekends on trails, chai in hand, and long design debates with friends";
const tone = process.argv[3] || "natural";

(async () => {
  if (!process.env.BEDROCK_MODEL) {
    console.error(
      "Set BEDROCK_MODEL (and AWS credentials via `aws configure`/SSO) in " +
        "functions/.env first — see the header of this file.",
    );
    process.exit(1);
  }

  console.error(`Generating on Bedrock (tone=${tone})…\n`);
  const startedAt = Date.now();

  const generated = await generateJson({
    system: buildSystemPrompt(tone),
    user: buildUserMessage(inspiration),
    validate: isProfileStudioGenerated,
  });

  const clamped = clampToLimits(generated);
  console.log(JSON.stringify(clamped, null, 2));
  console.error(`\nDone in ${Date.now() - startedAt}ms.`);
})().catch((err) => {
  console.error("\nGeneration failed:", err?.message || err);
  process.exit(1);
});
