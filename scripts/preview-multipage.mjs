import fs from "node:fs";
import http from "node:http";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..");
const port = Number(process.env.PORT) || 4173;
const read = (file) => fs.readFileSync(path.join(root, file), "utf8");
const release = JSON.parse(read("release/current.json"));

const routeFiles = {
  home: {
    template: "Home.html",
    config: "HomeConfig.html",
    clients: ["SharedClient.html", "BlinkClient.html", "HomeClient.html"]
  },
  build: {
    template: "Build.html",
    config: "BuildConfig.html",
    clients: ["SharedClient.html", "TooltipClient.html", "SupportGuideClient.html", "BuildClient.html"]
  },
  kits: {
    template: "Kits.html",
    config: "KitsConfig.html",
    clients: ["SharedClient.html", "BlinkClient.html", "KitsClient.html"]
  },
  assembly: {
    template: "Assembly.html",
    config: "AssemblyConfig.html",
    clients: ["SharedClient.html", "TooltipClient.html", "ToolsClient.html", "AssemblyData.html", "AssemblyClient.html", "AssemblyPageClient.html"]
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
  return `/?page=${page}${hash ? `#${hash}` : ""}`;
}

function renderHeader(activePage) {
  const links = [
    ["kits", "Get One", routeHref("kits")],
    ["home", "How It Works", routeHref("home", "how-it-works")],
    ["assembly", "Instructions", routeHref("assembly")]
  ].map(([page, label, href]) => (
    `<a href="${href}"${page === activePage && page !== "home" ? ' aria-current="page"' : ""}>${label}</a>`
  )).join("");
  return `<header class="site-nav" aria-label="Primary navigation"><a class="site-nav-brand" href="${routeHref("home")}">Double Take Frames</a><nav class="site-nav-links">${links}<a href="${routeHref("home", "gallery-section")}">Gallery</a><a href="${routeHref("home", "checkout-placeholder")}">Contact</a></nav></header>`;
}

function serverGalleryMarkup() {
  return `<div class="card"><div class="top-title"><strong>Before</strong></div><div class="gallery-frame-button server-gallery-toggle" role="button" tabindex="0"><span class="gallery-shadowbox-frame frame-color-0"><span class="gallery-frame-art"><img class="cover-img" src="${galleryItem.cover}" alt="Before"><img class="reveal-img" src="${galleryItem.reveal}" alt="After" style="display:none"></span><span class="gallery-acrylic-glare"></span></span></div><div class="bottom-title">After</div><div class="reveal-description">Preview pair</div></div>`;
}

function serverDownloadsMarkup() {
  const sourceCount = release.artifacts.filter((artifact) => artifact.type === "scad").length;
  return `<a class="download-row download-row-primary" href="#"><span class="download-name">Frame and Stand</span><span class="download-meta">3MF project · 0.6 mm nozzle recommended</span><span class="download-action">Download</span></a><a class="download-row download-row-primary" href="#"><span class="download-name">Everything Else</span><span class="download-meta">3MF project · 0.4 mm nozzle required</span><span class="download-action">Download</span></a><details class="download-advanced-group"><summary class="download-advanced-summary"><span>Advanced files and release details</span><span class="download-advanced-toggle"></span></summary><div class="download-advanced-content"><section class="design-release-summary" id="design-release"><strong>Current design release ${release.version}</strong></section><section class="download-source-section"><h4>Editable OpenSCAD source</h4><p>${sourceCount} files for modifying the design</p><div class="download-source-list"><a class="download-row" href="#"><span class="download-name">Main Frame ${release.version}.scad</span><span class="download-meta">OpenSCAD source</span><span class="download-action">Download</span></a></div></section><a class="download-row download-release-notes" href="#"><span class="download-name">Release notes — ${release.version}</span><span class="download-action">Download</span></a><p class="advanced-support-note"><button class="text-link-button support-guide-trigger" type="button">Support-removal guide</button> for the built-in print supports.</p></div></details>`;
}

function renderPartial(page) {
  return read(routeFiles[page].template)
    .replace(/<\?!=\s*include\('([^']+)'\)\s*;?\s*\?>/g, (_, partial) => read(`${partial}.html`))
    .replace(/<\?!=\s*renderInitialGalleryHtml\(\)\s*\?>/g, serverGalleryMarkup())
    .replace(/<\?!=\s*renderInitialDownloadsHtml\(\)\s*\?>/g, serverDownloadsMarkup())
    .replace(/<\?!=\s*ScriptApp\.getService\(\)\.getUrl\(\)\s*\?>/g, "")
    .replace(/<\?=\s*sitePageUrl\('([^']+)'(?:,\s*'([^']+)')?\)\s*\?>/g, (_, target, hash) => routeHref(target, hash))
    .replace(/<\?!=?\s*[^?]*\?>/g, "");
}

function renderPage(page, requestUrl) {
  const route = routeFiles[page];
  const requestedTier = page === "kits" ? requestUrl.searchParams.get("tier") || "" : "";
  const scripts = [
    read("Config.html"),
    read(route.config),
    "applySiteCmsContent(SITE_CONTENT, window.SITE_CMS_CONTENT);",
    ...route.clients.map(read)
  ].join("\n");

  return `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><style>${read("Styles.html")}</style></head><body data-page="${page}">${renderHeader(page)}<main class="page page-${page}" id="app">${renderPartial(page)}</main>${read("SharedFooter.html")}<script>window.PAGE_KEY=${JSON.stringify(page)};window.SERVICE_URL="";window.SITE_CMS_CONTENT={};window.INITIAL_GALLERY_ITEMS=${JSON.stringify(page === "home" ? galleryItems : [])};window.INITIAL_TIER=${JSON.stringify(requestedTier)};</script><script>${scripts}</script></body></html>`;
}

http.createServer((request, response) => {
  const url = new URL(request.url, `http://${request.headers.host}`);
  const page = routeFiles[url.searchParams.get("page")] ? url.searchParams.get("page") : "home";
  response.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  response.end(renderPage(page, url));
}).listen(port, "127.0.0.1", () => {
  console.log(`Multipage preview: http://127.0.0.1:${port}/?page=home`);
});
