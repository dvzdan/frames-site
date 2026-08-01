const JSON_HEADERS = {
  "Content-Type": "application/json; charset=utf-8",
  "Cache-Control": "no-store",
  "X-Content-Type-Options": "nosniff"
};

export class HttpError extends Error {
  constructor(status, message) {
    super(message);
    this.name = "HttpError";
    this.status = status;
  }
}

export function jsonResponse(data, status = 200, headers = {}) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...JSON_HEADERS, ...headers }
  });
}

export function errorResponse(error) {
  if (error instanceof HttpError) {
    return jsonResponse({ ok: false, error: error.message }, error.status);
  }
  console.error("Unhandled API error", error);
  return jsonResponse({ ok: false, error: "The request could not be completed." }, 500);
}

export function requireBinding(env, name) {
  if (!env || !env[name]) {
    throw new HttpError(503, "This form is still being connected. Please try again later.");
  }
  return env[name];
}

export function cleanText(value, maxLength, label, required = false) {
  const text = String(value == null ? "" : value).trim();
  if (required && !text) throw new HttpError(400, `${label} is required.`);
  if (text.length > maxLength) throw new HttpError(400, `${label} is too long.`);
  return text;
}

export function validateEmail(value, required = false) {
  const email = cleanText(value, 254, "Email", required).toLowerCase();
  if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    throw new HttpError(400, "Enter a valid email address.");
  }
  return email;
}

export function assertSameOrigin(request) {
  const origin = request.headers.get("Origin");
  if (origin && new URL(origin).origin !== new URL(request.url).origin) {
    throw new HttpError(403, "Cross-site form submissions are not allowed.");
  }
}

export async function readJson(request, maxCharacters = 32_000) {
  const body = await request.text();
  if (body.length > maxCharacters) throw new HttpError(413, "Request is too large.");
  try {
    return JSON.parse(body || "{}");
  } catch {
    throw new HttpError(400, "Request body must be valid JSON.");
  }
}

export async function validateTurnstile(request, env, token) {
  const secretName = env?.TURNSTILE_SECRET_KEY_LIVE
    ? "TURNSTILE_SECRET_KEY_LIVE"
    : "TURNSTILE_SECRET_KEY";
  const secret = requireBinding(env, secretName);
  const responseToken = cleanText(token, 2048, "Verification", true);
  const response = await fetch("https://challenges.cloudflare.com/turnstile/v0/siteverify", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      secret,
      response: responseToken,
      remoteip: request.headers.get("CF-Connecting-IP") || undefined,
      idempotency_key: crypto.randomUUID()
    })
  });
  if (!response.ok) throw new HttpError(503, "Verification is temporarily unavailable.");
  const result = await response.json();
  if (!result.success) throw new HttpError(400, "Verification failed. Please try again.");
  return result;
}

export function validateImage(file, label) {
  if (!file || typeof file.arrayBuffer !== "function") {
    throw new HttpError(400, `${label} image is required.`);
  }
  const allowed = {
    "image/jpeg": "jpg",
    "image/png": "png"
  };
  const extension = allowed[String(file.type || "").toLowerCase()];
  if (!extension) throw new HttpError(400, `${label} must be a PNG or JPEG image.`);
  if (!file.size || file.size > 8 * 1024 * 1024) {
    throw new HttpError(413, `${label} must be smaller than 8 MB.`);
  }
  return extension;
}

export function isHoneypotFilled(value) {
  return Boolean(String(value == null ? "" : value).trim());
}
