import {
  HttpError,
  assertSameOrigin,
  cleanText,
  errorResponse,
  jsonResponse,
  requireBinding,
  validateImage
} from "../../cloudflare/api-helpers.js";

function validateSessionId(value) {
  const sessionId = cleanText(value, 255, "Checkout session", true);
  if (!/^cs_(test|live)_[A-Za-z0-9]+$/.test(sessionId)) {
    throw new HttpError(400, "Checkout session is invalid.");
  }
  return sessionId;
}

function requireStripeKey(env, sessionId) {
  const key = String(requireBinding(env, "STRIPE_SECRET_KEY"));
  const expected = sessionId.startsWith("cs_live_") ? "sk_live_" : "sk_test_";
  if (!key.startsWith(expected)) throw new HttpError(503, "Checkout mode is not configured correctly.");
  return key;
}

async function getPaidPrintCutSession(env, sessionId) {
  const response = await fetch(`https://api.stripe.com/v1/checkout/sessions/${encodeURIComponent(sessionId)}`, {
    headers: { Authorization: `Bearer ${requireStripeKey(env, sessionId)}` }
  });
  const session = await response.json();
  if (!response.ok || !session || session.id !== sessionId) {
    throw new HttpError(404, "Checkout session could not be verified.");
  }
  if (session.status !== "complete" || session.payment_status === "unpaid") {
    throw new HttpError(403, "Complete payment before uploading order images.");
  }
  if (!session.metadata || session.metadata.image_option_id !== "print-cut") {
    throw new HttpError(400, "This order does not include image preparation.");
  }
  return session;
}

async function imageUploadStatus(store, sessionId) {
  const listed = await store.list({ prefix: `orders/${sessionId}/` });
  const keys = (listed && listed.objects || []).map(function(object) { return object.key; });
  return {
    cover: keys.some(function(key) { return /\/cover\.(png|jpg)$/.test(key); }),
    reveal: keys.some(function(key) { return /\/reveal\.(png|jpg)$/.test(key); })
  };
}

export async function onRequestGet(context) {
  try {
    const sessionId = validateSessionId(new URL(context.request.url).searchParams.get("session_id"));
    const session = await getPaidPrintCutSession(context.env, sessionId);
    const store = requireBinding(context.env, "SUBMISSIONS");
    const uploaded = await imageUploadStatus(store, sessionId);
    return jsonResponse({
      ok: true,
      requiresImages: true,
      uploaded: uploaded.cover && uploaded.reveal,
      customerEmail: cleanText(session.customer_details && session.customer_details.email || session.customer_email, 254, "Email")
    });
  } catch (error) {
    return errorResponse(error);
  }
}

export async function onRequestPost(context) {
  const uploadedKeys = [];
  try {
    assertSameOrigin(context.request);
    const form = await context.request.formData();
    const sessionId = validateSessionId(form.get("sessionId"));
    const session = await getPaidPrintCutSession(context.env, sessionId);
    const cover = form.get("cover");
    const reveal = form.get("reveal");
    const coverExtension = validateImage(cover, "Cover");
    const revealExtension = validateImage(reveal, "Reveal");
    const store = requireBinding(context.env, "SUBMISSIONS");
    const uploadedAt = new Date().toISOString();
    const customerEmail = cleanText(session.customer_details && session.customer_details.email || session.customer_email, 254, "Email");
    const files = [
      { file: cover, kind: "cover", extension: coverExtension },
      { file: reveal, kind: "reveal", extension: revealExtension }
    ];

    for (const item of files) {
      const key = `orders/${sessionId}/${item.kind}.${item.extension}`;
      await store.put(key, await item.file.arrayBuffer(), {
        httpMetadata: { contentType: item.file.type },
        customMetadata: { sessionId, kind: item.kind, customerEmail, uploadedAt }
      });
      uploadedKeys.push(key);
    }

    const previous = await store.list({ prefix: `orders/${sessionId}/` });
    const staleKeys = (previous && previous.objects || [])
      .map(function(object) { return object.key; })
      .filter(function(key) { return !uploadedKeys.includes(key); });
    if (staleKeys.length) await Promise.all(staleKeys.map(function(key) { return store.delete(key); }));

    return jsonResponse({ ok: true, message: "Your Cover and Reveal images are attached to the order." }, 201);
  } catch (error) {
    if (uploadedKeys.length && context.env.SUBMISSIONS) {
      try {
        await Promise.all(uploadedKeys.map(function(key) { return context.env.SUBMISSIONS.delete(key); }));
      } catch (cleanupError) {
        console.error("Could not clean up incomplete order image upload", cleanupError);
      }
    }
    return errorResponse(error);
  }
}
