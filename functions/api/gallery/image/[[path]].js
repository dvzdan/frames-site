import {
  errorResponse,
  HttpError,
  requireBinding
} from "../../../../../cloudflare/api-helpers.js";

export async function onRequestGet(context) {
  try {
    const path = Array.isArray(context.params.path) ? context.params.path : [];
    const [id, kind] = path;
    if (!id || !["cover", "reveal"].includes(kind) || path.length !== 2) {
      throw new HttpError(404, "Image not found.");
    }
    const db = requireBinding(context.env, "SITE_DB");
    const submissions = requireBinding(context.env, "SUBMISSIONS");
    const keyColumn = kind === "cover" ? "cover_key" : "reveal_key";
    const row = await db.prepare(`
      SELECT ${keyColumn} AS object_key
      FROM gallery_entries
      WHERE id = ? AND status = 'published'
      LIMIT 1
    `).bind(id).first();
    if (!row || !row.object_key) throw new HttpError(404, "Image not found.");
    const object = await submissions.getWithMetadata(row.object_key, "stream");
    if (!object || !object.value) throw new HttpError(404, "Image not found.");
    const headers = new Headers({
      "Content-Type": object.metadata && object.metadata.contentType || "application/octet-stream"
    });
    headers.set("Cache-Control", "public, max-age=3600");
    headers.set("X-Content-Type-Options", "nosniff");
    return new Response(object.value, { headers });
  } catch (error) {
    return errorResponse(error);
  }
}
