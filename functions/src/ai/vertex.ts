/**
 * Vertex-hosted Anthropic Claude client.
 *
 * Uses `@anthropic-ai/vertex-sdk` so the same prompt / message API works
 * across Anthropic direct, Bedrock, and Vertex. On Cloud Functions the
 * runtime automatically provides GCP application-default credentials,
 * so no API key is stored anywhere in code or config.
 *
 * The client is lazily instantiated on first use and reused across
 * warm-instance invocations — creating it is cheap but there's no
 * reason to redo the work.
 */

import { AnthropicVertex } from "@anthropic-ai/vertex-sdk";
import { extractJsonBlock } from "./extract_json";

let client: AnthropicVertex | undefined;

function getClient(): AnthropicVertex {
  if (client) return client;

  const projectId = process.env.GCLOUD_PROJECT;
  const region = process.env.VERTEX_REGION || "asia-south1";
  if (!projectId) {
    throw new Error(
      "GCLOUD_PROJECT is not set. On Cloud Functions this is provided " +
        "automatically; for local dev set it in functions/.env.",
    );
  }

  client = new AnthropicVertex({ projectId, region });
  return client;
}

export type GenerateJsonParams<T> = {
  /** Model ID, e.g. "claude-haiku-4-5". Defaults to CLAUDE_MODEL env. */
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
 * Call Claude with a structured-JSON contract and return a typed result.
 *
 * Throws:
 *   - `LlmValidationError` if the model returned malformed JSON or the
 *     validator rejected the shape.
 *   - Propagates the underlying SDK error otherwise (network, auth,
 *     rate limit) — caller catches to map to HTTP status.
 */
export async function generateJson<T>(params: GenerateJsonParams<T>): Promise<T> {
  const model =
    params.model ?? process.env.CLAUDE_MODEL ?? "claude-haiku-4-5";
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
