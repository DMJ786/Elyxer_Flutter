/**
 * Extracts the first JSON object/array from a string.
 *
 * Handles the two common Claude quirks even when the system prompt
 * demands pure JSON:
 *   - fenced ```json blocks (or plain ``` fences)
 *   - leading commentary before the object opens
 *
 * Kept in its own module so unit tests don't need to load the Vertex
 * SDK.
 */

export function extractJsonBlock(text: string): string {
  const fence = text.match(/```(?:json)?\s*([\s\S]*?)```/);
  if (fence) return fence[1].trim();

  const start = text.search(/[{[]/);
  if (start < 0) return text.trim();
  const opener = text[start];
  const closer = opener === "{" ? "}" : "]";
  let depth = 0;
  for (let i = start; i < text.length; i++) {
    if (text[i] === opener) depth++;
    else if (text[i] === closer) {
      depth--;
      if (depth === 0) return text.slice(start, i + 1);
    }
  }
  return text.slice(start).trim();
}
