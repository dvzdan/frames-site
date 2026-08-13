# Cloudflare Pages migration

This branch builds the approved multipage release at commit `0502460` as a conventional website for Cloudflare Pages.

## Local commands

```text
npm run build
npm run validate
npm run preview
```

The preview server listens on `http://127.0.0.1:4173/`. The deployable output is `dist/`.

## Routes

- `/`
- `/build/`
- `/kits/`
- `/assembly/`
- `/make-5x-7/` is not used; the tool is at `/make-5x7/`

## Editable content

- Cloudflare loads public site copy and sourcing data from the Apps Script `?format=content` read-only feed at build time.
- If Google is temporarily unavailable, the build succeeds with the approved built-in copy instead of breaking the public site.
- Edits in the `Site CMS` and `Sourcing` spreadsheet tabs appear after the next Cloudflare deployment.
- Inquiry and image-submission forms use Cloudflare storage and Turnstile protection.
- Checkout and payment remain inactive by default. The Stripe Checkout integration is present but fail-closed until its mode, secret, and trusted Stripe Price IDs are configured.

The Make 5×7 tool remains fully client-side.

## Production status

- Public site: `https://doubletakeframes.com/`
- Alternate hostname: `https://www.doubletakeframes.com/`
- Both hostnames are attached to the Pages project with Cloudflare SSL enabled.
- Cloudflare is authoritative for DNS. The Porkbun email-forwarding MX records and SPF TXT record remain in place.
- The production branch is `codex/cloudflare-port`; pushes to that branch deploy automatically.

## Cloudflare Pages build settings

- Framework preset: `None`
- Root directory: repository root
- Build command: `npm run build`
- Build output directory: `dist`
- Production branch: `codex/cloudflare-port`
- Other non-production branches remain preview environments.

The public domain should only be attached after the production deployment passes review.

## Remaining backend work

Before re-enabling the forms or dynamic content, choose and implement services for:

- inquiry storage and notification,
- image upload storage and moderation,
- gallery publication,
- design-file/download metadata,
- sourcing/CMS data.

Secrets must be stored as encrypted Cloudflare secrets, never committed to the repository.

## Stripe Checkout

The site uses Stripe-hosted Checkout so card details never pass through this application. The existing inquiry links remain available in every mode.

Required Cloudflare configuration:

- Secret: `STRIPE_SECRET_KEY` (`sk_test_...` in test mode, `sk_live_...` in live mode)
- Variable: `STRIPE_CHECKOUT_ENABLED=true` (the explicit live-payment switch; test mode does not require it)
- Variable: `STRIPE_CHECKOUT_MODE` (`off`, `test`, or `live`; defaults to `off`)
- Variables: `STRIPE_PRICE_MAKER`, `STRIPE_PRICE_BUILDER`, `STRIPE_PRICE_GIFT`, and `STRIPE_PRICE_IMAGE_PREP`
- Variables: `STRIPE_SHIPPING_MAKER`, `STRIPE_SHIPPING_BUILDER`, and `STRIPE_SHIPPING_GIFT` (flat U.S. shipping amounts in cents)
- Secret: `STRIPE_WEBHOOK_SECRET` (`whsec_...` from the Stripe endpoint for `/api/stripe/webhook`)
- Optional variable: `STRIPE_AUTOMATIC_TAX=true` only after the applicable tax registrations are configured

Test checkout works whenever `STRIPE_CHECKOUT_MODE=test` is set for both the Pages build and the Pages Function runtime. Live checkout requires both `STRIPE_CHECKOUT_MODE=live` and `STRIPE_CHECKOUT_ENABLED=true`; without the explicit live-payment flag, the build hides the Buy button and the server refuses live checkout requests. The server also verifies that the secret key matches the selected test/live mode.

Ready-to-Assemble Kits and Finished Gifts use their existing Stripe Price IDs for every stocked color combination. Color choices are validated by the server and stored in Checkout Session metadata, so no color-specific Stripe products or prices are required. Custom colors do not enter checkout; they are submitted as quote requests.

Configure a Stripe webhook endpoint at `https://doubletakeframes.com/api/stripe/webhook` for `checkout.session.completed` and `checkout.session.async_payment_succeeded`. The handler verifies Stripe signatures and writes idempotent fulfillment records to the `orders` D1 table.

Apply `migrations/0002_color_options_and_orders.sql` to the production D1 database before deploying the color configurator. It adds color fields to inquiries and creates the order-fulfillment table.
