import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..");
const read = (file) => fs.readFileSync(path.join(root, file), "utf8");
const exists = (file) => fs.existsSync(path.join(root, file));

const routes = {
  home: {
    template: "Home.html",
    partials: [],
    config: "HomeConfig.html",
    clients: ["SharedClient.html", "BlinkClient.html", "HomeClient.html"],
    required: ['id="top"', 'id="how-it-works"', 'id="gallery-section"', 'id="checkout-placeholder"'],
    forbidden: ["ASSEMBLY_MANIFEST", "pricingTiers", "AssemblyData.html"]
  },
  build: {
    template: "Build.html",
    partials: [],
    config: "BuildConfig.html",
    clients: ["SharedClient.html", "TooltipClient.html", "SupportGuideClient.html", "BuildClient.html"],
    required: ['id="plans"', 'id="build-print"', 'id="build-hardware"', 'id="parts"', 'id="self-print-next"'],
    forbidden: ["ASSEMBLY_MANIFEST", "INITIAL_GALLERY_ITEMS", "KitsConfig", 'id="build-images"', 'id="build-continue"', 'id="setup-inventory"']
  },
  kits: {
    template: "Kits.html",
    partials: [],
    config: "KitsConfig.html",
    clients: ["SharedClient.html", "BlinkClient.html", "KitsClient.html"],
    required: [
      'id="kits"',
      'id="pricingTiers"',
      "Hardware Bundle",
      "Ready-to-Assemble Kit",
      "Finished Gift",
      "$25",
      "$45",
      "$80",
      "Launch pricing for the first production run; prices may change as materials and capacity settle."
    ],
    forbidden: ["ASSEMBLY_MANIFEST", "INITIAL_GALLERY_ITEMS", "AssemblyConfig"]
  },
  assembly: {
    template: "Assembly.html",
    partials: ["Preparation.html"],
    config: "AssemblyConfig.html",
    clients: ["SharedClient.html", "TooltipClient.html", "ToolsClient.html", "AssemblyData.html", "AssemblyClient.html", "AssemblyPageClient.html"],
    required: ['id="assembly-start"', 'id="prepare-images"', 'id="setup-inventory"', 'id="setup-manual"', 'id="assembly-tools"', 'id="assemblyGuide"', 'id="faq"'],
    forbidden: ["INITIAL_GALLERY_ITEMS", "renderHomeGallery", "KitsConfig"]
  }
};

const errors = [];
const index = read("Index.html");
const code = read("Code.js");
const claspIgnore = read(".claspignore");

for (const [page, route] of Object.entries(routes)) {
  const files = [route.template, ...(route.partials || []), "Config.html", route.config, ...route.clients];
  files.forEach((file) => {
    if (!exists(file)) errors.push(`${page}: missing ${file}`);
    if (file !== route.template && file !== "Config.html" && !claspIgnore.includes(`!${file}`)) {
      errors.push(`${page}: ${file} is not in the clasp allowlist`);
    }
  });

  const markup = [route.template, ...(route.partials || [])].map(read).join("\n");
  route.required.forEach((token) => {
    if (!markup.includes(token)) errors.push(`${page}: missing required markup ${token}`);
  });

  const simulatedPayload = files.map(read).join("\n");
  route.forbidden.forEach((token) => {
    if (simulatedPayload.includes(token)) errors.push(`${page}: leaked forbidden payload ${token}`);
  });

  if (!code.includes(`${page}: {`)) errors.push(`${page}: missing route in Code.js`);
  if (!index.includes(`pageKey === '${page}'`)) errors.push(`${page}: missing conditional bundle in Index.html`);

  const bytes = Buffer.byteLength(simulatedPayload);
  console.log(`${page.padEnd(8)} ${String(bytes).padStart(7)} bytes  ${files.join(", ")}`);
}

if (!code.includes('SITE_PAGE_ROUTES[requestedPage] ? requestedPage : "home"')) {
  errors.push("routing: missing Home fallback");
}
if (!code.includes('requestedPage === "make5x7"')) {
  errors.push("routing: Make 5x7 route is not preserved");
}
if (!index.includes("renderSharedHeader_(pageKey)") || !index.includes("SharedFooter")) {
  errors.push("shell: shared header or footer include is missing");
}
if (!code.includes("HtmlService.createTemplateFromFile(filename).getRawContent()")) {
  errors.push("includes: raw partials must use HtmlTemplate.getRawContent()");
}
if (code.includes("HtmlService.createHtmlOutputFromFile(filename).getContent()")) {
  errors.push("includes: raw partials still pass through encoding HtmlOutput");
}

if (errors.length) {
  console.error("\nMultipage validation failed:");
  errors.forEach((error) => console.error(`- ${error}`));
  process.exitCode = 1;
} else {
  console.log("\nMultipage validation passed.");
}
