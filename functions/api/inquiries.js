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

async function sendOptionalNotification(env, inquiry) {
  if (!env.EMAIL || !env.NOTIFICATION_EMAIL || !env.NOTIFICATION_FROM) return;
  const details = [
    "New Double Take Frames request",
    "",
    `Type: ${inquiry.type}`,
    `Kit path: ${inquiry.kit}`,
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

export async function onRequestPost(context) {
  try {
    assertSameOrigin(context.request);
    const data = await readJson(context.request);
    if (isHoneypotFilled(data.website)) {
      return jsonResponse({ ok: true, message: "Request received." }, 201);
    }
    await validateTurnstile(context.request, context.env, data.turnstileToken);

    const inquiry = {
      id: crypto.randomUUID(),
      createdAt: new Date().toISOString(),
      type: cleanText(data.type, 80, "Request type"),
      kit: cleanText(data.kit, 80, "Kit path"),
      name: cleanText(data.name, 120, "Name", true),
      email: validateEmail(data.email, true),
      timeline: cleanText(data.timeline, 200, "Timeline"),
      message: cleanText(data.message, 5000, "Message", true)
    };

    const db = requireBinding(context.env, "SITE_DB");
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
      inquiry.message
    ).run();

    context.waitUntil(sendOptionalNotification(context.env, inquiry));
    return jsonResponse({ ok: true, message: "Request sent. I will follow up directly." }, 201);
  } catch (error) {
    return errorResponse(error);
  }
}
