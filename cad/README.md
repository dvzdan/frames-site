# Canonical CAD source

This folder is the tracked source of truth for the weight-system SCAD files
that are also offered as public downloads.

Current mapped sources:

- `source/dry wall rig.scad`
- `source/latch and keeper.scad`

Edit the files here, then run:

```text
npm run cad:sync
```

That command replaces the matching files under `assets/downloads/` with exact
copies and rewrites `release-manifest.json` with their SHA-256 hashes. Run
`npm run cad:check` to verify that the source, public copies, and manifest agree.
The check is also part of `npm test`.

The similarly named folder under `Documents/codex-scad-experiment` is historical
working material and is not an input to this process. Large renders, snapshots,
meshes, and experiments belong on `D:`.
