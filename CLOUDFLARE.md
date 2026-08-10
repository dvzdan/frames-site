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
- Variable: `STRIPE_CHECKOUT_MODE` (`off`, `test`, or `live`; defaults to `off`)
- Variables: `STRIPE_PRICE_MAKER`, `STRIPE_PRICE_BUILDER`, `STRIPE_PRICE_GIFT`, and `STRIPE_PRICE_IMAGE_PREP`
- Optional variable: `STRIPE_AUTOMATIC_TAX=true` only after the applicable tax registrations are configured

`STRIPE_CHECKOUT_MODE` must be set for both the Pages build and the Pages Function runtime. A build in `off` mode does not show a payment button. The server also refuses requests while off and verifies that the secret key matches the selected test/live mode.
