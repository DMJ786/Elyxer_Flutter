/**
 * Amazon Bedrock Claude client.
 *
 * Uses `@anthropic-ai/bedrock-sdk`, which exposes the same Messages API as the
 * direct Anthropic SDK, so the prompt / call path is unchanged. Credentials
 * come from the standard AWS provider chain — an IAM role on the BFF compute
 * (Lambda / App Runner) in production, or `aws configure` / SSO / `AWS_*` env
 * vars locally — so no key is ever stored in code or committed config.
 *
 * Region defaults to ap-south-1 (Mumbai) for India DPDP data residency: keep
 * Bedrock traffic in-region. The model is a Bedrock model id or, for
 * ap-south-1, a Mumbai cross-region inference-profile id, supplied via
 * `BEDROCK_MODEL` (see resolveModel).
 *
 * The client is lazily instantiated on first use and reused across
 * warm-instance invocations — creating it is cheap but there's no reason to
 * redo the work.
 */

import { AnthropicBedrock } from "@anthropic-ai/bedrock-sdk";
import { extractJsonBlock } from "./extract_json";

let client: AnthropicBedrock | undefined;

function getClient(): AnthropicBedrock {
  if (client) return client;

  // Region drives DPDP residency — keep the model's traffic in-region. The
  // standard AWS env name takes precedence so an IAM role or `aws configure`d
  // profile works with no extra config.
  const awsRegion =
    process.env.AWS_REGION || process.env.BEDROCK_REGION || "ap-south-1";

  client = new AnthropicBedrock({ awsRegion });
  return client;
}

/**
 * Resolves the Bedrock model id.
 *
 * Bedrock uses its own model-id namespace (not the plain `claude-haiku-4-5`
 * used by the direct API), so there is no safe default: an inference profile
 * that routes outside India would silently move user profile text across
 * borders (DPDP). `BEDROCK_MODEL` is therefore required and must be copied
 * verbatim from the Bedrock console for the ap-south-1 region.
 */
function resolveModel(explicit: string | undefined): string {
  const model = explicit ?? process.env.BEDROCK_MODEL;
  if (!model) {
    throw new Error(
      "BEDROCK_MODEL is not set. Bedrock uses its own model-id namespace; set " +
        "it to the exact Claude Haiku 4.5 model or ap-south-1 cross-region " +
        "inference-profile id from the Bedrock console (keeping traffic in " +
        "Mumbai for DPDP residency).",
    );
  }
  return model;
}

export type GenerateJsonParams<T> = {
  /** Bedrock model / inference-profile id. Defaults to BEDROCK_MODEL env. */
  model?: string;
  /** System prompt — must instruct the model to return JSON. */
  system: string;
  /** User message content. */
  user: string;
  /**
   * Runtime type guard applied to the parsed JSON. If it returns false
   * the call is treated as a model output error (throws so the caller
   * can decide whether to retry or surface a user error).
   */
  validate: (raw: unknown) => raw is T;
  /** Max output tokens. Defaults to CLAUDE_MAX_OUTPUT_TOKENS env or 1024. */
  maxTokens?: number;
};

/**
 * Call Claude on Bedrock with a structured-JSON contract and return a typed
 * result.
 *
 * Throws:
 *   - `LlmValidationError` if the model returned malformed JSON or the
 *     validator rejected the shape.
 *   - Propagates the underlying SDK error otherwise (network, auth,
 *     rate limit) — caller catches to map to HTTP status.
 */
export async function generateJson<T>(params: GenerateJsonParams<T>): Promise<T> {
  const model = resolveModel(params.model);
  const maxTokens =
    params.maxTokens ??
    Number.parseInt(process.env.CLAUDE_MAX_OUTPUT_TOKENS ?? "1024", 10);

  const response = await getClient().messages.create({
    model,
    max_tokens: maxTokens,
    system: params.system,
    messages: [{ role: "user", content: params.user }],
  });

  // Claude may return multiple content blocks; we only care about text.
  const text = response.content
    .filter((c): c is Extract<typeof c, { type: "text" }> => c.type === "text")
    .map((c) => c.text)
    .join("");

  // Strip common wrappers the model likes to add even when instructed
  // to reply pure JSON (```json ... ``` fences, leading prose).
  const jsonSource = extractJsonBlock(text);

  let parsed: unknown;
  try {
    parsed = JSON.parse(jsonSource);
  } catch (e) {
    throw new LlmValidationError(
      "Model returned non-JSON output",
      text,
      e instanceof Error ? e : undefined,
    );
  }

  if (!params.validate(parsed)) {
    throw new LlmValidationError(
      "Model output failed schema validation",
      text,
    );
  }

  return parsed;
}

export class LlmValidationError extends Error {
  public readonly parseCause?: Error;

  constructor(message: string, public readonly rawOutput: string, cause?: Error) {
    super(message);
    this.name = "LlmValidationError";
    this.parseCause = cause;
  }
}
