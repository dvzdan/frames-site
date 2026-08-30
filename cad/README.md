# Canonical CAD source

This folder is the tracked source of truth for the complete current public
OpenSCAD release.

All canonical SCAD filenames and headers carry the current Semantic Version.
The authoritative version and artifact mapping live in `../release/current.json`.

Edit the files here, then run:

```text
npm run cad:sync
```

That command stamps supported 3MF metadata, replaces the matching files under
`assets/downloads/` with exact copies, and rewrites
`../release/artifact-manifest.json` with their SHA-256 hashes. Run
`npm run release:check` to verify that the version record, notes, source
headers, embedded metadata, public copies, and manifest agree. The check is also
part of `npm test`.

The similarly named folder under `Documents/codex-scad-experiment` is historical
working material and is not an input to this process. Large renders, snapshots,
meshes, and experiments belong on `D:`.
