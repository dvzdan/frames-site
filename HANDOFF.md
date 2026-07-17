# Frames Site Handoff

Last updated: 2026-07-16

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
  `@185 - generalize early production status copy retry`
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

As of this handoff, `git status --short --branch` showed intentional deployed work not yet committed:

```text
## main...origin/main
 M AssemblyData.html
 M Client.html
 M Code.js
 M Config.html
 M Index.html
 M Styles.html
?? HANDOFF.md
?? "docs/Assembly preamble.docx"
?? docs/FAQ.docx
?? "docs/How it works.docx"
?? docs/custom-gpt-instructions.md
?? docs/customer-facing-knowledge.md
```

These changes should be committed together unless the user says otherwise. They represent the current live site state plus docs.

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
- No payment is collected on the site.
- Visitors should use the request form for quotes, questions, feedback, testing, or collaboration.
- Requests are handled directly; each request is reviewed before quote/timing is provided.

## Current Kit Paths

Maker Kit:

- $45
- Customer 3D prints frame and stand, assembles mechanism, loads image pair.
- Includes hardware kit, assembly supplies, two custom prints, digital frame/stand files.

Builder Kit:

- $70
- Customer assembles mechanism and loads image pair.
- Includes 3D printed frame and stand, hardware kit, two custom prints, assembly supplies.

Finished Gift:

- $160
- Completed frame, images loaded/tested, ready to display or gift.
- Customer may remove battery pull tab to begin countdown, or receive with countdown already underway.

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

