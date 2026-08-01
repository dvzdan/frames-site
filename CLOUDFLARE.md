# Cloudflare Pages migration

This branch builds the approved multipage release at commit `0502460` as a conventional static website for Cloudflare Pages. It does not replace or deploy the Apps Script site.

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

## Temporarily static or disabled

- The gallery uses a checked-in/static snapshot instead of Google Sheets hydration.
- Design-file downloads and the sourcing list show migration notices instead of querying Google Drive or Sheets.
- Inquiry and image-submission controls are disabled and do not send data.
- Checkout and payment remain inactive.
- Sheet-driven CMS overrides are not loaded; the approved fallback copy in the release is used.

The Make 5×7 tool remains fully client-side.

## Cloudflare Pages build settings

- Framework preset: `None`
- Root directory: repository root
- Build command: `npm run build`
- Build output directory: `dist`
- Production branch: `main` (this keeps `codex/cloudflare-port` in the preview environment)
- Preview branch: `codex/cloudflare-port`

Do not attach `doubletakeframes.com` or change DNS until the branch preview has passed review.

## Remaining backend work

Before re-enabling the forms or dynamic content, choose and implement services for:

- inquiry storage and notification,
- image upload storage and moderation,
- gallery publication,
- design-file/download metadata,
- sourcing/CMS data.

Secrets must be stored as encrypted Cloudflare secrets, never committed to the repository.
