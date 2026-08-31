# Current project state

Updated: 2026-08-30

This file is the short briefing for a completely new chat. `AGENTS.md` defines
how to work; this file records what is currently true. Confirm it against the
working tree before making changes.

## Authoritative locations

- Public website: `C:\Users\zack and lil\frames-site-cloudflare`
- Production branch: `codex/cloudflare-port`
- Apps Script and Google backend: `C:\Users\zack and lil\frames-site`
- Canonical weight-system CAD: `cad/source/` in the public website worktree
- Public CAD downloads: generated copies under `assets/downloads/`
- Current public design release: `1.0.0`, governed by Semantic Versioning 2.0.0.
- Release policy and current machine record: `release/POLICY.md` and
  `release/current.json`.
- Heavy recordings, renders, meshes, and intermediates: `D:`
- User-facing file workspace: `C:\Users\zack and lil\Documents\Double Take Frames`
  - `1 - Canonical` contains accepted files.
  - `2 - Pending Canon` contains tracked candidates under review.
  - `3 - Experimental` contains non-authoritative work stored on `D:`.
  - Every tier is subdivided into exactly `SCAD`, `STL`, and `3MF`.
  - Canonical and Pending Canon `SCAD` are ordinary local folders with
    file-level hard links, not directory junctions, for OpenSCAD 2021
    compatibility. Refresh them with `npm run workspace:sync`.
- `C:\Users\zack and lil\Documents\codex-scad-experiment` is obsolete historical
  working material and must never be treated as canonical input.

## Pending canon

- `water-cassette-v1.1.0-rc.2.scad` is the primary pending-canon water-cassette
  design. Its tracked source is `cad/pending-canon/water-cassette-v1.1.0-rc.2.scad`.
- It was copied byte-for-byte from the historical experiment on 2026-08-30.
- It is not yet canonical and must not replace a public download until the user
  explicitly promotes it.
- `rc.2` restores the original 5.0 mm -Y top fang and shortens the opposing +Y
  return to 3.5 mm. This keeps the 1.5 mm insertion lead without consuming the
  roller's existing minimum-clearance envelope. `rc.1` remains tracked as the
  superseded candidate.
- The coordinated captive capstan and clock-string-guide work is Pending Canon
  for `1.1.0-rc.1`. The authoritative working controller is
  `cad/pending-canon/capstans-and-clock-string-guide-captive-v1.1.0-rc.1.scad`;
  its two printable dependencies sit beside it.
- The associated fit-check, collision-check, screenshots, STL renders, and
  historical snapshots remain Experimental in the backend draft folder.
- There is no dry-rig file in Pending Canon. The proper accepted dry rig is
  `cad/source/dry-wall-rig-v1.0.0.scad`.

## Current weight system

- Weight: Gallardo Tire Products FN-Series zinc clip-on wheel weight, 25 grams,
  for alloy rims on most Japanese vehicles.
- A substitute should be similar in size and weight and must provide a usable
  eyelet/opening for the brad pin.
- The former adhesive steel weight, flat birch stick, and thick cotton ligature
  are no longer part of this mechanism.
- A simple brad pin/clip replaces the thick cotton ligature.
- Current mechanism uses the new latch/trap-door arrangement and C-clip.

## Website and assembly status

- Parts inventory uses simple `Weight` and `Brad Pin` entries; detailed product
  information belongs in self-sourcing.
- Existing general/how-it-works video may show the older mechanism. That is
  intentionally acceptable for now.
- Weight assembly instructions currently cover inserting the brad pin, seating
  the weight, securing the latch, showing a brief zipper interaction, and
  fastening the cover image with the brad pin sideways like a mustache.
- The displayed title for the latch step is `Secure the Latch`; its asset retains
  an older filename for compatibility.
- The zipper-insertion illustration is being revised. The current public image
  is temporary, and the local crude SCAD scene under `drafts/scad-experiments/`
  is only a draft. Do not promote it without explicit review.
- The next illustration must emphasize the underside supporting the latch and
  use the established semantic colors rather than the colors in reference photos.

## Working rules

- `Canonical`: currently accepted truth; use by default.
- `Pending Canon`: tracked intended successor under review; do not publish as
  canonical without explicit promotion.
- `Experimental`: exploratory and non-authoritative; large material lives on `D:`.
- Promotion flows only `Experimental -> Pending Canon -> Canonical`.
- SCAD is editable design source; STL is a geometry-only print model; 3MF is a
  richer slicer/project package that can retain multiple parts, units, and settings.
- Publication is recorded separately: a canonical source can be saved without
  being live, and a live asset can be marked temporary while replacement is pending.
- Never infer that a file named `canonical` elsewhere is authoritative.
- Run `npm test` before publishing. CAD edits also require `npm run cad:sync`.
- Never modify a released `1.0.0` file in place. Assign the next SemVer first,
  record its changes, and generate a new complete release set.
- Update this file when a design decision changes what is current or obsolete.
