import { errorResponse, jsonResponse, requireBinding } from "../../cloudflare/api-helpers.js";

export async function onRequestGet(context) {
  try {
    const db = requireBinding(context.env, "SITE_DB");
    const result = await db.prepare(`
      SELECT id, title, reveal_title, description, cover_key, reveal_key,
             cover_url, reveal_url
      FROM gallery_entries
      WHERE status = 'published'
      ORDER BY sort_order DESC, published_at DESC, created_at DESC
      LIMIT 24
    `).all();
    const items = (result.results || []).map((row) => ({
      title: row.title || "Untitled",
      revealTitle: row.reveal_title || "Reveal image",
      description: row.description || "",
      cover: row.cover_url || `/api/gallery/image/${encodeURIComponent(row.id)}/cover`,
      reveal: row.reveal_url || `/api/gallery/image/${encodeURIComponent(row.id)}/reveal`
    }));
    return jsonResponse({ ok: true, items }, 200, { "Cache-Control": "public, max-age=60" });
  } catch (error) {
    return errorResponse(error);
  }
}
