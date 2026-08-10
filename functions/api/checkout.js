import {
  HttpError,
  assertSameOrigin,
  cleanText,
  errorResponse,
  jsonResponse,
  readJson,
  requireBinding
} from "../../cloudflare/api-helpers.js";

const OFFERINGS = {
  maker: "STRIPE_PRICE_MAKER",
  builder: "STRIPE_PRICE_BUILDER",
  gift: "STRIPE_PRICE_GIFT"
};

function checkoutMode(env) {
  const mode = String(env && env.STRIPE_CHECKOUT_MODE || "off").trim().toLowerCase();
  if (!["off", "test", "live"].includes(mode)) {
    throw new HttpError(503, "Checkout is not configured correctly.");
  }
  return mode;
}

function requireModeKey(env, mode) {
  const key = requireBinding(env, "STRIPE_SECRET_KEY");
  const expectedPrefix = mode === "live" ? "sk_live_" : "sk_test_";
  if (!String(key).startsWith(expectedPrefix)) {
    throw new HttpError(503, "Checkout mode and Stripe credentials do not match.");
  }
  return key;
}

function requirePrice(env, bindingName) {
  const price = requireBinding(env, bindingName);
  if (!String(price).startsWith("price_")) {
    throw new HttpError(503, "A Stripe price is not configured correctly.");
  }
  return String(price);
}

export async function onRequestPost(context) {
  try {
    const { request, env } = context;
    assertSameOrigin(request);
    const mode = checkoutMode(env);
    if (mode === "off") throw new HttpError(503, "Checkout is not available yet.");

    const body = await readJson(request, 2_000);
    const offeringId = cleanText(body.offeringId, 32, "Offering", true);
    const imageOptionId = cleanText(body.imageOptionId, 32, "Image option");
    const priceBinding = OFFERINGS[offeringId];
    if (!priceBinding) throw new HttpError(400, "Choose a valid offering.");
    if (!["", "self-print", "print-cut"].includes(imageOptionId)) {
      throw new HttpError(400, "Choose a valid image option.");
    }
    if (offeringId === "gift" && imageOptionId && imageOptionId !== "self-print") {
      throw new HttpError(400, "That image option does not apply to this offering.");
    }

    const stripeKey = requireModeKey(env, mode);
    const origin = new URL(request.url).origin;
    const form = new URLSearchParams();
    form.set("mode", "payment");
    form.set("line_items[0][price]", requirePrice(env, priceBinding));
    form.set("line_items[0][quantity]", "1");
    let lineItemIndex = 1;
    if (imageOptionId === "print-cut") {
      form.set(`line_items[${lineItemIndex}][price]`, requirePrice(env, "STRIPE_PRICE_IMAGE_PREP"));
      form.set(`line_items[${lineItemIndex}][quantity]`, "1");
      lineItemIndex += 1;
    }
    form.set("success_url", `${origin}/checkout/success/?session_id={CHECKOUT_SESSION_ID}`);
    form.set("cancel_url", `${origin}/kits/?tier=${encodeURIComponent(offeringId)}`);
    form.set("shipping_address_collection[allowed_countries][0]", "US");
    form.set("metadata[offering_id]", offeringId);
    form.set("metadata[image_option_id]", imageOptionId || "included");
    form.set("client_reference_id", crypto.randomUUID());
    if (String(env.STRIPE_AUTOMATIC_TAX || "").toLowerCase() === "true") {
      form.set("automatic_tax[enabled]", "true");
    }

    const response = await fetch("https://api.stripe.com/v1/checkout/sessions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${stripeKey}`,
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: form.toString()
    });
    const result = await response.json();
    if (!response.ok) {
      console.error("Stripe Checkout Session creation failed", response.status, result && result.error && result.error.type);
      throw new HttpError(502, "Stripe checkout could not be started. Please try again.");
    }
    if (!result || typeof result.url !== "string" || !result.url.startsWith("https://checkout.stripe.com/")) {
      throw new HttpError(502, "Stripe returned an invalid checkout link.");
    }
    return jsonResponse({ ok: true, url: result.url });
  } catch (error) {
    return errorResponse(error);
  }
}
