import fs from "node:fs";
import http from "node:http";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..", "dist");
const port = Number(process.env.PORT) || 4173;
const types = {
  ".css": "text/css; charset=utf-8",
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".png": "image/png",
  ".svg": "image/svg+xml",
  ".webp": "image/webp"
};

function resolveRequest(urlPath) {
  const clean = decodeURIComponent(urlPath).replace(/^\/+/, "");
  const candidate = path.resolve(root, clean || "index.html");
  if (!candidate.startsWith(root + path.sep) && candidate !== root) return null;
  if (fs.existsSync(candidate) && fs.statSync(candidate).isDirectory()) return path.join(candidate, "index.html");
  if (fs.existsSync(candidate)) return candidate;
  if (!path.extname(candidate) && fs.existsSync(path.join(candidate, "index.html"))) return path.join(candidate, "index.html");
  return null;
}

http.createServer((request, response) => {
  const url = new URL(request.url, `http://${request.headers.host}`);
  const file = resolveRequest(url.pathname);
  if (!file) {
    response.writeHead(404, { "Content-Type": "text/html; charset=utf-8" });
    response.end(fs.readFileSync(path.join(root, "404.html")));
    return;
  }
  response.writeHead(200, { "Content-Type": types[path.extname(file).toLowerCase()] || "application/octet-stream" });
  response.end(fs.readFileSync(file));
}).listen(port, "127.0.0.1", () => {
  console.log(`Cloudflare preview: http://127.0.0.1:${port}/`);
});
