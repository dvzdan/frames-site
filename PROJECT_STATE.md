# Current project state

Updated: 2026-11-15

This is the short briefing for a completely new chat. `AGENTS.md` defines how
to work; this file records what is currently true. Confirm it against the
working tree before making changes.

## Authoritative locations

- Public website and public design files: `C:\Users\zack and lil\frames-site-cloudflare`
- Production branch: `codex/cloudflare-port`
- Apps Script and Google backend: `C:\Users\zack and lil\frames-site`
- Canonical CAD source: `cad/source/` in the public website worktree
- Public CAD downloads: generated copies under `assets/downloads/`
- Current public design release: `4.0.0`, governed by Semantic Versioning 2.0.0
- Release policy and machine record: `release/POLICY.md` and `release/current.json`
- Heavy recordings, renders, meshes, and intermediates: `D:`
- Superseded release working copies: `D:\\Double Take Frames\\Superseded\\<version>`
  (kept out of Canonical and public-download folders; Git release tags remain
  the authoritative immutable history).
- User-facing file workspace: `C:\Users\zack and lil\Documents\Double Take Frames`
  - `1 - Canonical` contains accepted files.
  - `2 - Pending Canon` contains local-only candidates under review. Cloudflare
    does not store, mirror, or track these files.
  - `3 - Experimental` contains non-authoritative work stored on `D:`.
  - Every tier is subdivided into exactly `SCAD`, `STL`, and `3MF`.
  - Canonical `SCAD` is an ordinary local folder with file-level hard links for
    OpenSCAD 2021 compatibility. Refresh the Canonical local view with
    `npm run workspace:sync`.
  - Pending Canon `SCAD`, `STL`, and `3MF` are ordinary local folders and are
    deliberately not linked to the Cloudflare worktree.
- `C:\Users\zack and lil\Documents\codex-scad-experiment` is obsolete historical
  working material and must never be treated as canonical input.

## Current canonical design release

- Release `4.0.0` is the complete Canonical design set and a coordinated
  replacement for 3.x printed parts.
- The canonical main frame is the promoted removable-roof source saved as
  `dry = true`, `wet = false`, and `chimney = false`. No wet-variant STL is
  included in the public prepared projects.
- The canonical clock/string guide is the compact stationary-collar design
  with its side-loading thread slit and full beak; the obsolete long pressure
  bar is not part of the release.
- The canonical wall rig and latch are saved in their standard dry conditions:
  `wet = false` and `wet_latch = false`. The frame stand is saved with
  `reservoir = false`.
- The two public prepared Bambu Studio projects are
  `fabrication/canonical/3mf/frame-and-stand-v4.0.0.project.3mf` and
  `fabrication/canonical/3mf/everything-else-v4.0.0.project.3mf`.
- Frame and Stand retains its 0.6 mm-nozzle profile, support enforcers,
  placements, and four wall loops. Everything Else retains the wall-rig
  support enforcer and the capstans' prepared support settings.
- Capstan and roller geometry is carried forward under the 4.0.0 release
  number. Standalone wall-rig, latch, and roller manufacturing projects remain
  local canonical sources rather than separate public downloads.

## Pending canon

- The 2026-11-15 dry candidates were promoted into release `4.0.0`.
- Wet, chimney, and reservoir alternatives remain source-controlled options
  inside the canonical SCAD files but are not current prepared release meshes.

## Current weight system

- Weight: Gallardo Tire Products FN-Series zinc clip-on wheel weight, 25 grams,
  for alloy rims on most Japanese vehicles.
- A substitute should be similar in size and weight and must provide a usable
  eyelet/opening for the brad pin.
- The former adhesive steel weight, flat birch stick, and thick cotton ligature
  are no longer part of this mechanism.
- A simple brad pin/clip replaces the thick cotton ligature.
- Current mechanism uses the clipless keyed latch/trap-door arrangement. No
  C-clip is required; the bayonet lug retains the latch after rotation.

## Website and assembly status

- Parts inventory uses simple `Weight` and `Brad Pin` entries; detailed product
  information belongs in self-sourcing.
- Existing general/how-it-works video may show the older mechanism. That is
  intentionally acceptable for now.
- Weight assembly instructions cover inserting the brad pin, seating the
  weight, securing the latch, locking it with the zipper, and fastening the
  cover image with the brad pin sideways like a mustache.
- The zipper-insertion illustration remains a temporary live asset and may be
  refined later without blocking the current design release.
- Clock-string-guide instructions and inventory art reflect the captive guide
  carried forward into 4.0.0, and the capstan step places the capstan over it.

## Working rules

- `Canonical`: currently accepted truth; use by default.
- `Pending Canon`: local intended successor under review; Cloudflare does not
  store it, and it must not be published as canonical without explicit
  promotion.
- `Experimental`: exploratory and non-authoritative; large material lives on `D:`.
- Promotion flows only `Experimental -> Pending Canon -> Canonical`.
- SCAD is editable design source; STL is a geometry-only print model; 3MF is a
  richer slicer/project package that can retain multiple parts, units, settings,
  and support enforcers.
- Never infer that a file named `canonical` elsewhere is authoritative.
- Run `npm test` before publishing. CAD edits also require the release and
  workspace synchronization checks.
- Before publishing a prepared 3MF, run Bambu Studio's non-interactive
  load-and-slice round trip and confirm that every intended object is present
  and not skipped. ZIP/XML inspection alone is not an adequate project check.
- Never modify a released version in place. Assign the next SemVer, record its
  changes, and generate a complete release set.
- Update this file whenever a design decision changes what is current.
