# Frames Site Handoff

Last updated: 2026-07-19

## Project

- Local repo: `C:\Users\zack and lil\frames-site`
- GitHub remote: `https://github.com/dvzdan/frames-site.git`
- Apps Script script ID in `.clasp.json`: `1zsmZ8BOlnXM151Yo86FS7QH7dEDuUfervwLMZEq9eKsxUtgaWKqBf1cF`
- Spreadsheet used by the site: `https://docs.google.com/spreadsheets/d/1nS6mq8u5N3WhBiwoFTnbXBvKDUki-iM37vc5CQ-W7pM/edit`
- Sheet-driven copy tab: `Site CMS`
- Inquiry/contact sheet: `Inquiries`

## Deployment

- Use `clasp.cmd`, not `clasp.ps1`; PowerShell blocks `clasp.ps1`.
- User preference: after local Apps Script changes, push and deploy without requiring a separate prompt.
- Versioned live deployment:
  `AKfycbwijm7g7RhKLK_j8FuUiJ4b2m5rwxZIOy5-vHlcxt5USITIPswmaGeXN-UL2RAdBxg`
- Current verified live version:
  `@193 - revise site copy hierarchy`
- Deployment workflow:
  1. `clasp.cmd push`
  2. `clasp.cmd version "short description"`
  3. `clasp.cmd deploy -i AKfycbwijm7g7RhKLK_j8FuUiJ4b2m5rwxZIOy5-vHlcxt5USITIPswmaGeXN-UL2RAdBxg -V <version> -d "short description"`
  4. Verify the decoded Apps Script payload when practical, because Apps Script template escaping and deployment snapshots have caused stale/escaped output before.
- Existing `@HEAD` deployment:
  `https://script.google.com/macros/s/AKfycbzi1MYsoTPNaQLvu6W0__waglN5dGUkCcfmLjs8Pw/exec`
- Public/live versioned URL:
  `https://script.google.com/macros/s/AKfycbwijm7g7RhKLK_j8FuUiJ4b2m5rwxZIOy5-vHlcxt5USITIPswmaGeXN-UL2RAdBxg/exec`

## Current Git State

As of this handoff, `git status --short --branch` is clean against `origin/main` except for unrelated untracked generated-image draft folders:

```text
## main...origin/main
?? drafts/generated-images/candidates/gallery-pairs-v2/
?? drafts/generated-images/candidates/gallery-pairs/
```

Do not delete those draft folders unless the user asks; they predate the latest handoff update and are not part of the deployed site state.

Recent commits on `main`:

- `527aacd Add order image crop caveat`
- `bb51152 Remove kit prices from site`
- `2b83a60 Update live site messaging and docs`

## Recent Live Changes

- Restored damaged assembly PNGs and pinned image references to stable GitHub/CDN commits after cache/degradation issues.
- Fixed "How it works" mechanism image sizing so the center mechanism image matches the two surrounding image cards.
- Removed Setup Kit from the public kit paths, but kept setup/assembly instructions and inventory because they still apply to Maker, Builder, Finished Gift reset/setup, and future restoration.
- Added a colored full-mechanism reference image beside the assembly preamble mechanism list.
- Colored assembly mechanism terms:
  - `clock mechanism`: black
  - `clock/string guide`: purple
  - `capstan`: yellow
  - `string`: maroon
  - `eyelet`: yellow
  - `zipper`: pink
  - `latch`: dark blue
  - `weight`: green
  - `cover image`: white with outline
- Fixed a major Apps Script escaping bug where `<` became `&lt;` inside client JS and stopped the whole app from hydrating.
- Hardened startup hydration:
  - assembly guide renders from embedded manifest immediately
  - kit path selector renders immediately instead of waiting for tier illustration fetch
  - tier illustration fetch failure no longer leaves static fallback cards
- Replaced FAQ with content sourced from `docs/FAQ.docx` and wired FAQ into the `Site CMS` flow as collapsible accordion items.
- Added early small-batch release messaging and a direct request/quote form.
- Inquiry form writes to the `Inquiries` sheet and sends email notifications to `friedman.zack@gmail.com` via `MailApp`.
- Added the upload caveat in "Submit your own":
  `By submitting images, you agree that I may use AI or manual editing to anonymize faces and identifying details before sharing examples publicly.`
- Generalized the kit status note to:
  `Kit paths, pricing, and availability are preliminary while the project moves toward a more streamlined ordering process.`
- Removed public kit prices from the live kit cards. The renderer still supports `priceLabel` if prices are restored later, but current visible kit paths do not show dollar amounts.
- Added an order/request form caveat:
  `Images close to a 5x7 shape work best. Other proportions can usually be adapted, but leave extra room around anything important, especially near the edges, so the final crop still works in the frame.`
  This caveat is only in the ordering/request area, not the gallery submission module.
- Revised site copy/information hierarchy after the open-design/parts-kit refactor draft:
  - Hero sells the timed physical reveal, not free files or licensing.
  - Primary paths are `Build from scratch`, `Parts Kit`, and `Finished Gift`.
  - Design files and licensing are available after the product/options sections.
  - Parts-kit value is framed as tested compatible parts, pre-cut materials, and one-frame quantities.
  - Removed defensive margin/raw-bulk-cost language from visible site copy.
- Replaced the gallery reveal image for the `Trojan` / `Troy` item with `trojan party.png` from:
  `C:\Users\zack and lil\OneDrive\Documents\OpenSCAD\photo stuff`
  The live reveal image now uses Drive image ID `1Y6yk4mI9--aYN1zrzyg8bXJozmI0oAgM`.
- Created Custom GPT support docs:
  - `docs/custom-gpt-instructions.md`
  - `docs/customer-facing-knowledge.md`

## Important Implementation Notes

- `Config.html` is the main editable copy/config file for visible site content.
- `Code.js` contains Apps Script server functions, including:
  - gallery upload handling
  - gallery/image fetching
  - CMS sheet reading
  - inquiry form submission
  - inquiry email notification via `MailApp`
- `Client.html` handles client rendering/hydration, gallery behavior, FAQ rendering, kit selector, inquiry form binding, and upload form binding.
- `Index.html` contains static fallback markup and Apps Script includes; keep it aligned with dynamic rendering when changing visible first-load content.
- `Styles.html` contains all CSS.
- `AssemblyData.html` contains the assembly manifest and image base.
- `AssemblyClient.html` renders the step-by-step assembly guide.
- `Assets.html` is large and contains tier illustration base64 assets.

## Current Customer-Facing Positioning

- Product name: `Double Take Frames`
- Tagline: `One frame. Two takes.`
- The product is a physical photo reveal, not a screen.
- Current public status: early small-batch release.
- The mechanism works, but kit paths, pricing, and availability are preliminary.
- Public kit prices are currently hidden; quotes are handled directly through the request form.
- No payment is collected on the site.
- Visitors should use the request form for quotes, questions, feedback, testing, or collaboration.
- Requests are handled directly; each request is reviewed before quote/timing is provided.
- Order/request form image guidance: roughly 5x7 proportions are ideal, and important content should stay away from the margins when submitted images have different proportions.

## Current Kit Paths

Build from scratch:

- Customer uses the design files, sources hardware, prints image pair, and assembles the mechanism.
- Includes SCAD/STL/3MF design files, site assembly instructions, Make-5x7 tool, and parts list.

Parts Kit:

- Customer 3D prints frame and stand, assembles mechanism, prints/loads image pair.
- Includes tested compatible one-frame quantities: clock mechanism, specialty media, pre-cut acrylic/backing, UHMW tape, string/threading wire, zipper/latch/eyelets/C-clip/fasteners.

Finished Gift:

- Completed frame, images loaded/tested, ready to display or gift.
- Customer may remove battery pull tab to begin countdown, or receive with countdown already underway.

## Design Files And Parts List

Keep this subordinate in public copy: demonstrate the openness, do not lead with it.

- SCAD/STL/3MF design files are available from the site downloads section.
- License: CC BY-NC-SA 4.0 for personal, noncommercial use.
- Files are auto-listed on the site from the Drive folder `<gallery folder>/downloads`
  (child folder of `FOLDER_ID` in Code.js, created automatically on first render).
  Drop files in; the site lists them with size/date and a public download link.
- The `Source it yourself` table (`sections.parts` in Config.html) lists
  each hardware part with `link: ""` placeholders - fill in buy-yourself links there.
- Make-5x7 tool is served at `<exec url>?page=make5x7` from `Make5x7.html`
  (copied from `Documents/codex-scad-experiment/photo stuff/make 5x7.html`).
- Tiers are now: Build from scratch / Parts Kit (defaultActive) / Finished Gift.
- GitHub for design files deliberately deferred; Drive-first. Revisit if a remix
  community forms.

## Archived Maker/Builder Tiers

Replaced by Build from scratch + Parts Kit on 2026-07-19. Restore from git history
(`git log -- Config.html`, commit before that date) if needed. Key facts: Maker Kit
($45) = hardware kit + supplies + 2 custom prints + digital files, you print and
assemble; Builder Kit ($70) = printed frame/stand + hardware + prints, you assemble.

## Archived Setup Kit Tier

Keep this copy in case Setup Kit is restored later:

```js
{
  name: "Setup Kit",
  priceLabel: "$90",
  priceValue: 90,
  shortDescription: "Fully assembled. Final image loading and calibration required.",
  included: [
    "Assembled frame and mechanism",
    "Two custom prints on specialty media",
    "Reveal system aligned and tested"
  ],
  youDo: [
    "Load your image pair",
    "Set the timer"
  ],
  action: {
    label: "Setup Manual",
    href: "#setup-manual"
  },
  accentColor: "#9a7b4f",
  illustration: {
    type: "setup",
    assetKey: "setup",
    alt: "Framed symbolic setup layout for the Setup Kit"
  }
}
```

## CMS Copy

Sheet-driven copy is edited in Google Sheet tab `Site CMS`.

Columns:

```text
section | type | sort | heading | body | enabled | notes
```

Current CMS-driven areas:

- `how-it-works`
  - `primary`
  - `detail`
- `assembly`
  - `intro`
  - `sequence`
  - `checklist`
- `faq`
  - `item`

For assembly nested bullets, indent child lines in the sheet cell with spaces.

## Known Pitfalls

- Apps Script template output can rewrite certain raw characters in embedded scripts. A previous bug turned a JS `<` comparison into `&lt;`, causing `Unexpected token ';'` and preventing the app from hydrating.
- Verify deployed payloads by decoding `goog.script.init(...)` when the live site seems stale or broken.
- The deployment can sometimes serve an older version snapshot even after a version deploy. Creating and deploying another fresh version fixed that once (`@184` stale, `@185` correct).
- Headless Chrome diagnostics on this Windows machine can emit noisy CPU counter errors. If using Chrome for verification, close the diagnostic Chrome process tree afterward.
- Do not assume the old QR deployment URL belongs to the current `.clasp.json` script.
- Do not delete the `.docx` files in `docs/`; they are source/reference docs.

## Recommended Custom GPT Files

For a customer-facing Custom GPT, use:

- `docs/custom-gpt-instructions.md` as the instruction/personality source.
- `docs/customer-facing-knowledge.md` as primary knowledge.
- Optional knowledge uploads:
  - `docs/FAQ.docx`
  - `docs/How it works.docx`
  - `docs/Assembly preamble.docx`
  - `docs/website-spec.md`

Avoid uploading raw source code unless the GPT is meant to help maintain the site.
