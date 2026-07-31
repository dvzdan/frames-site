import fs from "node:fs";
import http from "node:http";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..");
const port = Number(process.env.PORT) || 4173;
const read = (file) => fs.readFileSync(path.join(root, file), "utf8");

const routeFiles = {
  home: {
    template: "Home.html",
    config: "HomeConfig.html",
    clients: ["SharedClient.html", "BlinkClient.html", "HomeClient.html"]
  },
  build: {
    template: "Build.html",
    config: "BuildConfig.html",
    clients: ["SharedClient.html", "TooltipClient.html", "SupportGuideClient.html", "ToolsClient.html", "BuildClient.html"]
  },
  kits: {
    template: "Kits.html",
    config: "KitsConfig.html",
    clients: ["SharedClient.html", "BlinkClient.html", "KitsClient.html"]
  },
  assembly: {
    template: "Assembly.html",
    config: "AssemblyConfig.html",
    clients: ["SharedClient.html", "TooltipClient.html", "SupportGuideClient.html", "ToolsClient.html", "AssemblyData.html", "AssemblyClient.html", "AssemblyPageClient.html"]
  }
};

const galleryItem = {
  title: "Before",
  revealTitle: "After",
  description: "Preview pair",
  cover: "https://cdn.jsdelivr.net/gh/dvzdan/frames-site@main/assets/tier-gift-activity-refined.jpg",
  reveal: "https://cdn.jsdelivr.net/gh/dvzdan/frames-site@main/assets/how-it-works-reveal-trojan-party.png"
};
const galleryItems = [
  galleryItem,
  {
    title: "Second cover",
    revealTitle: "Second reveal",
    description: "Preview cycle pair",
    cover: galleryItem.reveal,
    reveal: galleryItem.cover
  }
];

function routeHref(page, hash = "") {
  return `/?page=${page}${hash ? `&section=${encodeURIComponent(hash)}#${encodeURIComponent(hash)}` : ""}`;
}

function renderHeader(activePage) {
  const links = [
    ["home", "Home"],
    ["build", "Build"],
    ["kits", "Kits"],
    ["assembly", "Assembly"]
  ].map(([page, label]) => (
    `<a href="${routeHref(page)}"${page === activePage ? ' aria-current="page"' : ""}>${label}</a>`
  )).join("");
  const homeSectionLinks = activePage === "home"
    ? '<a href="#gallery-section" target="_self">Gallery</a><a href="#checkout-placeholder" target="_self">Contact</a>'
    : `<a href="${routeHref("home", "gallery-section")}">Gallery</a><a href="${routeHref("home", "checkout-placeholder")}">Contact</a>`;
  return `<header class="site-nav" aria-label="Primary navigation"><a class="site-nav-brand" href="${routeHref("home")}">Double Take Frames</a><nav class="site-nav-links">${links}${homeSectionLinks}</nav></header>`;
}

function serverGalleryMarkup() {
  return `<div class="card"><div class="top-title"><strong>Before</strong></div><div class="gallery-frame-button server-gallery-toggle" role="button" tabindex="0"><span class="gallery-shadowbox-frame frame-color-0"><span class="gallery-frame-art"><img class="cover-img" src="${galleryItem.cover}" alt="Before"><img class="reveal-img" src="${galleryItem.reveal}" alt="After" style="display:none"></span><span class="gallery-acrylic-glare"></span></span></div><div class="bottom-title">After</div><div class="reveal-description">Preview pair</div></div>`;
}

function serverDownloadsMarkup() {
  return `<a class="download-row" href="#"><span class="download-name">double-take-frame.3mf</span><span class="download-meta">4.2 MB</span><span class="download-action">Download</span></a><a class="download-row" href="#"><span class="download-name">parts.stl</span><span class="download-meta">1.8 MB</span><span class="download-action">Download</span></a>`;
}

function renderPartial(page) {
  return read(routeFiles[page].template)
    .replace(/<\?!=\s*renderInitialGalleryHtml\(\)\s*\?>/g, serverGalleryMarkup())
    .replace(/<\?!=\s*renderInitialDownloadsHtml\(\)\s*\?>/g, serverDownloadsMarkup())
    .replace(/<\?!=\s*ScriptApp\.getService\(\)\.getUrl\(\)\s*\?>/g, "")
    .replace(/<\?=\s*sitePageUrl\('([^']+)'(?:,\s*'([^']+)')?\)\s*\?>/g, (_, target, hash) => routeHref(target, hash))
    .replace(/<\?!=?\s*[^?]*\?>/g, "");
}

function renderPage(page, requestUrl) {
  const route = routeFiles[page];
  const requestedTier = page === "kits" ? requestUrl.searchParams.get("tier") || "" : "";
  const requestedSection = /^[A-Za-z][A-Za-z0-9_-]*$/.test(requestUrl.searchParams.get("section") || "")
    ? requestUrl.searchParams.get("section")
    : "";
  const scripts = [
    read("Config.html"),
    read(route.config),
    "applySiteCmsContent(SITE_CONTENT, window.SITE_CMS_CONTENT);",
    ...route.clients.map(read)
  ].join("\n");

  return `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><style>${read("Styles.html")}</style></head><body data-page="${page}">${renderHeader(page)}<main class="page page-${page}" id="app">${renderPartial(page)}</main>${read("SharedFooter.html")}<script>window.PAGE_KEY=${JSON.stringify(page)};window.SERVICE_URL="";window.SITE_CMS_CONTENT={};window.INITIAL_SECTION=${JSON.stringify(requestedSection)};window.INITIAL_GALLERY_ITEMS=${JSON.stringify(page === "home" ? galleryItems : [])};window.INITIAL_TIER=${JSON.stringify(requestedTier)};</script><script>${scripts}</script></body></html>`;
}

http.createServer((request, response) => {
  const url = new URL(request.url, `http://${request.headers.host}`);
  const page = routeFiles[url.searchParams.get("page")] ? url.searchParams.get("page") : "home";
  response.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  response.end(renderPage(page, url));
}).listen(port, "127.0.0.1", () => {
  console.log(`Multipage preview: http://127.0.0.1:${port}/?page=home`);
});
