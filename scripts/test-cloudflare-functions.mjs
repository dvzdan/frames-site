import assert from "node:assert/strict";
import { onRequestPost as submitInquiry } from "../functions/api/inquiries.js";
import { onRequestPost as submitGallery } from "../functions/api/gallery/submit.js";
import { onRequestGet as getGalleryImage } from "../functions/api/gallery/image/[[path]].js";
import { onRequestPost as startCheckout } from "../functions/api/checkout.js";

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

function createSubmissionStore() {
  const objects = new Map();
  return {
    objects,
    async put(key, value, options) { objects.set(key, { value, options }); },
    async delete(key) { objects.delete(key); },
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
      type: "Build question",
      kit: "Not sure yet",
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
  assert.equal(siteverifyRequests[0].secret, "live-secret");

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

  let stripeRequest;
  globalThis.fetch = async (url, options) => {
    stripeRequest = { url, options, body: new URLSearchParams(options.body) };
    return Response.json({ url: "https://checkout.stripe.com/c/pay/test-session" });
  };
  const checkoutResponse = await startCheckout({
    request: new Request("https://example.test/api/checkout", {
      method: "POST",
      headers: { "Content-Type": "application/json", Origin: "https://example.test" },
      body: JSON.stringify({ offeringId: "builder", imageOptionId: "print-cut", amount: 1 })
    }),
    env: {
      STRIPE_CHECKOUT_MODE: "test",
      STRIPE_SECRET_KEY: "sk_test_placeholder",
      STRIPE_PRICE_MAKER: "price_maker",
      STRIPE_PRICE_BUILDER: "price_builder",
      STRIPE_PRICE_GIFT: "price_gift",
      STRIPE_PRICE_IMAGE_PREP: "price_image_prep"
    }
  });
  assert.equal(checkoutResponse.status, 200);
  assert.equal(stripeRequest.url, "https://api.stripe.com/v1/checkout/sessions");
  assert.equal(stripeRequest.options.headers.Authorization, "Bearer sk_test_placeholder");
  assert.equal(stripeRequest.body.get("line_items[0][price]"), "price_builder");
  assert.equal(stripeRequest.body.get("line_items[1][price]"), "price_image_prep");
  assert.equal(stripeRequest.body.get("line_items[0][quantity]"), "1");
  assert.equal(stripeRequest.body.has("amount"), false);

  const mismatchedKeyResponse = await startCheckout({
    request: new Request("https://example.test/api/checkout", {
      method: "POST",
      headers: { "Content-Type": "application/json", Origin: "https://example.test" },
      body: JSON.stringify({ offeringId: "gift", imageOptionId: "" })
    }),
    env: { STRIPE_CHECKOUT_MODE: "live", STRIPE_SECRET_KEY: "sk_test_wrong_mode", STRIPE_PRICE_GIFT: "price_gift" }
  });
  assert.equal(mismatchedKeyResponse.status, 503);

  console.log("Cloudflare function tests passed.");
} finally {
  globalThis.fetch = originalFetch;
}
