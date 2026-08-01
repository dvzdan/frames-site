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
- Checkout and payment remain inactive.

The Make 5×7 tool remains fully client-side.

## Cloudflare Pages build settings

- Framework preset: `None`
- Root directory: repository root
- Build command: `npm run build`
- Build output directory: `dist`
- Production branch: `main` (this keeps `codex/cloudflare-port` in the preview environment)
- Preview branch: `codex/cloudflare-port`

The public domain should only be attached after the production deployment passes review.

## Remaining backend work

Before re-enabling the forms or dynamic content, choose and implement services for:

- inquiry storage and notification,
- image upload storage and moderation,
- gallery publication,
- design-file/download metadata,
- sourcing/CMS data.

Secrets must be stored as encrypted Cloudflare secrets, never committed to the repository.
