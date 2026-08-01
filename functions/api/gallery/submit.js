import {
  assertSameOrigin,
  cleanText,
  errorResponse,
  HttpError,
  isHoneypotFilled,
  jsonResponse,
  requireBinding,
  validateEmail,
  validateImage,
  validateTurnstile
} from "../../../cloudflare/api-helpers.js";

export async function onRequestPost(context) {
  let uploadedKeys = [];
  try {
    assertSameOrigin(context.request);
    const form = await context.request.formData();
    if (isHoneypotFilled(form.get("website"))) {
      return jsonResponse({ ok: true, message: "Images submitted for review." }, 201);
    }
    await validateTurnstile(context.request, context.env, form.get("turnstileToken"));
    if (!form.get("consent")) {
      throw new HttpError(400, "Please confirm that you may submit these images.");
    }

    const cover = form.get("cover");
    const reveal = form.get("reveal");
    const coverExtension = validateImage(cover, "Cover");
    const revealExtension = validateImage(reveal, "Reveal");
    const submission = {
      id: crypto.randomUUID(),
      createdAt: new Date().toISOString(),
      title: cleanText(form.get("title"), 120, "Cover title"),
      revealTitle: cleanText(form.get("revealTitle"), 120, "Reveal title"),
      description: cleanText(form.get("description"), 1000, "Description"),
      email: validateEmail(form.get("email")),
      coverKey: "",
      revealKey: ""
    };
    submission.coverKey = `pending/${submission.id}/cover.${coverExtension}`;
    submission.revealKey = `pending/${submission.id}/reveal.${revealExtension}`;

    const submissions = requireBinding(context.env, "SUBMISSIONS");
    const db = requireBinding(context.env, "SITE_DB");
    await submissions.put(submission.coverKey, await cover.arrayBuffer(), {
      metadata: { submissionId: submission.id, kind: "cover", contentType: cover.type }
    });
    uploadedKeys.push(submission.coverKey);
    await submissions.put(submission.revealKey, await reveal.arrayBuffer(), {
      metadata: { submissionId: submission.id, kind: "reveal", contentType: reveal.type }
    });
    uploadedKeys.push(submission.revealKey);

    await db.prepare(`
      INSERT INTO gallery_entries
        (id, created_at, title, reveal_title, description, submitter_email,
         cover_key, reveal_key, status, source, sort_order)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pending', 'website', 0)
    `).bind(
      submission.id,
      submission.createdAt,
      submission.title,
      submission.revealTitle,
      submission.description,
      submission.email,
      submission.coverKey,
      submission.revealKey
    ).run();

    return jsonResponse({ ok: true, message: "Images submitted for review." }, 201);
  } catch (error) {
    if (uploadedKeys.length && context.env.SUBMISSIONS) {
      try {
        await Promise.all(uploadedKeys.map((key) => context.env.SUBMISSIONS.delete(key)));
      } catch (cleanupError) {
        console.error("Could not clean up incomplete gallery upload", cleanupError);
      }
    }
    return errorResponse(error);
  }
}
