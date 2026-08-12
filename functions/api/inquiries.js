import {
  assertSameOrigin,
  cleanText,
  errorResponse,
  isHoneypotFilled,
  jsonResponse,
  readJson,
  requireBinding,
  validateEmail,
  validateTurnstile
} from "../../cloudflare/api-helpers.js";
import { validateColorSelection } from "../../cloudflare/color-options.js";

async function sendOptionalNotification(env, inquiry) {
  if (!env.EMAIL || !env.NOTIFICATION_EMAIL || !env.NOTIFICATION_FROM) return;
  const details = [
    "New Double Take Frames request",
    "",
    `Type: ${inquiry.type}`,
    `Starting point: ${inquiry.kit}`,
    `Color choice: ${inquiry.colorSummary || "No preference provided"}`,
    `Name: ${inquiry.name}`,
    `Email: ${inquiry.email}`,
    `Timeline: ${inquiry.timeline}`,
    "",
    "Message:",
    inquiry.message
  ].join("\n");
  try {
    await env.EMAIL.send({
      from: env.NOTIFICATION_FROM,
      to: env.NOTIFICATION_EMAIL,
      reply_to: inquiry.email,
      subject: `Double Take Frames: ${inquiry.type || "Website request"}`,
      text: details
    });
  } catch (error) {
    console.error("Inquiry saved, but notification failed", error);
  }
}

function isMissingColorColumns(error) {
  const message = String(error && error.message || "").toLowerCase();
  return message.includes("no column named color_mode") ||
    message.includes("has no column named color_mode") ||
    message.includes("color_mode");
}

function messageWithColorFallback(inquiry) {
  if (!inquiry.colorSummary) return inquiry.message;
  return `Color choice: ${inquiry.colorSummary}\n\n${inquiry.message}`;
}

export async function onRequestPost(context) {
  try {
    assertSameOrigin(context.request);
    const data = await readJson(context.request);
    if (isHoneypotFilled(data.website)) {
      return jsonResponse({ ok: true, message: "Request received." }, 201);
    }
    await validateTurnstile(context.request, context.env, data.turnstileToken);

    const color = validateColorSelection(data, { allowCustom: true });
    const inquiry = {
      id: crypto.randomUUID(),
      createdAt: new Date().toISOString(),
      type: cleanText(data.type, 80, "Request type"),
      kit: cleanText(data.kit, 80, "Starting point"),
      name: cleanText(data.name, 120, "Name", true),
      email: validateEmail(data.email, true),
      timeline: cleanText(data.timeline, 200, "Timeline"),
      message: cleanText(data.message, 5000, "Message", true),
      ...color
    };

    const db = requireBinding(context.env, "SITE_DB");
    try {
      await db.prepare(`
        INSERT INTO inquiries
          (id, created_at, type, kit, name, email, timeline, message,
           color_mode, pairing_id, cassette_color_id, stand_color_id, custom_color_notes, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'new')
      `).bind(
        inquiry.id,
        inquiry.createdAt,
        inquiry.type,
        inquiry.kit,
        inquiry.name,
        inquiry.email,
        inquiry.timeline,
        inquiry.message,
        inquiry.colorMode,
        inquiry.pairingId,
        inquiry.cassetteColorId,
        inquiry.standColorId,
        inquiry.customColorNotes
      ).run();
    } catch (error) {
      if (!isMissingColorColumns(error)) throw error;
      await db.prepare(`
        INSERT INTO inquiries
          (id, created_at, type, kit, name, email, timeline, message, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'new')
      `).bind(
        inquiry.id,
        inquiry.createdAt,
        inquiry.type,
        inquiry.kit,
        inquiry.name,
        inquiry.email,
        inquiry.timeline,
        messageWithColorFallback(inquiry)
      ).run();
    }

    context.waitUntil(sendOptionalNotification(context.env, inquiry));
    return jsonResponse({ ok: true, message: "Request sent. I will follow up directly." }, 201);
  } catch (error) {
    return errorResponse(error);
  }
}
