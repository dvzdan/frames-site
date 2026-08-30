import fs from "node:fs";
import path from "node:path";

const projectRoot = path.resolve(import.meta.dirname, "..");
const root = path.join(projectRoot, "dist");
const release = JSON.parse(fs.readFileSync(path.join(projectRoot, "release", "current.json"), "utf8"));
const routes = ["", "build", "kits", "assembly", "policies", "make-5x7", path.join("checkout", "success")];
const errors = [];
const files = [];

function walk(directory) {
  for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
    const full = path.join(directory, entry.name);
    if (entry.isDirectory()) walk(full);
    else files.push(full);
  }
}

for (const route of routes) {
  const file = path.join(root, route, "index.html");
  if (!fs.existsSync(file)) errors.push(`Missing route output: /${route}`);
}
for (const file of ["404.html", "_headers", "_redirects", "_routes.json", "styles.css"]) {
  if (!fs.existsSync(path.join(root, file))) errors.push(`Missing output file: ${file}`);
}

walk(root);
const textFiles = files.filter((file) => /\.(?:html|js|css)$|_(?:headers|redirects)$/.test(file));
for (const file of textFiles) {
  const source = fs.readFileSync(file, "utf8");
  const label = path.relative(root, file);
  if (/<\?[!=]?[\s\S]*?\?>/.test(source)) errors.push(`${label}: unresolved Apps Script template tag`);
  if (/google\.script\.run/.test(source)) errors.push(`${label}: google.script.run remains in deployable output`);
  if (/script\.google\.com\/macros/.test(source)) errors.push(`${label}: Apps Script deployment URL remains`);
  if (/\?page=(?:home|build|kits|assembly|make5x7)/.test(source)) errors.push(`${label}: legacy page query route remains`);
}

const home = fs.readFileSync(path.join(root, "index.html"), "utf8");
const homeScript = fs.readFileSync(path.join(root, "scripts", "home.js"), "utf8");
const build = fs.readFileSync(path.join(root, "build", "index.html"), "utf8");
const buildScript = fs.readFileSync(path.join(root, "scripts", "build.js"), "utf8");
const kits = fs.readFileSync(path.join(root, "kits", "index.html"), "utf8");
const kitsScript = fs.readFileSync(path.join(root, "scripts", "kits.js"), "utf8");
const assembly = fs.readFileSync(path.join(root, "assembly", "index.html"), "utf8");
const assemblyScript = fs.readFileSync(path.join(root, "scripts", "assembly.js"), "utf8");
const policies = fs.readFileSync(path.join(root, "policies", "index.html"), "utf8");
const checkoutSuccess = fs.readFileSync(path.join(root, "checkout", "success", "index.html"), "utf8");
const styles = fs.readFileSync(path.join(root, "styles.css"), "utf8");
const versionedPages = [
  ["home", home],
  ["build", build],
  ["kits", kits],
  ["assembly", assembly],
  ["policies", policies],
  ["checkout-success", checkoutSuccess]
];
for (const [name, source] of versionedPages) {
  if (!/href="\/styles\.css\?v=[a-zA-Z0-9_-]+"/.test(source)) errors.push(`${name}: stylesheet URL is not deployment-versioned`);
  const scriptName = name === "checkout-success" ? "checkout-success" : name;
  if (!source.includes(`/scripts/${scriptName}.js?v=`)) errors.push(`${name}: site script URL is not deployment-versioned`);
}
if (!home.includes('id="gallery-section"') || !home.includes('id="inquiryForm"')) errors.push("Home structure is incomplete");
const getOneNavIndex = home.indexOf('href="/kits/">Get One</a>');
const howItWorksNavIndex = home.indexOf('href="/#how-it-works">How It Works</a>');
const assemblyNavIndex = home.indexOf('href="/assembly/">Instructions</a>');
if (
  getOneNavIndex < 0 ||
  howItWorksNavIndex < 0 ||
  assemblyNavIndex < 0 ||
  !(getOneNavIndex < howItWorksNavIndex && howItWorksNavIndex < assemblyNavIndex) ||
  home.includes('href="/">Home</a>')
) errors.push("Primary navigation labels or order are incorrect");
if (home.includes("__TURNSTILE_SITE_KEY__") || !home.includes("challenges.cloudflare.com/turnstile")) errors.push("Turnstile is not configured in the home page");
if (!homeScript.includes('fetch("/api/inquiries"') || !homeScript.includes('fetch("/api/gallery/submit"')) errors.push("Cloudflare form endpoints are not wired to the home page");
if (!home.includes('summary class="how-works-user-question"') || !homeScript.includes('how-works-user-question how-works-path-prompt') || !styles.includes('.how-works-copy-item > summary') || !styles.includes('.how-works-path-prompt.how-works-user-question')) errors.push("Home question-and-answer hierarchy is incomplete");
const galleryMatch = homeScript.match(/window\.INITIAL_GALLERY_ITEMS=(\[[^\n]*\]);/);
if (!galleryMatch) {
  errors.push("Static gallery snapshot is missing");
} else {
  try {
    const galleryItems = JSON.parse(galleryMatch[1]);
    if (galleryItems.length !== 9 || galleryItems.some((item) => !item.cover || !item.reveal)) {
      errors.push(`Static gallery snapshot is incomplete (${galleryItems.length} pairs)`);
    }
  } catch {
    errors.push("Static gallery snapshot is invalid JSON");
  }
}
const expectedDownloads = release.artifacts.map((artifact) => artifact.name);
if (
  !build.includes('id="downloadsList"') ||
  !build.includes('id="design-release"') ||
  !build.includes(`Current design release ${release.version}`) ||
  !build.includes(`Release notes — ${release.version}`) ||
  !build.includes('id="self-print-next"') ||
  (build.match(/class="download-row download-row-primary"/g) || []).length !== 2 ||
  (build.match(/class="download-source-group"/g) || []).length !== 1 ||
  (build.match(/<a class="download-row"[^>]*\.scad/g) || []).length !== 7 ||
  !build.includes('7 files for modifying the design') ||
  expectedDownloads.some((name) => !build.includes(name))
) errors.push("Self-Print route or download set is incomplete");
if (build.includes("gel super glue")) errors.push("Removed super-glue preparation copy remains in Self-Print");
if (/\bstl\b|\.stl(?:[?"'#]|$)/i.test(build) || files.some((file) => /\.stl$/i.test(file))) {
  errors.push("STL files or references remain in the public build");
}
if (build.includes('/make-5x7/') || build.includes('id="setup-inventory"')) errors.push("Shared preparation content leaked into Self-Print");
if (!buildScript.includes("positionTermHelpPopover") || !buildScript.includes("scheduleTermHelpOpen") || !buildScript.includes("TERM_HELP_OPEN_DELAY_MS") || !buildScript.includes('termHelpLastPointerType !== "touch"') || !styles.includes(".term-help-popover") || !styles.includes("position: fixed")) errors.push("Hybrid hover-and-touch tooltip behavior or positioning is missing");
if (!kits.includes("Choose how much of the build you want to do") || kitsScript.includes("kit-selector-facts") || !kitsScript.includes("createOfferingInquiryHref")) errors.push("Streamlined offering selector or inquiry actions are incorrect");
if (!kitsScript.includes("createGiftTimingOptions") || !kitsScript.includes("countdownRequest") || !kitsScript.includes("startMode")) errors.push("Finished Gift timer setup is missing");
if (!kitsScript.includes("Usually ships in 1–2 business days.") || !kitsScript.includes("Usually ships in 3–5 business days.") || !kitsScript.includes("Usually ships in 5–7 business days.")) errors.push("Offering preparation times are missing");
if (!policies.includes("30 calendar days") || !policies.includes("Personalized products") || !policies.includes("Damaged, defective, or incorrect orders")) errors.push("Shipping and return policy is incomplete");
if (!kitsScript.includes("Choose your colors") || !kitsScript.includes("Mix & match stocked colors") || !styles.includes(".color-pairing-list")) errors.push("Color configurator is missing");
if (!home.includes('id="inquiryColorMode"') || !homeScript.includes("getHomeInquiryColorSelection")) errors.push("Inquiry color handoff is missing");
if (!kitsScript.includes("window.STRIPE_CHECKOUT_MODE=\"off\"") || !kitsScript.includes('fetch("/api/checkout"') || kitsScript.includes("Try test checkout") || !kitsScript.includes('"Checkout"') || !kitsScript.includes("!checkoutAvailable && primary")) errors.push("Mode-gated Stripe Checkout or its live actions are incorrect");
if (!kitsScript.includes("Get 3D Print Files")) errors.push("Hardware Bundle self-print action is unclear");
if (!assembly.includes('id="prepare-images"') || !assembly.includes('/make-5x7/') || !assembly.includes('id="setup-inventory"') || !assembly.includes('id="assemblyGuide"')) errors.push("Shared preparation and assembly flow is incomplete");
if (!assembly.includes("3D-printing your own parts?") || !assembly.includes('href="/build/#plans"') || !assembly.includes("Get 3D Print Files")) errors.push("Assembly self-print route is missing");
if (assembly.includes('id="assembly-tools"') || !assembly.includes('class="term-help assembly-threading-help"') || !assembly.includes("Tweezers are strongly recommended for guiding the string through tight spots")) errors.push("Assembly threading help is not streamlined correctly");
if (/\.assembly-viewer-top\s*\{[^}]*position:\s*sticky/s.test(styles)) errors.push("Assembly navigation can overlap instruction images");
if (!assembly.includes('<details class="inventory-disclosure">') || assembly.includes('<details class="inventory-disclosure" open') || !assembly.includes('check that you have everything')) errors.push("Parts inventory is not a closed preflight disclosure");
if (!assembly.includes('class="make-5x7-inline-link"') || !assemblyScript.includes('setLinkedMake5x7Text') || !kitsScript.includes('setLinkedMake5x7Text(description, option.description)') || !kitsScript.includes('make5x7: "/make-5x7/"')) errors.push("Make 5x7 references are not consistently linked");
if (!assembly.includes("Capstan x2") || !assembly.includes('<h3>Weight Rig</h3>') || !assembly.includes('class="inventory-name">Weight</div>') || !assembly.includes('class="inventory-name">Brad Pin</div>')) errors.push("Parts reference is incomplete");
if (assembly.includes("Cotton String") || assembly.includes("Flat Birch Stick") || assembly.includes("Adhesive Steel Weights")) errors.push("Obsolete Weight Rig inventory items remain");
if (!buildScript.includes("Gallardo Tire Products | FN-Series Zinc Clip on Wheel Weights 25 Grams.") || !buildScript.includes("25 g (0.88 oz)") || !buildScript.includes("approximately 40 x 12 x 6.5 mm") || !buildScript.includes("open eyelet that accepts the brad pin")) errors.push("FN wheel-weight sourcing details are incomplete");
if (buildScript.includes('item":"Cotton String"') || buildScript.includes('item":"Flat Birch Stick') || buildScript.includes('item":"Adhesive Steel Weights"')) errors.push("Obsolete weight-rig sourcing items remain");
if (/QR Sticker|qr-sticker\.png/i.test(assembly)) errors.push("QR sticker remains in the parts inventory");
if (assembly.includes("Tuck the stem of the weight")) errors.push("Removed assembly reference content remains");
if (/Build the Five-Weight Rig|Tie the Rig to the Cover Image|Place Latch and Keeper in Rig|Place the Tied Weight Rig/.test(assemblyScript)) errors.push("Removed weight-system assembly steps remain");
const requiredWeightAssemblySteps = [
  ["Insert the Brad Pin into the Weight", "03-insert-brad-pin-into-weight.png"],
  ["Seat the Weight in the Latch", "04-seat-weight-in-latch.png"],
  ["Secure the Latch", "05-secure-and-swing-latch.png"],
  ["Lock the Latch with the Zipper", "06-slide-zipper-under-latch.png"],
  ["Fasten the Cover Image to the Weight", "07-fasten-cover-image-to-weight.png"]
];
for (const [title, image] of requiredWeightAssemblySteps) {
  if (!assemblyScript.includes(title) || !assemblyScript.includes(image)) errors.push(`Weight-system assembly step is missing: ${title}`);
}

const requiredBackendFiles = [
  "cloudflare/api-helpers.js",
  "cloudflare/color-options.js",
  "functions/api/inquiries.js",
  "functions/api/checkout.js",
  "functions/api/stripe/webhook.js",
  "functions/api/gallery.js",
  "functions/api/gallery/submit.js",
  "functions/api/gallery/image/[[path]].js",
  "migrations/0001_initial.sql",
  "migrations/0002_color_options_and_orders.sql",
  "migrations/0003_gift_timing.sql"
];
for (const file of requiredBackendFiles) {
  if (!fs.existsSync(path.join(root, "..", file))) errors.push(`Missing backend file: ${file}`);
}

const forbiddenOutput = ["Code.js", ".clasp.json", "appsscript.json", "HANDOFF.md"];
for (const name of forbiddenOutput) {
  if (files.some((file) => path.basename(file) === name)) errors.push(`Server/source file leaked into dist: ${name}`);
}

if (errors.length) {
  console.error("Cloudflare validation failed:");
  errors.forEach((error) => console.error(`- ${error}`));
  process.exitCode = 1;
} else {
  console.log(`Cloudflare validation passed (${files.length} files).`);
}
