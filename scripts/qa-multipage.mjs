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
const baseUrl = (process.env.PREVIEW_URL || "http://127.0.0.1:4173").replace(/\/+$/, "");
const deploymentId = process.env.EXPECTED_DEPLOYMENT_ID || "";

const browser = await chromium.launch({
  executablePath: edgePath,
  headless: true,
  args: ["--no-sandbox", "--disable-gpu"]
});

const results = [];

function routeUrl(name, suffix = "") {
  return `${baseUrl}?page=${encodeURIComponent(name)}${suffix}`;
}

async function findContentFrame(page) {
  if (!deploymentId) return page;
  const deadline = Date.now() + 30000;
  while (Date.now() < deadline) {
    for (const frame of page.frames()) {
      if (frame === page.mainFrame()) continue;
      if (await frame.locator("#app").count()) return frame;
    }
    await page.waitForTimeout(250);
  }
  throw new Error("Apps Script content frame did not render #app");
}

function createSurface(page, frame) {
  if (frame === page) return page;
  return {
    locator: frame.locator.bind(frame),
    evaluate: frame.evaluate.bind(frame),
    waitForFunction: frame.waitForFunction.bind(frame),
    waitForTimeout: page.waitForTimeout.bind(page),
    keyboard: page.keyboard,
    screenshot: page.screenshot.bind(page),
    close: page.close.bind(page)
  };
}

async function openPage(name, viewport, suffix = "") {
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
  const response = await page.goto(routeUrl(name, suffix), {
    waitUntil: "domcontentloaded",
    timeout: 60000
  });
  const contentFrame = await findContentFrame(page);
  await page.waitForTimeout(1000);
  return {
    page: createSurface(page, contentFrame),
    errors,
    status: response ? response.status() : null
  };
}

async function inspectClientBundle(page, name) {
  const inlineScripts = await page.locator("script:not([src])").evaluateAll((scripts) => (
    scripts.map((script) => script.textContent || "").filter(Boolean)
  ));
  const firstPartyScripts = inlineScripts.filter((source) => (
    source.includes("window.PAGE_KEY") || source.includes("function textOrEmpty")
  ));
  const parseErrors = [];
  firstPartyScripts.forEach((source, index) => {
    try {
      new Function(source);
    } catch (error) {
      parseErrors.push(`inline script ${index + 1}: ${error.message}`);
    }
  });

  const clientSource = firstPartyScripts.find((source) => source.includes("function textOrEmpty")) || "";
  const routeSentinels = {
    home: {
      raw: "if (cursor < text.length)",
      encoded: "if (cursor &lt; text.length)"
    },
    build: {
      raw: "function hydrateBuildCopy()",
      encoded: "function hydrateBuildCopy()"
    },
    kits: {
      raw: "'<svg viewBox=",
      encoded: "'&lt;svg viewBox="
    },
    assembly: {
      raw: "if (cursor < value.length)",
      encoded: "if (cursor &lt; value.length)"
    }
  };
  const sentinel = routeSentinels[name];
  const escapeHtmlResult = await page.evaluate(() => (
    typeof escapeHtml === "function" ? escapeHtml("<>&\"'") : null
  ));
  const sharedEntitiesIntact = (
    clientSource.includes('"&": "&amp;"') &&
    clientSource.includes('"<": "&lt;"') &&
    clientSource.includes('">": "&gt;"') &&
    !clientSource.includes('"&amp;": "&amp;amp;"')
  );

  return {
    firstPartyScriptCount: firstPartyScripts.length,
    parseErrors,
    rawSentinelPresent: clientSource.includes(sentinel.raw),
    encodedSentinelAbsent: sentinel.encoded === sentinel.raw || !clientSource.includes(sentinel.encoded),
    sharedEntitiesIntact,
    escapeHtmlResult
  };
}

async function inspectSharedShell(page) {
  const shell = await page.evaluate(() => ({
    footerText: document.querySelector(".footer")?.textContent.trim() || "",
    navHrefs: Array.from(document.querySelectorAll(".site-nav a[href]"), (link) => link.href)
  }));
  const expectedPages = new Set(["home", "build", "kits", "assembly"]);
  const linkedPages = new Set();
  let linksStayOnDeployment = true;

  shell.navHrefs.forEach((href) => {
    const parsed = new URL(href);
    const pageKey = parsed.searchParams.get("page");
    if (pageKey) linkedPages.add(pageKey);
    if (deploymentId && !href.includes(`/s/${deploymentId}/exec`)) {
      linksStayOnDeployment = false;
    }
  });

  return {
    footerRendered: shell.footerText.includes("Double Take Frames") &&
      shell.footerText.includes("send a note through the form"),
    requiredRoutesLinked: Array.from(expectedPages).every((pageKey) => linkedPages.has(pageKey)),
    linksStayOnDeployment
  };
}

async function assertPage(name, requiredSelectors, forbiddenSelectors) {
  const { page, errors, status } = await openPage(name, { width: 1440, height: 1000 });
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
  const bundle = await inspectClientBundle(page, name);
  const shell = await inspectSharedShell(page);
  const screenshot = path.join(screenshotDir, `${name}-desktop.png`);
  await page.screenshot({ path: screenshot, fullPage: false });
  results.push({
    name,
    status,
    missing,
    leaked,
    errors,
    horizontalOverflow,
    bundle,
    shell,
    screenshot
  });
  return page;
}

const home = await assertPage(
  "home",
  ["h1", "#how-it-works", "#gallery-section", "#choose-path", "#inquiryForm"],
  ["#assemblyGuide", "#pricingTiers"]
);
const homeHeroReady = await home.waitForFunction(() => (
  !document.getElementById("heroGallery")?.hidden &&
  document.querySelectorAll(".hero-gallery-preview").length > 0
), null, { timeout: 30000 }).then(() => true).catch(() => false);
const homeHeroDiagnostics = await home.evaluate(() => ({
  initialGalleryCount: Array.isArray(window.INITIAL_GALLERY_ITEMS)
    ? window.INITIAL_GALLERY_ITEMS.length
    : null,
  normalizedGalleryCount: typeof normalizeHomeGallery === "function"
    ? normalizeHomeGallery(window.INITIAL_GALLERY_ITEMS).length
    : null,
  heroHidden: document.getElementById("heroGallery")?.hidden,
  heroPreviewCount: document.querySelectorAll(".hero-gallery-preview").length,
  staticGalleryControlCount: document.querySelectorAll(".server-gallery-toggle").length,
  startHomePageType: typeof startHomePage,
  renderHomeHeroType: typeof renderHomeHero
}));
const homeHeroVisible = homeHeroReady &&
  await home.locator("#heroGallery .hero-feature-button").isVisible();
const homeHeroImagesLoaded = homeHeroReady
  ? await home.waitForFunction(() => {
    const images = Array.from(document.querySelectorAll("#heroGalleryFeature img"));
    return images.length >= 2 && images.every((image) => image.complete && image.naturalWidth > 0);
  }, null, { timeout: 30000 }).then(() => true).catch(() => false)
  : false;
const readHeroState = () => home.evaluate(() => {
  const items = Array.from(document.querySelectorAll(".hero-gallery-preview"));
  const activeIndex = items.findIndex((item) => item.classList.contains("is-active"));
  const reveal = document.querySelector("#heroGalleryFeature .reveal-img");
  const state = reveal && getComputedStyle(reveal).display !== "none" ? "reveal" : "cover";
  return `${activeIndex}:${state}`;
});
const heroStateBefore = homeHeroReady ? await readHeroState() : null;
const heroStateDuring = homeHeroReady
  ? await home.waitForFunction((initialState) => {
    const items = Array.from(document.querySelectorAll(".hero-gallery-preview"));
    const activeIndex = items.findIndex((item) => item.classList.contains("is-active"));
    const reveal = document.querySelector("#heroGalleryFeature .reveal-img");
    const state = reveal && getComputedStyle(reveal).display !== "none" ? "reveal" : "cover";
    return `${activeIndex}:${state}` !== initialState
      ? `${activeIndex}:${state}`
      : false;
  }, heroStateBefore, { timeout: 10000 }).then((handle) => handle.jsonValue()).catch(() => null)
  : null;
const heroStateAfter = heroStateDuring
  ? await home.waitForFunction((previousState) => {
    const items = Array.from(document.querySelectorAll(".hero-gallery-preview"));
    const activeIndex = items.findIndex((item) => item.classList.contains("is-active"));
    const reveal = document.querySelector("#heroGalleryFeature .reveal-img");
    const state = reveal && getComputedStyle(reveal).display !== "none" ? "reveal" : "cover";
    return `${activeIndex}:${state}` !== previousState
      ? `${activeIndex}:${state}`
      : false;
  }, heroStateDuring, { timeout: 10000 }).then((handle) => handle.jsonValue()).catch(() => null)
  : null;
const homeHeroCycles = (
  homeHeroReady &&
  heroStateBefore !== heroStateDuring &&
  heroStateDuring !== heroStateAfter &&
  heroStateAfter != null
);

let homeRevealVisible = false;
const homeGalleryToggleAttempts = [];
for (let attempt = 0; attempt < 4 && !homeRevealVisible; attempt += 1) {
  const galleryControl = home.locator("#gallery .gallery-frame-button").first();
  const controlHandle = await galleryControl.elementHandle();
  if (!controlHandle) break;
  await controlHandle.click();
  await home.waitForTimeout(700);
  const state = await controlHandle.evaluate((control) => {
    const cover = control.querySelector(".cover-img");
    const reveal = control.querySelector(".reveal-img");
    return {
      connected: control.isConnected,
      bound: control.dataset.galleryBound,
      coverDisplay: cover && cover.style.display,
      revealDisplay: reveal && reveal.style.display
    };
  });
  homeGalleryToggleAttempts.push(state);
  homeRevealVisible = (
    state.connected &&
    state.coverDisplay === "none" &&
    state.revealDisplay === "block"
  );
  if (!homeRevealVisible) await home.waitForTimeout(1500);
}

await home.locator("#inquiryType").selectOption({ label: "Feedback" });
const feedbackFields = await home.evaluate(() => ({
  kitHidden: document.getElementById("inquiryKit").closest(".inquiry-field").hidden,
  timelineHidden: document.getElementById("inquiryTimeline").closest(".inquiry-field").hidden
}));
await home.locator("#inquiryType").selectOption({ label: "Custom finished-frame inquiry" });
const customFields = await home.evaluate(() => ({
  kitHidden: document.getElementById("inquiryKit").closest(".inquiry-field").hidden,
  timelineHidden: document.getElementById("inquiryTimeline").closest(".inquiry-field").hidden
}));
await home.locator("#inquiryType").selectOption({ label: "Order or availability" });
const kitFields = await home.evaluate(() => ({
  kitHidden: document.getElementById("inquiryKit").closest(".inquiry-field").hidden,
  timelineHidden: document.getElementById("inquiryTimeline").closest(".inquiry-field").hidden
}));
const homeInquiryConditionals = (
  feedbackFields.kitHidden &&
  feedbackFields.timelineHidden &&
  customFields.kitHidden &&
  !customFields.timelineHidden &&
  !kitFields.kitHidden &&
  !kitFields.timelineHidden
);
results.push({
  interaction: "home",
  homeHeroReady,
  homeHeroDiagnostics,
  homeHeroVisible,
  homeHeroImagesLoaded,
  homeHeroCycles,
  heroStateBefore,
  heroStateDuring,
  heroStateAfter,
  homeRevealVisible,
  homeGalleryToggleAttempts,
  homeInquiryConditionals
});
await home.screenshot({
  path: path.join(screenshotDir, "home-desktop.png"),
  fullPage: false
});
await home.close();

const build = await assertPage(
  "build",
  ["h1", "#build-print", "#build-images", "#build-hardware", "#build-tools", "#setup-inventory"],
  ["#assemblyGuide", "#gallery-section", "#pricingTiers"]
);
const buildTooltip = build.locator("[data-term-help-trigger]").first();
await buildTooltip.click();
const buildTooltipVisible = (
  await buildTooltip.getAttribute("aria-expanded") === "true" &&
  await build.locator(`#${await buildTooltip.getAttribute("aria-controls")}`).isVisible()
);
await build.keyboard.press("Escape");
await build.locator("#build-print [data-support-guide-trigger]").click();
const buildModalVisible = await build.locator("#supportGuideModal").isVisible();
await build.locator("[data-support-guide-close='button']").click();
results.push({ interaction: "build", buildTooltipVisible, buildModalVisible });
await build.close();

const kits = await assertPage(
  "kits",
  ["h1", ".launch-pricing-note", "#pricingTiers", ".kit-selector-row", ".tier-active-card", ".image-prep-options"],
  ["#assemblyGuide", "#gallery-section", "#pricingTiers del", "#pricingTiers s"]
);
const kitsLaunchNote = await kits.locator(".launch-pricing-note").innerText();
const kitsMakerBasePrice = await kits.locator("[data-tier-total-price]").innerText();
await kits.locator('input[value="print-cut"]').check();
const kitsMakerPreparedPrice = await kits.locator("[data-tier-total-price]").innerText();
await kits.locator('.kit-selector-row[data-tier-index="1"]').click();
await kits.waitForTimeout(600);
const kitsBuilderPreparedPrice = await kits.locator("[data-tier-total-price]").innerText();
await kits.locator('.kit-selector-row[data-tier-index="2"]').click();
await kits.waitForTimeout(600);
const kitsGiftPrice = await kits.locator("[data-tier-total-price]").innerText();
results.push({
  interaction: "kits",
  kitsLaunchNote,
  kitsMakerBasePrice,
  kitsMakerPreparedPrice,
  kitsBuilderPreparedPrice,
  kitsGiftPrice
});
await kits.close();

const { page: kitsDeepLink, errors: kitsDeepLinkErrors } = await openPage(
  "kits",
  { width: 1440, height: 1000 },
  "&tier=builder#kits"
);
const deepLinkTab = kitsDeepLink.locator('.kit-selector-row[data-tier-index="1"]');
const kitsDeepLinkState = await kitsDeepLink.evaluate(() => ({
  initialTier: window.INITIAL_TIER,
  search: window.location.search
}));
const kitsDeepLinkWorks = (
  await deepLinkTab.getAttribute("aria-selected") === "true" &&
  await kitsDeepLink.locator("[data-tier-total-price]").innerText() === "$45"
);
results.push({
  interaction: "kits-deep-link",
  kitsDeepLinkWorks,
  kitsDeepLinkState,
  errors: kitsDeepLinkErrors
});
await kitsDeepLink.close();

const assembly = await assertPage(
  "assembly",
  ["h1", "#assembly-tools", "#assemblyGuide", "[data-assembly-viewer]", "#faq"],
  ["#gallery-section", "#pricingTiers"]
);
const assemblyProgressBefore = await assembly.locator("[data-assembly-progress]").innerText();
await assembly.locator("[data-assembly-next]").click();
const assemblyProgressAfter = await assembly.locator("[data-assembly-progress]").innerText();

const assemblyToolsDisclosure = assembly.locator(".assembly-primer").first();
await assemblyToolsDisclosure.locator("summary").click();
const assemblyToolsDisclosureWorks = await assemblyToolsDisclosure.evaluate((node) => node.open);
await assemblyToolsDisclosure.locator("[data-support-guide-trigger]").click();
const assemblyModalVisible = await assembly.locator("#supportGuideModal").isVisible();
await assembly.locator("[data-support-guide-close='button']").click();

const assemblyMechanismDisclosure = assembly.locator(".assembly-primer").nth(1);
await assemblyMechanismDisclosure.locator("summary").click();
const assemblyMechanismDisclosureWorks = await assemblyMechanismDisclosure.evaluate((node) => node.open);
const assemblyTooltip = assemblyMechanismDisclosure.locator("[data-term-help-trigger]").first();
await assemblyTooltip.click();
const assemblyTooltipVisible = (
  await assemblyTooltip.getAttribute("aria-expanded") === "true" &&
  await assembly.locator(`#${await assemblyTooltip.getAttribute("aria-controls")}`).isVisible()
);
await assembly.keyboard.press("Escape");

const assemblyFaq = assembly.locator(".faq-item").first();
await assemblyFaq.locator("summary").click();
const assemblyFaqDisclosureWorks = await assemblyFaq.evaluate((node) => node.open);
results.push({
  interaction: "assembly",
  assemblyProgressBefore,
  assemblyProgressAfter,
  assemblyToolsDisclosureWorks,
  assemblyMechanismDisclosureWorks,
  assemblyFaqDisclosureWorks,
  assemblyTooltipVisible,
  assemblyModalVisible
});
await assembly.close();

let kitsMobilePricing = null;
for (const name of ["home", "build", "kits", "assembly"]) {
  const { page, errors, status } = await openPage(name, { width: 390, height: 844 });
  const horizontalOverflow = await page.evaluate(() => (
    document.documentElement.scrollWidth > document.documentElement.clientWidth + 1
  ));
  if (name === "kits") {
    const noteVisible = await page.locator(".launch-pricing-note").isVisible();
    const makerBase = await page.locator("[data-tier-total-price]").innerText();
    await page.locator('input[value="print-cut"]').check();
    const makerPrepared = await page.locator("[data-tier-total-price]").innerText();
    await page.locator('.kit-selector-row[data-tier-index="1"]').click();
    await page.waitForTimeout(600);
    const builderPrepared = await page.locator("[data-tier-total-price]").innerText();
    await page.locator('.kit-selector-row[data-tier-index="2"]').click();
    await page.waitForTimeout(600);
    const gift = await page.locator("[data-tier-total-price]").innerText();
    kitsMobilePricing = {
      noteVisible,
      makerBase,
      makerPrepared,
      builderPrepared,
      gift
    };
  }
  const screenshot = path.join(screenshotDir, `${name}-mobile.png`);
  await page.screenshot({ path: screenshot, fullPage: false });
  results.push({
    name: `${name}-mobile`,
    status,
    errors,
    horizontalOverflow,
    pricing: name === "kits" ? kitsMobilePricing : undefined,
    screenshot
  });
  await page.close();
}

await browser.close();
console.log(JSON.stringify(results, null, 2));

const pageFailures = results.filter((result) => (
  result.horizontalOverflow ||
  (result.status && result.status !== 200) ||
  (result.missing && result.missing.length) ||
  (result.leaked && result.leaked.length) ||
  (result.errors && result.errors.length) ||
  (result.bundle && (
    result.bundle.firstPartyScriptCount < 2 ||
    result.bundle.parseErrors.length ||
    !result.bundle.rawSentinelPresent ||
    !result.bundle.encodedSentinelAbsent ||
    !result.bundle.sharedEntitiesIntact ||
    result.bundle.escapeHtmlResult !== "&lt;&gt;&amp;&quot;&#39;"
  )) ||
  (result.shell && (
    !result.shell.footerRendered ||
    !result.shell.requiredRoutesLinked ||
    !result.shell.linksStayOnDeployment
  ))
));

if (
  pageFailures.length ||
  !homeHeroVisible ||
  !homeHeroImagesLoaded ||
  !homeHeroCycles ||
  !homeRevealVisible ||
  !homeInquiryConditionals ||
  !buildTooltipVisible ||
  !buildModalVisible ||
  kitsLaunchNote !== "Launch pricing for the first production run; prices may change as materials and capacity settle." ||
  kitsMakerBasePrice !== "$25" ||
  kitsMakerPreparedPrice !== "$35" ||
  kitsBuilderPreparedPrice !== "$55" ||
  kitsGiftPrice !== "$80" ||
  !kitsDeepLinkWorks ||
  !kitsMobilePricing ||
  !kitsMobilePricing.noteVisible ||
  kitsMobilePricing.makerBase !== "$25" ||
  kitsMobilePricing.makerPrepared !== "$35" ||
  kitsMobilePricing.builderPrepared !== "$55" ||
  kitsMobilePricing.gift !== "$80" ||
  assemblyProgressBefore === assemblyProgressAfter ||
  !assemblyToolsDisclosureWorks ||
  !assemblyMechanismDisclosureWorks ||
  !assemblyFaqDisclosureWorks ||
  !assemblyTooltipVisible ||
  !assemblyModalVisible
) {
  process.exitCode = 1;
}
