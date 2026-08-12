import { HttpError, errorResponse, jsonResponse, requireBinding } from "../../../cloudflare/api-helpers.js";

function parseStripeSignature(header) {
  const values = { timestamp: "", signatures: [] };
  String(header || "").split(",").forEach(function(part) {
    const separator = part.indexOf("=");
    if (separator < 0) return;
    const key = part.slice(0, separator).trim();
    const value = part.slice(separator + 1).trim();
    if (key === "t") values.timestamp = value;
    if (key === "v1") values.signatures.push(value);
  });
  return values;
}

function toHex(buffer) {
  return Array.from(new Uint8Array(buffer), function(byte) {
    return byte.toString(16).padStart(2, "0");
  }).join("");
}

function constantTimeEqual(left, right) {
  if (left.length !== right.length) return false;
  let difference = 0;
  for (let index = 0; index < left.length; index += 1) {
    difference |= left.charCodeAt(index) ^ right.charCodeAt(index);
  }
  return difference === 0;
}

async function verifyStripeSignature(payload, header, secret, nowSeconds = Math.floor(Date.now() / 1000)) {
  const parsed = parseStripeSignature(header);
  const timestamp = Number(parsed.timestamp);
  if (!Number.isFinite(timestamp) || !parsed.signatures.length) {
    throw new HttpError(400, "Stripe signature is missing or invalid.");
  }
  if (Math.abs(nowSeconds - timestamp) > 300) {
    throw new HttpError(400, "Stripe signature has expired.");
  }
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );
  const digest = await crypto.subtle.sign(
    "HMAC",
    key,
    new TextEncoder().encode(`${parsed.timestamp}.${payload}`)
  );
  const expected = toHex(digest);
  if (!parsed.signatures.some(function(signature) { return constantTimeEqual(signature, expected); })) {
    throw new HttpError(400, "Stripe signature is invalid.");
  }
}

function text(value, maxLength = 500) {
  return String(value == null ? "" : value).trim().slice(0, maxLength);
}

async function saveCompletedOrder(env, event) {
  const session = event && event.data && event.data.object;
  if (!session || !session.id) throw new HttpError(400, "Stripe event does not contain a Checkout Session.");
  const metadata = session.metadata || {};
  const now = new Date().toISOString();
  const db = requireBinding(env, "SITE_DB");
  await db.prepare(`
    INSERT INTO orders
      (stripe_session_id, stripe_event_id, created_at, updated_at, payment_status,
       amount_total, currency, customer_email, offering_id, image_option_id,
       color_mode, pairing_id, cassette_color_id, stand_color_id, color_summary,
       fulfillment_status)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'new')
    ON CONFLICT(stripe_session_id) DO UPDATE SET
      stripe_event_id = excluded.stripe_event_id,
      updated_at = excluded.updated_at,
      payment_status = excluded.payment_status,
      amount_total = excluded.amount_total,
      currency = excluded.currency,
      customer_email = excluded.customer_email,
      offering_id = excluded.offering_id,
      image_option_id = excluded.image_option_id,
      color_mode = excluded.color_mode,
      pairing_id = excluded.pairing_id,
      cassette_color_id = excluded.cassette_color_id,
      stand_color_id = excluded.stand_color_id,
      color_summary = excluded.color_summary
  `).bind(
    text(session.id, 255),
    text(event.id, 255),
    now,
    now,
    text(session.payment_status, 40),
    Number.isFinite(session.amount_total) ? session.amount_total : null,
    text(session.currency, 12),
    text(session.customer_details && session.customer_details.email || session.customer_email, 254).toLowerCase(),
    text(metadata.offering_id, 32),
    text(metadata.image_option_id, 32),
    text(metadata.color_mode, 24),
    text(metadata.pairing_id, 24),
    text(metadata.cassette_color_id, 24),
    text(metadata.stand_color_id, 24),
    text(metadata.color_summary, 500)
  ).run();
}

export async function onRequestPost(context) {
  try {
    const payload = await context.request.text();
    const secret = requireBinding(context.env, "STRIPE_WEBHOOK_SECRET");
    await verifyStripeSignature(payload, context.request.headers.get("Stripe-Signature"), String(secret));
    let event;
    try {
      event = JSON.parse(payload);
    } catch {
      throw new HttpError(400, "Stripe event must be valid JSON.");
    }
    const session = event && event.data && event.data.object;
    if (
      ["checkout.session.completed", "checkout.session.async_payment_succeeded"].includes(event.type) &&
      session && session.payment_status !== "unpaid"
    ) {
      await saveCompletedOrder(context.env, event);
    }
    return jsonResponse({ received: true });
  } catch (error) {
    return errorResponse(error);
  }
}

export const __test = { verifyStripeSignature };
