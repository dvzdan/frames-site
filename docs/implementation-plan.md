# Frames per Second Implementation Plan

## Guiding Principles

- Preserve existing upload/gallery behavior.
- Keep Apps Script compatibility.
- Use no frameworks and no build system.
- Prefer plain HTML partials, centralized configuration, and small functions.
- Keep live behavior stable while adding standard ecommerce structure.
- Add placeholders for unusual/custom systems without building full versions prematurely.
- Keep editing paths obvious for a non-programmer.

## Current Codebase

Current deployable files:

- `Code.js`: Apps Script backend, template include helper, Drive/Sheet upload and gallery functions.
- `Index.html`: page skeleton and section containers.
- `Config.html`: editable pricing data.
- `Styles.html`: CSS.
- `Client.html`: browser JavaScript for pricing rendering, uploads, gallery rendering, reveal toggle.
- `appsscript.json`: Apps Script manifest.

Existing functional systems to preserve:

- `submitConcept(data)`
- `getGallery()`
- browser `submitIdea()`
- browser `loadGallery()`
- browser `renderGallery(items)`
- click-to-toggle reveal behavior

## Phase 0: Documentation And Baseline

Status:

- Create `docs/website-spec.md`.
- Create `docs/implementation-plan.md`.
- Do not edit live site files.

Purpose:

- lock down product understanding
- define standard ecommerce structure
- distinguish immediate work from future custom/community systems

Files changed:

- `docs/website-spec.md`
- `docs/implementation-plan.md`

Validation:

- Confirm docs match product direction.
- Confirm no live site files changed.

## Phase 1: Centralized Editable Configuration

Goal:

- Expand `Config.html` into the main editable content source without changing visible behavior more than necessary.

Likely changes:

- Add `SITE_CONFIG`.
- Expand `PRICING_TIERS` with descriptions and included items.
- Add `REVEAL_TYPES` for Clock Reveal and Add-Water Reveal.
- Add placeholder arrays for FAQ, shipping notes, homepage copy, and checkout copy.

Files likely changed:

- `Config.html`
- `Client.html`
- `Index.html`

Risks:

- Moving copy from static markup to rendered config can accidentally change visible text.
- Apps Script template escaping can be confusing if server-side and client-side syntax are mixed.

Stability approach:

- Keep data as plain JavaScript constants.
- Render one section at a time.
- Verify section text after each step.

## Phase 2: Standard Ecommerce Page Sections

Goal:

- Add conventional product-ordering website structure while keeping the design restrained and simple.

Immediate sections:

- homepage hero
- product explanation
- how it works
- product type overview
- pricing/order section
- placeholder cart/order flow
- checkout placeholder
- shipping/returns/fine print
- FAQ
- upload form
- gallery/examples
- setup/how-to placeholder
- footer/contact

Files likely changed:

- `Index.html`
- `Styles.html`
- `Client.html`
- `Config.html`

Risks:

- Adding too many sections at once can make the page cluttered.
- Placeholder checkout must not look like real payment processing.
- New sections must not interfere with upload/gallery IDs or event handlers.

Stability approach:

- Keep existing upload form IDs unchanged:
  - `title`
  - `revealTitle`
  - `desc`
  - `cover`
  - `reveal`
  - `status`
  - `gallery`
- Preserve `submitIdea()`, `loadGallery()`, and `renderGallery()` behavior.
- Add new section containers with new IDs/classes.

## Phase 3: Simple Cart / Order Placeholder

Goal:

- Provide a standard ecommerce baseline without real checkout.

Immediate behavior:

- Select a product tier.
- Adjust quantity.
- Display subtotal.
- Show clear checkout placeholder/manual order message.

Do not build:

- real payment forms
- fake checkout completion
- real inventory management
- tax/shipping calculation unless actual business rules are known

Files likely changed:

- `Config.html`
- `Client.html`
- `Index.html`
- `Styles.html`

Risks:

- Users may mistake placeholder checkout for a real order flow.
- Pricing math can become scattered if not kept in config/helper functions.

Stability approach:

- Keep order state entirely client-side.
- Keep labels explicit: "Checkout placeholder" or "Contact to order" until real checkout exists.
- Store prices as numeric values plus display labels if calculations are needed.

## Phase 4: Product Variant Presentation

Goal:

- Make the site anticipate multiple reveal mechanisms without overengineering.

Immediate behavior:

- Render Clock Reveal and Add-Water Reveal cards from config.
- Include short descriptions and status labels.
- Avoid deep configurator behavior.

Files likely changed:

- `Config.html`
- `Client.html`
- `Index.html`
- `Styles.html`

Risks:

- Hardcoding pages around one product type could create rework later.
- Adding unavailable variants can look misleading if status is unclear.

Stability approach:

- Use neutral labels like "planned", "prototype", or "available" only when accurate.
- Keep mechanism descriptions short.

## Phase 5: Gallery / Community Preparation

Goal:

- Preserve the current gallery/upload subsystem while naming it as the seed of future community/examples behavior.

Immediate behavior:

- Keep concept upload form functional.
- Keep public gallery browsing.
- Add explanatory copy around examples/submissions if approved.

Do not build yet:

- accounts
- moderation
- comments
- likes
- remix tools
- share pages

Files likely changed:

- `Index.html`
- `Styles.html`
- `Client.html`
- possibly `Config.html`

Backend risks:

- Gallery load may slow as images accumulate because every image is converted to base64.
- A bad Drive URL can break gallery loading.
- Public anonymous submissions can create Drive/Sheet quota and abuse issues.

Stability approach:

- Do not change backend data format during this phase.
- Add error handling only if needed and tested.
- Keep future moderation as a documented placeholder, not a half-built system.

## Phase 6: Future Backend Hardening

Goal:

- Improve reliability without changing the user-facing model.

Possible improvements:

- Validate image data server-side.
- Add file-size guidance or limits.
- Store original file IDs separately from thumbnail URLs.
- Catch bad Drive file errors per gallery item.
- Consider pagination or limiting gallery rows.
- Move Drive/Sheet IDs into script properties if appropriate.

Files likely changed:

- `Code.js`
- possibly `Client.html`

Risks:

- Changing Sheet schema can break existing gallery rows.
- Apps Script quotas can be easy to hit with large galleries.

Stability approach:

- Treat Sheet schema changes as migrations.
- Preserve backward compatibility with existing rows.
- Test with existing submissions before deployment.

## Dependencies

Technical dependencies:

- Google Apps Script web app deployment
- Apps Script API enabled for `clasp push`
- Google Drive folder configured in `Code.js`
- Google Sheet configured in `Code.js`
- `google.script.run` available only in Apps Script-hosted page

No planned dependencies:

- no frontend framework
- no package manager
- no build step
- no external CSS framework
- no payment provider yet

## Risk Register

High-risk areas:

- Upload/gallery backend behavior
- Apps Script deployment/version confusion
- Drive/Sheet permissions and quotas
- Public anonymous write access
- Template include syntax
- Text escaping in gallery rendering

Medium-risk areas:

- Cart math once numeric pricing is added
- Maintaining hand-editability as sections grow
- Mobile layout after adding more sections
- Future product variant data shape

Low-risk areas:

- Static copy sections
- FAQ rendering
- footer/contact content
- simple product type cards

## Testing Checklist For Future Site Changes

After each implementation phase:

- Page loads in Apps Script deployment.
- No raw template tags are visible.
- Pricing tiers render from `Config.html`.
- Existing gallery loads.
- Missing gallery title falls back to `Untitled`.
- Missing reveal title and description render as empty strings.
- Gallery text does not contain literal `undefined`.
- Clicking gallery image toggles cover/reveal state.
- Description appears only after reveal.
- Upload without both images shows `Upload both images.`
- Upload with both images appends to the gallery.
- Mobile width remains readable.
- Placeholder checkout does not imply real payment processing.

## Immediate Recommended Next Step

After approving these docs, implement Phase 1 and Phase 2 in small commits/changes:

1. Expand `Config.html` with centralized site copy, tier descriptions, reveal types, FAQ, and placeholder checkout text.
2. Update `Index.html` with simple section containers.
3. Add render functions in `Client.html` for config-driven sections.
4. Extend `Styles.html` with organized section styles.
5. Preserve upload/gallery IDs and functions unchanged.

