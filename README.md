# frames-site-cloudflare — public website

This worktree is the authoritative frontend and public-asset source for
<https://doubletakeframes.com/>. Page layout, styling, routes, client scripts,
posters, downloads, images, and videos belong here.

The build copies `assets/` into `dist/assets/`. Production deploys from
`codex/cloudflare-port`; this worktree may temporarily use a feature branch
before those changes are merged into production.

The separate worktree at `C:\Users\zack and lil\frames-site` owns the Apps
Script backend, Google Sheets/Drive integration, and the sheet-backed content
feed. Large source media and editing intermediates belong on `D:`; selected
web-ready files belong here under `assets/`.
