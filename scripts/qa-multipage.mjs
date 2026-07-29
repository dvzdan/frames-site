import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const playwrightPath = path.join(
  os.tmpdir(),
  "frames-site-pw",
  "node_modules",
  "playwright-core",
  "index.mjs"
);
const { chromium } = await import(pathToFileURL(playwrightPath).href);
const edgePath = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe";
const screenshotDir = path.join(os.tmpdir(), "frames-site-qa");
const baseUrl = process.env.PREVIEW_URL || "http://127.0.0.1:4173";

const browser = await chromium.launch({
  executablePath: edgePath,
  headless: true,
  args: ["--no-sandbox", "--disable-gpu"]
});

const results = [];

async function openPage(name, viewport) {
  const page = await browser.newPage({ viewport });
  const errors = [];
  await page.route("**/*", (route) => {
    if (route.request().resourceType() === "font") {
      route.abort();
      return;
    }
    route.continue();
  });
  page.on("pageerror", (error) => errors.push(error.message));
  page.on("console", (message) => {
    if (message.type() === "error") errors.push(message.text());
  });
  await page.goto(`${baseUrl}/?page=${name}`, { waitUntil: "domcontentloaded" });
  await page.waitForTimeout(700);
  return { page, errors };
}

async function assertPage(name, requiredSelectors, forbiddenSelectors) {
  const { page, errors } = await openPage(name, { width: 1440, height: 1000 });
  const missing = [];
  for (const selector of requiredSelectors) {
    if (await page.locator(selector).count() === 0) missing.push(selector);
  }
  const leaked = [];
  for (const selector of forbiddenSelectors) {
    if (await page.locator(selector).count() > 0) leaked.push(selector);
  }
  const horizontalOverflow = await page.evaluate(() => (
    document.documentElement.scrollWidth > document.documentElement.clientWidth + 1
  ));
  const screenshot = path.join(screenshotDir, `${name}-desktop.png`);
  await page.screenshot({ path: screenshot, fullPage: false });
  results.push({ name, missing, leaked, errors, horizontalOverflow, screenshot });
  return page;
}

const home = await assertPage(
  "home",
  ["h1", "#how-it-works", "#gallery-section", "#choose-path", "#inquiryForm"],
  ["#assemblyGuide", "#pricingTiers"]
);
await home.locator(".server-gallery-toggle").click();
await home.waitForTimeout(320);
const homeRevealVisible = await home.locator(".server-gallery-toggle .reveal-img").isVisible();
await home.locator("#inquiryType").selectOption({ label: "Feedback" });
const homeKitHidden = await home.locator("#inquiryKit").evaluate((node) => node.closest(".inquiry-field").hidden);
results.push({ interaction: "home", homeRevealVisible, homeKitHidden });
await home.close();

const build = await assertPage(
  "build",
  ["h1", "#build-print", "#build-images", "#build-hardware", "#build-tools", "#setup-inventory"],
  ["#assemblyGuide", "#gallery-section", "#pricingTiers"]
);
await build.locator("#build-print [data-support-guide-trigger]").click();
const buildModalVisible = await build.locator("#supportGuideModal").isVisible();
await build.locator("[data-support-guide-close='button']").click();
results.push({ interaction: "build", buildModalVisible });
await build.close();

const kits = await assertPage(
  "kits",
  ["h1", "#pricingTiers", ".kit-selector-row", ".tier-active-card", ".image-prep-options"],
  ["#assemblyGuide", "#gallery-section"]
);
const kitsBasePrice = await kits.locator("[data-tier-total-price]").innerText();
await kits.locator('input[value="print-cut"]').check();
const kitsPreparedPrice = await kits.locator("[data-tier-total-price]").innerText();
await kits.locator('.kit-selector-row[data-tier-index="1"]').click();
await kits.waitForTimeout(320);
const kitsAssemblyPrice = await kits.locator("[data-tier-total-price]").innerText();
results.push({ interaction: "kits", kitsBasePrice, kitsPreparedPrice, kitsAssemblyPrice });
await kits.close();

const assembly = await assertPage(
  "assembly",
  ["h1", "#assembly-tools", "#assemblyGuide", "[data-assembly-viewer]", "#faq"],
  ["#gallery-section", "#pricingTiers"]
);
const assemblyProgressBefore = await assembly.locator("[data-assembly-progress]").innerText();
await assembly.locator("[data-assembly-next]").click();
const assemblyProgressAfter = await assembly.locator("[data-assembly-progress]").innerText();
results.push({ interaction: "assembly", assemblyProgressBefore, assemblyProgressAfter });
await assembly.close();

for (const name of ["home", "build", "kits", "assembly"]) {
  const { page, errors } = await openPage(name, { width: 390, height: 844 });
  const horizontalOverflow = await page.evaluate(() => (
    document.documentElement.scrollWidth > document.documentElement.clientWidth + 1
  ));
  const screenshot = path.join(screenshotDir, `${name}-mobile.png`);
  await page.screenshot({ path: screenshot, fullPage: false });
  results.push({ name: `${name}-mobile`, errors, horizontalOverflow, screenshot });
  await page.close();
}

await browser.close();
console.log(JSON.stringify(results, null, 2));

const failures = results.filter((result) => (
  result.horizontalOverflow ||
  (result.missing && result.missing.length) ||
  (result.leaked && result.leaked.length) ||
  (result.errors && result.errors.length)
));
if (
  failures.length ||
  !homeRevealVisible ||
  !homeKitHidden ||
  !buildModalVisible ||
  kitsBasePrice !== "$45" ||
  kitsPreparedPrice !== "$55" ||
  kitsAssemblyPrice !== "$80" ||
  assemblyProgressBefore === assemblyProgressAfter
) {
  process.exitCode = 1;
}
