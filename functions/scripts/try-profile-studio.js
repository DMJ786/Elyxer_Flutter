/**
 * Local Profile Studio smoke test — runs the real prompt through Claude and
 * prints the structured profile. Bypasses HTTP / Firebase auth / Postgres so
 * you can verify generation works with your own key, no GCP required.
 *
 * Setup (one-time): put these in functions/.env (never commit it):
 *   LLM_PROVIDER=anthropic
 *   ANTHROPIC_API_KEY=sk-ant-...        # from console.anthropic.com
 *
 * Run:
 *   cd functions
 *   npm run build
 *   node scripts/try-profile-studio.js "weekends on trails, chai in hand" natural
 *
 * Args: [inspirationText] [tone]   (tone = natural | elegant, default natural)
 */

require("dotenv").config();

const { generateJson } = require("../lib/ai/vertex.js");
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
  if ((process.env.LLM_PROVIDER || "").toLowerCase() !== "anthropic") {
    console.error(
      "Set LLM_PROVIDER=anthropic (and ANTHROPIC_API_KEY) in functions/.env first.",
    );
    process.exit(1);
  }

  console.error(`Generating (tone=${tone})…\n`);
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
