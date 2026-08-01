import assert from "node:assert/strict";
import { onRequestPost as submitInquiry } from "../functions/api/inquiries.js";
import { onRequestPost as submitGallery } from "../functions/api/gallery/submit.js";

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
globalThis.fetch = async () => Response.json({ success: true, hostname: "localhost" });

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
    env: { SITE_DB: inquiryDb, TURNSTILE_SECRET_KEY: "test-secret" },
    waitUntil(promise) { void promise; }
  });
  assert.equal(inquiryResponse.status, 201);
  assert.equal(inquiryDb.calls.length, 1);
  assert.equal(inquiryDb.calls[0].values[5], "test@example.com");

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
    env: { SITE_DB: galleryDb, SUBMISSIONS: submissions, TURNSTILE_SECRET_KEY: "test-secret" }
  });
  assert.equal(galleryResponse.status, 201);
  assert.equal(galleryDb.calls.length, 1);
  assert.equal(submissions.objects.size, 2);
  assert.match(galleryDb.calls[0].values[6], /^pending\/.+\/cover\.png$/);

  console.log("Cloudflare function tests passed.");
} finally {
  globalThis.fetch = originalFetch;
}
