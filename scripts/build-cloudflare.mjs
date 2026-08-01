import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..");
const output = path.join(root, "dist");
const read = (file) => fs.readFileSync(path.join(root, file), "utf8");

const routes = {
  home: {
    title: "Double Take Frames",
    directory: "",
    template: "Home.html",
    config: "HomeConfig.html",
    clients: ["SharedClient.html", "BlinkClient.html", "HomeClient.html"]
  },
  build: {
    title: "Build - Double Take Frames",
    directory: "build",
    template: "Build.html",
    config: "BuildConfig.html",
    clients: ["SharedClient.html", "TooltipClient.html", "SupportGuideClient.html", "ToolsClient.html", "BuildClient.html"]
  },
  kits: {
    title: "Kits - Double Take Frames",
    directory: "kits",
    template: "Kits.html",
    config: "KitsConfig.html",
    clients: ["SharedClient.html", "BlinkClient.html", "KitsClient.html"]
  },
  assembly: {
    title: "Assembly - Double Take Frames",
    directory: "assembly",
    template: "Assembly.html",
    config: "AssemblyConfig.html",
    clients: ["SharedClient.html", "TooltipClient.html", "SupportGuideClient.html", "ToolsClient.html", "AssemblyData.html", "AssemblyClient.html", "AssemblyPageClient.html"]
  }
};

const icons = {
  packageCheck: '<svg viewBox="0 0 24 24"><path d="m16 16 2 2 4-4"/><path d="M21 10V8a2 2 0 0 0-1-1.7l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.7l7 4a2 2 0 0 0 2 0l2-1.1"/><path d="m7.5 4.3 9 5.1"/><polyline points="3.3 7 12 12 20.7 7"/><line x1="12" y1="22" x2="12" y2="12"/></svg>',
  wrench: '<svg viewBox="0 0 24 24"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.8-3.8a6 6 0 0 1-7.9 7.9l-6.9 6.9a2.1 2.1 0 0 1-3-3l6.9-6.9a6 6 0 0 1 7.9-7.9z"/></svg>'
};

const galleryItems = [{
  title: "Before",
  revealTitle: "After",
  description: "A Double Take Frames reveal pair.",
  cover: "https://drive.google.com/thumbnail?id=16L423SgUeeURPMvn7TjQGv_ZLMVfKlwg&sz=w1000",
  reveal: "/assets/how-it-works-reveal-trojan-party.png"
}];

function routeHref(page, hash = "") {
  const base = page === "home" ? "/" : `/${page}/`;
  return `${base}${hash ? `#${hash}` : ""}`;
}

function localizeAssets(value) {
  return value.replace(
    /https:\/\/cdn\.jsdelivr\.net\/gh\/dvzdan\/frames-site@[^/]+\/assets\//g,
    "/assets/"
  );
}

function header(activePage) {
  const links = [
    ["home", "Home"],
    ["build", "Build"],
    ["kits", "Kits"],
    ["assembly", "Assembly"]
  ].map(([page, label]) => (
    `<a href="${routeHref(page)}"${page === activePage ? ' aria-current="page"' : ""}>${label}</a>`
  )).join("");
  return `<header class="site-nav" aria-label="Primary navigation"><a class="site-nav-brand" href="/">Double Take Frames</a><nav class="site-nav-links">${links}<a href="/#gallery-section">Gallery</a><a href="/#checkout-placeholder">Contact</a></nav></header>`;
}

function footer() {
  return `<footer class="footer"><strong>Double Take Frames</strong><p>Contact and image-submission forms are temporarily unavailable while the website moves to its new platform.</p></footer>`;
}

function galleryMarkup() {
  const item = galleryItems[0];
  return `<div class="card"><div class="top-title"><strong>${item.title}</strong></div><div class="gallery-frame-button server-gallery-toggle" role="button" tabindex="0"><span class="gallery-shadowbox-frame frame-color-0"><span class="gallery-frame-art"><img class="cover-img" src="${item.cover}" alt="${item.title}"><img class="reveal-img" src="${item.reveal}" alt="${item.revealTitle}" style="display:none"></span><span class="gallery-acrylic-glare"></span></span></div><div class="bottom-title">${item.revealTitle}</div><div class="reveal-description">${item.description}</div></div>`;
}

function downloadsMarkup() {
  return '<div class="downloads-empty fine-print" data-static-downloads="true">Design-file downloads are temporarily unavailable during the website migration.</div>';
}

function transformTemplate(page) {
  let markup = read(routes[page].template)
    .replace(/<\?!=\s*renderInitialGalleryHtml\(\)\s*\?>/g, galleryMarkup())
    .replace(/<\?!=\s*renderInitialDownloadsHtml\(\)\s*\?>/g, downloadsMarkup())
    .replace(/<\?!=\s*ScriptApp\.getService\(\)\.getUrl\(\)\s*\?>\?page=make5x7/g, "/make-5x7/")
    .replace(/<\?=\s*sitePageUrl\('([^']+)'(?:,\s*'([^']+)')?\)\s*\?>/g, (_, target, hash) => routeHref(target, hash))
    .replace(/<\?!=\s*tierSectionIcon\('([^']+)'\)\s*\?>/g, (_, name) => icons[name] || "");

  markup = localizeAssets(markup);
  const unresolved = markup.match(/<\?[\s\S]*?\?>/g);
  if (unresolved) throw new Error(`${page}: unresolved template expression ${unresolved[0]}`);
  return markup;
}

function cloudflareEnhancements() {
  return `
function startCloudflareStaticMode() {
  if (window.PAGE_KEY === "home") {
    var submission = document.querySelector(".submission-module");
    if (submission) {
      var summary = submission.querySelector("summary");
      if (summary) summary.textContent = "Submit your own — temporarily unavailable";
      var submissionCard = submission.querySelector(".card");
      if (submissionCard) {
        submissionCard.setAttribute("inert", "");
        submissionCard.setAttribute("aria-disabled", "true");
        submissionCard.querySelectorAll("input, textarea, button").forEach(function(control) { control.disabled = true; });
        var note = document.createElement("p");
        note.className = "fine-print migration-status";
        note.textContent = "Image submissions will return after the new form service is connected.";
        submissionCard.prepend(note);
      }
    }
    var ctaCopy = document.querySelector("#checkout-placeholder > .section-copy");
    if (ctaCopy) ctaCopy.textContent = "The contact form is temporarily unavailable while the website moves to its new platform.";
    var inquiry = document.getElementById("inquiryForm");
    if (inquiry) {
      inquiry.setAttribute("inert", "");
      inquiry.setAttribute("aria-disabled", "true");
      inquiry.querySelectorAll("input, select, textarea, button").forEach(function(control) { control.disabled = true; });
      var inquiryStatus = document.getElementById("inquiryStatus");
      if (inquiryStatus) inquiryStatus.textContent = "Submissions are temporarily unavailable. No information entered here will be sent.";
    }
  }
  if (window.PAGE_KEY === "build") {
    var downloads = document.getElementById("downloadsList");
    if (downloads && !downloads.children.length) downloads.innerHTML = ${JSON.stringify(downloadsMarkup())};
    var parts = document.getElementById("partsTable");
    if (parts && !parts.children.length) {
      parts.innerHTML = '<div class="downloads-empty fine-print">The live sourcing list is temporarily unavailable during the website migration.</div>';
    }
  }
}
if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", startCloudflareStaticMode);
else startCloudflareStaticMode();
`;
}

function transformClientBundle(page) {
  const route = routes[page];
  let scripts = [
    `window.PAGE_KEY=${JSON.stringify(page)};`,
    `window.INITIAL_GALLERY_ITEMS=${JSON.stringify(page === "home" ? galleryItems : [])};`,
    "window.INITIAL_TIER=\"\";",
    "window.SITE_CMS_CONTENT={};",
    "window.SERVICE_URL=\"\";",
    read("Config.html"),
    read(route.config),
    "applySiteCmsContent(SITE_CONTENT, window.SITE_CMS_CONTENT);",
    ...route.clients.map(read),
    cloudflareEnhancements()
  ].join("\n");

  scripts = scripts.replace(
    /function sitePageHref\(pageKey, hash\) \{[\s\S]*?\n\}/,
    `function sitePageHref(pageKey, hash) {\n  var routes = { home: "/", build: "/build/", kits: "/kits/", assembly: "/assembly/" };\n  var base = routes[pageKey] || "/";\n  return base + (hash ? "#" + hash : "");\n}`
  );
  scripts = scripts
    .replace(/sitePageHref\("kits"\) \+ "&tier="/g, 'sitePageHref("kits") + "?tier="')
    .replace(/sitePageHref\("kits"\) \+ '&tier='/g, 'sitePageHref("kits") + "?tier="');
  return localizeAssets(scripts);
}

function renderPage(page) {
  const route = routes[page];
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="Build a physical photo frame that reveals a second image on a timer.">
<title>${route.title}</title>
<link rel="stylesheet" href="/styles.css">
</head>
<body data-page="${page}">
${header(page)}
<main class="page page-${page}" id="app">${transformTemplate(page)}</main>
${footer()}
<script src="/scripts/${page}.js" defer></script>
</body>
</html>
`;
}

fs.rmSync(output, { recursive: true, force: true });
fs.mkdirSync(path.join(output, "scripts"), { recursive: true });
fs.cpSync(path.join(root, "assets"), path.join(output, "assets"), { recursive: true });
fs.writeFileSync(path.join(output, "styles.css"), read("Styles.html"));

for (const page of Object.keys(routes)) {
  const directory = path.join(output, routes[page].directory);
  fs.mkdirSync(directory, { recursive: true });
  fs.writeFileSync(path.join(directory, "index.html"), renderPage(page));
  fs.writeFileSync(path.join(output, "scripts", `${page}.js`), transformClientBundle(page));
}

let make5x7 = read("Make5x7.html")
  .replace(/<title>[\s\S]*?<\/title>/i, "<title>Make 5×7 - Double Take Frames</title>");
fs.mkdirSync(path.join(output, "make-5x7"), { recursive: true });
fs.writeFileSync(path.join(output, "make-5x7", "index.html"), make5x7);

fs.writeFileSync(path.join(output, "404.html"), `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Page not found - Double Take Frames</title><link rel="stylesheet" href="/styles.css"></head><body><main class="page"><section class="section page-intro"><div class="eyebrow">404</div><h1>That page is not here.</h1><p class="section-copy">Return to Double Take Frames and choose another path.</p><a class="button" href="/">Go home</a></section></main></body></html>`);
fs.writeFileSync(path.join(output, "_redirects"), "/home / 301\n/make5x7 /make-5x7/ 301\n");
fs.writeFileSync(path.join(output, "_headers"), `/*
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: camera=(), microphone=(), geolocation=()
  X-Frame-Options: SAMEORIGIN

/assets/*
  Cache-Control: public, max-age=3600
`);

console.log(`Cloudflare site built at ${output}`);
