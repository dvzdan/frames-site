import assert from "node:assert/strict";
import { onRequestPost as submitInquiry } from "../functions/api/inquiries.js";
import { onRequestPost as submitGallery } from "../functions/api/gallery/submit.js";
import { onRequestGet as getGalleryImage } from "../functions/api/gallery/image/[[path]].js";
import { onRequestPost as startCheckout } from "../functions/api/checkout.js";
import { onRequestGet as getOrderImages, onRequestPost as submitOrderImages } from "../functions/api/order-images.js";
import { onRequestPost as receiveStripeWebhook } from "../functions/api/stripe/webhook.js";

async function stripeSignature(payload, secret, timestamp) {
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );
  const digest = await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(`${timestamp}.${payload}`));
  const signature = Array.from(new Uint8Array(digest), (byte) => byte.toString(16).padStart(2, "0")).join("");
  return `t=${timestamp},v1=${signature}`;
}

function createDb() {
  const calls = [];
  return {
    calls,
    prepare(sql) {
      return {
        bind(...values) {
          return {
            async run() {
              calls.push({ sql, values });
              return { success: true };
            }
          };
        }
      };
    }
  };
}

function createLegacyInquiryDb() {
  const calls = [];
  return {
    calls,
    prepare(sql) {
      return {
        bind(...values) {
          return {
            async run() {
              if (sql.includes("color_mode")) throw new Error("table inquiries has no column named color_mode");
              calls.push({ sql, values });
              return { success: true };
            }
          };
        }
      };
    }
  };
}

function createSubmissionStore() {
  const objects = new Map();
  return {
    objects,
    async put(key, value, options) { objects.set(key, { value, options }); },
    async delete(key) { objects.delete(key); },
    async list({ prefix }) {
      return { objects: Array.from(objects.keys()).filter((key) => key.startsWith(prefix)).map((key) => ({ key })) };
    },
    async getWithMetadata(key) {
      const object = objects.get(key);
      return object ? { value: object.value, metadata: object.options.metadata } : null;
    }
  };
}

const originalFetch = globalThis.fetch;
const siteverifyRequests = [];
globalThis.fetch = async (_url, options) => {
  siteverifyRequests.push(JSON.parse(options.body));
  return Response.json({ success: true, hostname: "localhost" });
};

try {
  const inquiryDb = createDb();
  const inquiryRequest = new Request("https://example.test/api/inquiries", {
    method: "POST",
    headers: { "Content-Type": "application/json", Origin: "https://example.test" },
    body: JSON.stringify({
      type: "Order question",
      kit: "Ready-to-Assemble Kit",
      colorMode: "curated",
      pairingId: "rose",
      name: "Test Person",
      email: "test@example.com",
      timeline: "No deadline",
      message: "How should I prepare the cover image?",
      turnstileToken: "test-token"
    })
  });
  const inquiryResponse = await submitInquiry({
    request: inquiryRequest,
    env: {
      SITE_DB: inquiryDb,
      TURNSTILE_SECRET_KEY_LIVE: "live-secret"
    },
    waitUntil(promise) { void promise; }
  });
  assert.equal(inquiryResponse.status, 201);
  assert.equal(inquiryDb.calls.length, 1);
  assert.equal(inquiryDb.calls[0].values[5], "test@example.com");
  assert.equal(inquiryDb.calls[0].values[8], "curated");
  assert.equal(inquiryDb.calls[0].values[9], "rose");
  assert.equal(inquiryDb.calls[0].values[10], "blush");
  assert.equal(inquiryDb.calls[0].values[11], "oxblood");
  assert.equal(siteverifyRequests[0].secret, "live-secret");

  const legacyInquiryDb = createLegacyInquiryDb();
  const legacyInquiryResponse = await submitInquiry({
    request: new Request("https://example.test/api/inquiries", {
      method: "POST",
      headers: { "Content-Type": "application/json", Origin: "https://example.test" },
      body: JSON.stringify({
        type: "Order question",
        kit: "Finished Gift",
        colorMode: "mixed",
        cassetteColorId: "sage",
        standColorId: "oxblood",
        name: "Legacy Test",
        email: "legacy@example.com",
        timeline: "No deadline",
        message: "Please let me know availability.",
        turnstileToken: "test-token"
      })
    }),
    env: { SITE_DB: legacyInquiryDb, TURNSTILE_SECRET_KEY_LIVE: "live-secret" },
    waitUntil(promise) { void promise; }
  });
  assert.equal(legacyInquiryResponse.status, 201);
  assert.equal(legacyInquiryDb.calls.length, 1);
  assert.match(legacyInquiryDb.calls[0].values[7], /Muted Sage frame.*Oxblood stand/);

  const galleryDb = createDb();
  const submissions = createSubmissionStore();
  const form = new FormData();
  form.set("title", "Before");
  form.set("revealTitle", "After");
  form.set("description", "Test pair");
  form.set("email", "artist@example.com");
  form.set("consent", "yes");
  form.set("turnstileToken", "test-token");
  form.set("cover", new File([new Uint8Array([1, 2, 3])], "cover.png", { type: "image/png" }));
  form.set("reveal", new File([new Uint8Array([4, 5, 6])], "reveal.jpg", { type: "image/jpeg" }));
  const galleryRequest = new Request("https://example.test/api/gallery/submit", {
    method: "POST",
    headers: { Origin: "https://example.test" },
    body: form
  });
  const galleryResponse = await submitGallery({
    request: galleryRequest,
    env: { SITE_DB: galleryDb, SUBMISSIONS: submissions, TURNSTILE_SECRET_KEY_LIVE: "live-secret" }
  });
  assert.equal(galleryResponse.status, 201);
  assert.equal(galleryDb.calls.length, 1);
  assert.equal(submissions.objects.size, 2);
  assert.match(galleryDb.calls[0].values[6], /^pending\/.+\/cover\.png$/);
  assert.equal(siteverifyRequests[1].secret, "live-secret");

  const imageKey = galleryDb.calls[0].values[6];
  const imageDb = {
    prepare() {
      return {
        bind() {
          return {
            async first() { return { object_key: imageKey }; }
          };
        }
      };
    }
  };
  const imageResponse = await getGalleryImage({
    request: new Request("https://example.test/api/gallery/image/test/cover"),
    params: { path: ["test", "cover"] },
    env: { SITE_DB: imageDb, SUBMISSIONS: submissions }
  });
  assert.equal(imageResponse.status, 200);
  assert.equal(imageResponse.headers.get("Content-Type"), "image/png");

  const disabledCheckoutResponse = await startCheckout({
    request: new Request("https://example.test/api/checkout", {
      method: "POST",
      headers: { "Content-Type": "application/json", Origin: "https://example.test" },
      body: JSON.stringify({ offeringId: "maker", imageOptionId: "self-print" })
    }),
    env: { STRIPE_CHECKOUT_MODE: "off" }
  });
  assert.equal(disabledCheckoutResponse.status, 503);

  const masterDisabledCheckoutResponse = await startCheckout({
    request: new Request("https://example.test/api/checkout", {
      method: "POST",
      headers: { "Content-Type": "application/json", Origin: "https://example.test" },
      body: JSON.stringify({ offeringId: "maker", imageOptionId: "self-print" })
    }),
    env: {
      STRIPE_CHECKOUT_MODE: "live",
      STRIPE_SECRET_KEY: "sk_live_placeholder",
      STRIPE_PRICE_MAKER: "price_maker"
    }
  });
  assert.equal(masterDisabledCheckoutResponse.status, 503);

  let stripeRequest;
  globalThis.fetch = async (url, options) => {
    stripeRequest = { url, options, body: new URLSearchParams(options.body) };
    return Response.json({ url: "https://checkout.stripe.com/c/pay/test-session" });
  };
  const checkoutResponse = await startCheckout({
    request: new Request("https://example.test/api/checkout", {
      method: "POST",
      headers: { "Content-Type": "application/json", Origin: "https://example.test" },
      body: JSON.stringify({
        offeringId: "builder",
        imageOptionId: "print-cut",
        colorMode: "mixed",
        cassetteColorId: "sage",
        standColorId: "oxblood",
        amount: 1
      })
    }),
    env: {
      STRIPE_CHECKOUT_MODE: "test",
      STRIPE_SECRET_KEY: "sk_test_placeholder",
      STRIPE_PRICE_MAKER: "price_maker",
      STRIPE_PRICE_BUILDER: "price_builder",
      STRIPE_PRICE_GIFT: "price_gift",
      STRIPE_PRICE_IMAGE_PREP: "price_image_prep",
      STRIPE_SHIPPING_MAKER: "895",
      STRIPE_SHIPPING_BUILDER: "1095",
      STRIPE_SHIPPING_GIFT: "1095"
    }
  });
  assert.equal(checkoutResponse.status, 200);
  assert.equal(stripeRequest.url, "https://api.stripe.com/v1/checkout/sessions");
  assert.equal(stripeRequest.options.headers.Authorization, "Bearer sk_test_placeholder");
  assert.equal(stripeRequest.body.get("line_items[0][price]"), "price_builder");
  assert.equal(stripeRequest.body.get("line_items[1][price]"), "price_image_prep");
  assert.equal(stripeRequest.body.get("line_items[0][quantity]"), "1");
  assert.equal(stripeRequest.body.has("amount"), false);
  assert.equal(stripeRequest.body.get("shipping_options[0][shipping_rate_data][display_name]"), "USPS Ground Advantage");
  assert.equal(stripeRequest.body.get("shipping_options[0][shipping_rate_data][fixed_amount][amount]"), "1095");
  assert.equal(stripeRequest.body.get("shipping_options[0][shipping_rate_data][fixed_amount][currency]"), "usd");
  assert.equal(stripeRequest.body.get("metadata[color_mode]"), "mixed");
  assert.equal(stripeRequest.body.get("metadata[cassette_color_id]"), "sage");
  assert.equal(stripeRequest.body.get("metadata[stand_color_id]"), "oxblood");
  assert.match(stripeRequest.body.get("custom_text[submit][message]"), /Muted Sage frame.*Oxblood stand/);

  const giftCheckoutResponse = await startCheckout({
    request: new Request("https://example.test/api/checkout", {
      method: "POST",
      headers: { "Content-Type": "application/json", Origin: "https://example.test" },
      body: JSON.stringify({
        offeringId: "gift",
        imageOptionId: "",
        colorMode: "curated",
        pairingId: "original",
        countdownRequest: "Reveal after 10 days",
        startMode: "shipping"
      })
    }),
    env: {
      STRIPE_CHECKOUT_MODE: "test",
      STRIPE_SECRET_KEY: "sk_test_placeholder",
      STRIPE_PRICE_GIFT: "price_gift",
      STRIPE_SHIPPING_GIFT: "1095"
    }
  });
  assert.equal(giftCheckoutResponse.status, 200);
  assert.equal(stripeRequest.body.get("metadata[countdown_request]"), "Reveal after 10 days");
  assert.equal(stripeRequest.body.get("metadata[start_mode]"), "shipping");
  assert.match(stripeRequest.body.get("custom_text[submit][message]"), /Start when shipped/);

  const orderImageStore = createSubmissionStore();
  globalThis.fetch = async (url, options) => {
    assert.equal(url, "https://api.stripe.com/v1/checkout/sessions/cs_test_imageorder");
    assert.equal(options.headers.Authorization, "Bearer sk_test_placeholder");
    return Response.json({
      id: "cs_test_imageorder",
      status: "complete",
      payment_status: "paid",
      customer_details: { email: "buyer@example.com" },
      metadata: { image_option_id: "print-cut" }
    });
  };
  const orderImageForm = new FormData();
  orderImageForm.set("sessionId", "cs_test_imageorder");
  orderImageForm.set("cover", new File([new Uint8Array([1, 2, 3])], "cover.png", { type: "image/png" }));
  orderImageForm.set("reveal", new File([new Uint8Array([4, 5, 6])], "reveal.jpg", { type: "image/jpeg" }));
  const orderImageResponse = await submitOrderImages({
    request: new Request("https://example.test/api/order-images", {
      method: "POST",
      headers: { Origin: "https://example.test" },
      body: orderImageForm
    }),
    env: { STRIPE_SECRET_KEY: "sk_test_placeholder", SUBMISSIONS: orderImageStore }
  });
  assert.equal(orderImageResponse.status, 201);
  assert.equal(orderImageStore.objects.size, 2);
  assert.ok(orderImageStore.objects.has("orders/cs_test_imageorder/cover.png"));
  assert.ok(orderImageStore.objects.has("orders/cs_test_imageorder/reveal.jpg"));
  assert.equal(orderImageStore.objects.get("orders/cs_test_imageorder/cover.png").options.customMetadata.kind, "cover");

  const orderImageStatusResponse = await getOrderImages({
    request: new Request("https://example.test/api/order-images?session_id=cs_test_imageorder"),
    env: { STRIPE_SECRET_KEY: "sk_test_placeholder", SUBMISSIONS: orderImageStore }
  });
  assert.equal(orderImageStatusResponse.status, 200);
  assert.equal((await orderImageStatusResponse.json()).uploaded, true);

  const customCheckoutResponse = await startCheckout({
    request: new Request("https://example.test/api/checkout", {
      method: "POST",
      headers: { "Content-Type": "application/json", Origin: "https://example.test" },
      body: JSON.stringify({
        offeringId: "gift",
        imageOptionId: "",
        colorMode: "custom",
        customColorNotes: "Terracotta and black"
      })
    }),
    env: {
      STRIPE_CHECKOUT_MODE: "test",
      STRIPE_SECRET_KEY: "sk_test_placeholder",
      STRIPE_PRICE_GIFT: "price_gift"
    }
  });
  assert.equal(customCheckoutResponse.status, 400);

  const mismatchedKeyResponse = await startCheckout({
    request: new Request("https://example.test/api/checkout", {
      method: "POST",
      headers: { "Content-Type": "application/json", Origin: "https://example.test" },
      body: JSON.stringify({ offeringId: "gift", imageOptionId: "", colorMode: "curated", pairingId: "original", countdownRequest: "3 days", startMode: "recipient" })
    }),
    env: { STRIPE_CHECKOUT_ENABLED: "true", STRIPE_CHECKOUT_MODE: "live", STRIPE_SECRET_KEY: "sk_test_wrong_mode", STRIPE_PRICE_GIFT: "price_gift", STRIPE_SHIPPING_GIFT: "1095" }
  });
  assert.equal(mismatchedKeyResponse.status, 503);

  const webhookDb = createDb();
  const webhookSecret = "whsec_test_placeholder";
  const webhookEvent = {
    id: "evt_color_order",
    type: "checkout.session.completed",
    data: {
      object: {
        id: "cs_test_color_order",
        payment_status: "paid",
        amount_total: 5500,
        currency: "usd",
        customer_details: { email: "buyer@example.com" },
        metadata: {
          offering_id: "builder",
          image_option_id: "print-cut",
          color_mode: "mixed",
          pairing_id: "",
          cassette_color_id: "sage",
          stand_color_id: "oxblood",
          color_summary: "Mix & match — Matte Muted Sage frame + glossy Oxblood stand"
        }
      }
    }
  };
  const webhookPayload = JSON.stringify(webhookEvent);
  const webhookTimestamp = Math.floor(Date.now() / 1000);
  const webhookResponse = await receiveStripeWebhook({
    request: new Request("https://example.test/api/stripe/webhook", {
      method: "POST",
      headers: { "Stripe-Signature": await stripeSignature(webhookPayload, webhookSecret, webhookTimestamp) },
      body: webhookPayload
    }),
    env: { SITE_DB: webhookDb, STRIPE_WEBHOOK_SECRET: webhookSecret }
  });
  assert.equal(webhookResponse.status, 200);
  assert.equal(webhookDb.calls.length, 1);
  assert.equal(webhookDb.calls[0].values[0], "cs_test_color_order");
  assert.equal(webhookDb.calls[0].values[8], "builder");
  assert.equal(webhookDb.calls[0].values[12], "sage");
  assert.equal(webhookDb.calls[0].values[13], "oxblood");
  assert.equal(webhookDb.calls[0].values[15], "");
  assert.equal(webhookDb.calls[0].values[16], "");

  console.log("Cloudflare function tests passed.");
} finally {
  globalThis.fetch = originalFetch;
}
