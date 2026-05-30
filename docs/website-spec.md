# Frames per Second Website Specification

## Purpose

This document defines the intended website structure for Frames per Second, a working placeholder name for a mechanical picture frame / reveal object. The site should become a conventional, trustworthy product-ordering website while preserving room for the unusual physical reveal systems and future community gallery direction.

The current live Apps Script site is intentionally simple. It already includes a functional concept upload form and gallery backed by Google Drive and Google Sheets. Those systems should be preserved while the surrounding website becomes clearer, more editable, and more product-oriented.

## Product Definition

Frames per Second is a physical reveal object. A printed image remains stable until a mechanical or physical trigger causes a sudden reveal of a second hidden image.

The product is not:

- a screen
- a digital display
- a gradual morph animation
- a simulated video effect

The reveal is a real-world physical transformation using printed images, hidden second states, physical reveal mechanisms, gravity or weight-driven systems, timing mechanisms, activation systems, and tactile interaction.

Core product themes:

- surprise
- delayed reveal
- hidden second state
- analog mechanical weirdness
- physical transformation
- custom image pairs
- giftability
- memorable reveal moment
- tactile interaction
- strange, fun, clever physical object

## Product Variants

The site should support multiple reveal mechanism types without hardcoding the product around only one mechanism.

Initial planned variants:

- Clock Reveal: a timed mechanical reveal triggered after a chosen amount of time using a clock-style movement and physical mechanism.
- Add-Water Reveal: a reveal triggered by adding water or liquid, causing a hidden image or transformation to appear.

Future reveal types should be possible, but the current implementation should stay lightweight. Product variant data should eventually live in editable configuration rather than scattered markup.

## Website Goals

The website should:

- explain the object quickly and clearly
- make the product feel real, giftable, and orderable
- support standard ecommerce expectations
- preserve the existing upload/gallery system
- leave obvious places for future custom configurators and community features
- remain easy to hand-edit by a non-programmer
- remain compatible with Google Apps Script

The tone should be clear, trustworthy, slightly clever, and visually restrained. It should avoid fake startup language, exaggerated technical claims, clutter, and framework-heavy architecture.

## Anti-Goals

Do not build these yet:

- real payment processing
- authentication
- moderation tooling
- full social platform behavior
- advanced configurator logic
- QR-linked reveal pages
- reveal simulation engines
- dynamic onboarding/tutorial systems
- remix/mod systems
- complex CMS behavior
- framework or build-system architecture

Checkout should be placeholder/demo only until real payment infrastructure exists. The site should not invent security, payment, fulfillment, or shipping claims.

## Visual Design Philosophy

The visual language should be restrained, clear, and hand-editable.

Illustrations and diagrams should use:

- high-signal informational cartoon language
- simplified editorial or infographic style
- symbolic props
- restrained stylization
- minimal clutter
- immediate category recognition

Avoid:

- cinematic scenes
- detailed rendering
- excessive realism
- childish mascot energy
- decorative clutter
- semi-realistic stock illustration look
- startup/SaaS gradient-heavy styling

Illustrations should prioritize semantic clarity, visual hierarchy, compressed signaling, recognizable archetypes, and simplified symbolic objects.

## Site Structure

The site should eventually contain these sections in this approximate order.

### Homepage Hero

Purpose:

- establish the product name
- explain the physical reveal concept in one or two short lines
- show or reserve space for a simple diagram/illustration
- provide primary actions for ordering and viewing examples

Editable content:

- site/product name
- short tagline
- short supporting description
- primary CTA label
- secondary CTA label
- hero image/diagram reference

Implementation note:

- Keep this as static markup initially.
- Do not add complex animations yet.

### Product Explanation

Purpose:

- clarify that this is physical, printed, and mechanical
- distinguish it from screens and digital morphs
- explain the hidden second image and sudden reveal moment

Editable content:

- short explanation headline
- 2-4 concise explanation blocks
- optional simple diagram captions

### How It Works

Purpose:

- communicate the basic lifecycle:
  - choose two images
  - choose a reveal type or kit level
  - assemble/setup or receive finished gift
  - trigger the reveal

Editable content:

- step labels
- step descriptions
- optional icons or image references

### Product Type Overview

Purpose:

- make room for multiple reveal mechanisms
- introduce Clock Reveal and Add-Water Reveal without requiring full configurator behavior

Editable content:

- reveal mechanism names
- short descriptions
- availability/status labels
- optional notes about future variants

Initial mechanism examples:

- Clock Reveal: timed mechanical reveal.
- Add-Water Reveal: liquid-triggered physical transformation.

### Pricing / Order Section

Purpose:

- present four clear purchase tiers
- establish a simple ecommerce baseline
- keep prices editable from one place

Purchase tiers:

- Maker Kit, $45: Customer prints cassette and stand. Includes precision mechanical/image components.
- Builder Kit, $70: Printed cassette included. Full self-assembly.
- Setup Kit, $90: Major assembly completed. Customer handles final loading/setup.
- Finished Gift, $160: Fully assembled, tested, images loaded, battery included, ready to display or gift.

Editable content:

- tier names
- prices
- tier descriptions
- included items
- availability
- recommended/default tier flag

Implementation note:

- Pricing tier data should live in centralized configuration.
- The current `Config.html` stores visible content in one `SITE_CONTENT` object. Pricing tiers live at `SITE_CONTENT.sections.order.tiers` and should be edited there rather than duplicated.

### Cart / Order Flow

Purpose:

- provide a conventional ecommerce flow without real payment processing yet

Initial placeholder behavior:

- select tier
- adjust quantity
- show simple subtotal
- show placeholder checkout state

Do not add:

- real payment collection
- fake payment confirmation
- fake security claims

Editable content:

- checkout placeholder copy
- contact/order instructions
- shipping note
- unavailable/preorder messaging

### Checkout Placeholder

Purpose:

- clearly signal that checkout is not live yet or is handled manually

Acceptable placeholder patterns:

- "Checkout is not live yet."
- "For now, contact us to complete an order."
- "Payment processing will be added later."

Avoid:

- fake card fields that appear real
- fake payment success
- fake inventory systems

### Shipping / Returns / Fine Print

Purpose:

- provide a normal ecommerce trust layer
- avoid overpromising

Editable content:

- shipping status
- expected production timing
- return limitations for custom image products
- safety or care notes
- battery note for finished gifts

### FAQ

Purpose:

- answer product comprehension and ordering questions

Likely FAQ topics:

- Is it a screen?
- Can I use my own images?
- What image formats work best?
- How does the reveal happen?
- Can I choose the reveal timing?
- What is included in each kit?
- Is assembly required?
- Is checkout live?
- How does shipping work?

Editable content:

- FAQ entries as centralized data.

### Upload Form

Purpose:

- preserve the existing concept submission behavior
- allow user-created cover/reveal image pair submissions

Current behavior to preserve:

- fields for cover title, reveal title, optional description
- cover image upload
- reveal image upload
- submit through `google.script.run.submitConcept(data)`
- Drive file creation
- Sheet row append
- gallery reload after submit

Future direction:

- concept submissions may become part of a community gallery system.
- Do not build authentication or moderation yet.

### Gallery / Examples

Purpose:

- show current user-created image pairs
- seed future community browsing/discovery

Current behavior to preserve:

- gallery loads from `getGallery()`
- newest items appear first
- clicking a gallery card toggles cover/reveal images
- reveal description appears only in reveal state

Future direction:

- featured creations
- public browsing/discovery
- social sharing
- lightweight remix/mod culture
- user-submitted reveal concepts

Do not build yet:

- accounts
- likes
- comments
- moderation queues
- full social feeds

### Setup / How-To Section

Purpose:

- support kit assembly and finished gift setup
- explain loading images and activating mechanisms

Initial state:

- placeholder content only
- can reference future instructions without pretending final docs exist

Editable content:

- setup steps
- kit-specific notes
- care instructions
- mechanism warnings

### Footer / Contact

Purpose:

- provide simple site closure and contact path

Editable content:

- contact email or form note
- product/site name
- copyright text
- social links if any
- manual order instructions if checkout is not live

## Mobile Layout Behavior

The site should be mobile-first and simple:

- single-column content by default
- pricing tiers stack cleanly
- forms remain readable and tappable
- gallery uses responsive grid behavior
- diagrams stay legible at small widths
- text should not overlap or rely on tiny captions
- avoid fixed-height areas that crop essential content

## Editable Configuration Areas

Important values should be centralized. The site should avoid scattering business data through markup and JavaScript.

Configuration should eventually include:

- site/product name
- tagline
- homepage copy blocks
- hero CTAs
- pricing tiers
- product tier descriptions
- reveal mechanism types
- FAQ entries
- shipping notes
- returns/fine print
- feature flags
- checkout placeholder text
- contact details
- future add-ons/accessories
- future customization costs
- future variant pricing

Current likely home:

- `Config.html` for client-visible editable content and configuration.
- `Code.js` for private server IDs and backend behavior.

Keep configuration simple. Prefer arrays and plain objects with obvious names.

## Existing Functional Subsystems

### Apps Script Backend

File:

- `Code.js`

Responsibilities:

- serve `Index.html`
- include partial files
- receive submissions
- create Drive files
- append Sheet rows
- fetch gallery rows
- convert Drive images to data URLs

### Client Frontend

Files:

- `Index.html`
- `Config.html`
- `Styles.html`
- `Client.html`

Responsibilities:

- render static page sections
- render pricing tiers from configuration
- handle upload form
- load gallery
- render gallery cards
- toggle cover/reveal state

## Fragile Areas To Respect

- Apps Script HTML partials require template evaluation.
- `google.script.run` only works inside deployed Apps Script HTML.
- Drive and Sheet IDs are currently hardcoded in `Code.js`.
- Gallery rendering depends on Sheet column order.
- Converting all Drive images to base64 can become slow as the gallery grows.
- Anonymous access plus `executeAs: USER_DEPLOYING` allows public submissions under the deploying user's Drive/Sheet permissions.
- Gallery text rendering must avoid leaking `undefined` into visible strings.

## Future Expansion Areas

Keep room for:

- multiple reveal mechanism products
- variant-specific pricing
- optional accessories
- configurable add-ons
- manual or real checkout
- image-pair upload workflows
- featured examples
- community gallery browsing
- shareable gallery items
- concept moderation
- setup guides
- reveal diagrams
- QR-linked reveal pages
- timed reveal demos
- reveal simulation placeholders

These should be added gradually and only when needed.
