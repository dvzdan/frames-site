import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..");
const output = path.join(root, "dist");
const read = (file) => fs.readFileSync(path.join(root, file), "utf8");
const turnstileSiteKey = process.env.TURNSTILE_SITE_KEY || "0x4AAAAAAED54nDkAZ3duJOu";
const contentFeedUrl = process.env.SITE_CONTENT_URL || "https://script.google.com/macros/s/AKfycbwijm7g7RhKLK_j8FuUiJ4b2m5rwxZIOy5-vHlcxt5USITIPswmaGeXN-UL2RAdBxg/exec?format=content";
const fallbackSiteContent = JSON.parse(read("cloudflare/site-content.json"));

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

// Static snapshot of the six published pairs from the approved Apps Script
// gallery. Cloudflare renders these without querying Google Sheets at runtime.
const galleryItems = [
  {
    title: "The Box Waits",
    revealTitle: "The Harlequin Springs Out",
    description: "An antique jack-in-the-box waits under stage curtains, then releases a worn theatrical puppet from its coil.",
    cover: "https://drive.google.com/thumbnail?id=1S3sr-gC17mVLNO0ZNm3Edh5XMtAh0lcz&sz=w1000",
    reveal: "https://drive.google.com/thumbnail?id=1rJGOeli04-7Z2nCaBwjyAzCLLOV9o_1z&sz=w1000"
  },
  {
    title: "Sick bird",
    revealTitle: "Nursed to health",
    description: "For Water Frame variant",
    cover: "https://drive.google.com/thumbnail?id=1-cmiGmK-QqsHtnNfZBT0UYDgs5ozt3GE&sz=w1000",
    reveal: "https://drive.google.com/thumbnail?id=1H7X53mkgchYt7vaMwY8ZgzNUNgaEbIp3&sz=w1000"
  },
  {
    title: "wolf",
    revealTitle: "werewolf",
    description: "",
    cover: "https://drive.google.com/thumbnail?id=1_GTD0d9P26o8Hyi6T3LwIlKg5IQayo4_&sz=w1000",
    reveal: "https://drive.google.com/thumbnail?id=1iY2uRP6EXWZXp4zeTjrazVja5xI0XOfj&sz=w1000"
  },
  {
    title: "Not where you stay",
    revealTitle: "Bloom anyway",
    description: "",
    cover: "https://drive.google.com/thumbnail?id=1NPvr5G_rS8jFn0Y_N8QvFFF_bFO_-D8r&sz=w1000",
    reveal: "https://drive.google.com/thumbnail?id=1iGrQ-OKlrjMKr9xstDBuWeoj3tLRybRt&sz=w1000"
  },
  {
    title: "Still Life",
    revealTitle: "Not Still Alive",
    description: "",
    cover: "https://drive.google.com/thumbnail?id=1KV2kQ8RDqe56ufbRqmW3v6CQNIA2ftzy&sz=w1000",
    reveal: "https://drive.google.com/thumbnail?id=1WkdR2SkD11yHg_6vqkJG7BmOOhC-ov9Q&sz=w1000"
  },
  {
    title: "Trojan",
    revealTitle: "Troy",
    description: "",
    cover: "https://drive.google.com/thumbnail?id=16L423SgUeeURPMvn7TjQGv_ZLMVfKlwg&sz=w1000",
    reveal: "https://drive.google.com/thumbnail?id=1Y6yk4mI9--aYN1zrzyg8bXJozmI0oAgM&sz=w1000"
  }
];

// Static snapshot of the current sourcing sheet. These can move to D1 later if
// frequent non-code editing becomes useful.
const partsItems = [
  { item: "Display Image Material", product: "KOALA Waterproof Matte White Tear-Resistant Printable Vinyl Paper, 8.5 x 11 in.", url: "", quantity: "1 sheet", note: "Required. Used to print the Display Image." },
  { item: "Reveal Image Material", product: "PPD Double-Sided Photo Paper / Glossy Brochure Paper, 8.5 x 11 in., 140 gsm, 6.2 mil, instant-dry and water-resistant.", url: "", quantity: "1 sheet", note: "Recommended. Used to print the Reveal Image." },
  { item: "Clear PET Sheet", product: "Clear, flexible PET sheet, 1 mm thick. Start with an 8 x 10 in. sheet and cut it to approximately 5.75 x 6.75 in.", url: "", quantity: "1 piece", note: "Required. Use clear, flexible PET rather than rigid acrylic." },
  { item: "Backing Board", product: "Backing-board sheet, 8 x 10 in. and approximately 1/20 in. thick. Cut to approximately 6.875 x 10 in.", url: "", quantity: "1 piece", note: "Required. Use 6.875 in. for the cut dimension." },
  { item: "Clock Movement", product: "Reference movement - Young Town 12888SA. Threadless / snap-in 12888-style quartz clock movement, approximately 8 mm total shaft, step/ticking movement.", url: "", quantity: "1", note: "Required. Capstans are fitted to the reference movement; if you use a different brand/model, you will have to adjust the bore sizes of the capstans." },
  { item: "Zipper", product: "UpBrands Fidget Zipper Bracelet", url: "", quantity: "1", note: "Recommended. Must unzip with very little resistance; reject any zipper that feels stiff or catches." },
  { item: "Pull Line", product: "X8 braided fishing line", url: "", quantity: "As required", note: "Required. Used as the clock-driven pull line." },
  { item: "Weight Ballast", product: "Lead fishing weights / sinkers", url: "", quantity: "Enough to fill the printed weight carriage", note: "Recommended. Use small weights that can pack tightly into the carriage." },
  { item: "UHMW Tape", product: "", url: "", quantity: "About 4 inches", note: "The type of tape is important: UHMW is remarkably low-friction." }
];

async function loadSiteContent() {
  let lastError;
  for (let attempt = 1; attempt <= 2; attempt += 1) {
    try {
      const response = await fetch(contentFeedUrl, { redirect: "follow", signal: AbortSignal.timeout(45000) });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const content = await response.json();
      if (!content || typeof content !== "object" || Array.isArray(content)) {
        throw new Error("content feed did not return an object");
      }
      console.log("Loaded editable site copy from the Google Sheet.");
      return content;
    } catch (error) {
      lastError = error;
      if (attempt < 2) console.warn(`Spreadsheet content attempt ${attempt} failed; retrying.`);
    }
  }
  console.warn(`Using the saved spreadsheet snapshot because the live feed was unavailable: ${lastError.message}`);
  return fallbackSiteContent;
}

const siteContent = await loadSiteContent();

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
  return `<footer class="footer"><strong>Double Take Frames</strong><p>Questions and image submissions are reviewed directly.</p></footer>`;
}

function galleryMarkup() {
  return galleryItems.map((item, index) => (
    `<div class="card"><div class="top-title"><strong>${item.title}</strong></div><div class="gallery-frame-button server-gallery-toggle" role="button" tabindex="0"><span class="gallery-shadowbox-frame frame-color-${index % 6}"><span class="gallery-frame-art"><img class="cover-img" src="${item.cover}" alt="${item.title}"><img class="reveal-img" src="${item.reveal}" alt="${item.revealTitle}" style="display:none"></span><span class="gallery-acrylic-glare"></span></span></div><div class="bottom-title">${item.revealTitle}</div>${item.description ? `<div class="reveal-description">${item.description}</div>` : ""}</div>`
  )).join("");
}

function downloadsMarkup() {
  return '<a class="download-row" target="_blank" rel="noopener" href="https://drive.google.com/uc?export=download&amp;id=1d337bPLj43E7ge_t69K9j9kmf9QktIM8"><span class="download-name">main.3mf</span><span class="download-meta">125 KB · Updated Jul 22, 2026</span><span class="download-action" aria-hidden="true">Download</span></a>';
}

function transformTemplate(page) {
  let markup = read(routes[page].template)
    .replace(/<\?!=\s*renderInitialGalleryHtml\(\)\s*\?>/g, galleryMarkup())
    .replace(/<\?!=\s*renderInitialDownloadsHtml\(\)\s*\?>/g, downloadsMarkup())
    .replace(/<\?!=\s*ScriptApp\.getService\(\)\.getUrl\(\)\s*\?>\?page=make5x7/g, "/make-5x7/")
    .replace(/<\?=\s*sitePageUrl\('([^']+)'(?:,\s*'([^']+)')?\)\s*\?>/g, (_, target, hash) => routeHref(target, hash))
    .replace(/<\?!=\s*tierSectionIcon\('([^']+)'\)\s*\?>/g, (_, name) => icons[name] || "");

  markup = localizeAssets(markup).replace(/__TURNSTILE_SITE_KEY__/g, turnstileSiteKey);
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
      if (summary) summary.textContent = "Submit your own";
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
    `window.SITE_CMS_CONTENT=${JSON.stringify(siteContent)};`,
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
${page === "home" ? '<script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>' : ""}
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
fs.writeFileSync(path.join(output, "_routes.json"), JSON.stringify({
  version: 1,
  include: ["/api/*"],
  exclude: []
}, null, 2));
fs.writeFileSync(path.join(output, "_headers"), `/*
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: camera=(), microphone=(), geolocation=()
  X-Frame-Options: SAMEORIGIN

/assets/*
  Cache-Control: public, max-age=3600
`);

console.log(`Cloudflare site built at ${output}`);
