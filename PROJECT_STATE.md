# Current project state

Updated: 2026-09-04

This is the short briefing for a completely new chat. `AGENTS.md` defines how
to work; this file records what is currently true. Confirm it against the
working tree before making changes.

## Authoritative locations

- Public website and public design files: `C:\Users\zack and lil\frames-site-cloudflare`
- Production branch: `codex/cloudflare-port`
- Apps Script and Google backend: `C:\Users\zack and lil\frames-site`
- Canonical CAD source: `cad/source/` in the public website worktree
- Public CAD downloads: generated copies under `assets/downloads/`
- Current public design release: `2.0.2`, governed by Semantic Versioning 2.0.0
- Release policy and machine record: `release/POLICY.md` and `release/current.json`
- Heavy recordings, renders, meshes, and intermediates: `D:`
- Superseded release working copies: `D:\\Double Take Frames\\Superseded\\<version>`
  (kept out of Canonical and public-download folders; Git release tags remain
  the authoritative immutable history).
- User-facing file workspace: `C:\Users\zack and lil\Documents\Double Take Frames`
  - `1 - Canonical` contains accepted files.
  - `2 - Pending Canon` contains tracked candidates under review.
  - `3 - Experimental` contains non-authoritative work stored on `D:`.
  - Every tier is subdivided into exactly `SCAD`, `STL`, and `3MF`.
  - Canonical and Pending Canon `SCAD` are ordinary local folders with
    file-level hard links for OpenSCAD 2021 compatibility. Refresh the complete
    local view with `npm run workspace:sync`.
- `C:\Users\zack and lil\Documents\codex-scad-experiment` is obsolete historical
  working material and must never be treated as canonical input.

## Current canonical design release

- Release `2.0.2` is the complete Canonical design set. This packaging hotfix
  replaces the invalid 2.0.1 Everything Else package with a native Bambu Studio
  project verified by loading and slicing all six intended objects.
- `cad/source/main-frame-v2.0.2.scad` is the accepted main-frame source. It was
  promoted from `water-cassette-v1.1.0-rc.3.scad` and is intentionally saved as
  the dry configuration: `dry = true`, `wet = false`.
- `capstans-v2.0.2.scad` and `clock-string-guide-v2.0.2.scad` are a coordinated
  captive pair and must be used together. Their controller is
  `capstans-and-clock-string-guide-v2.0.2.scad`.
- `dry-wall-rig-v2.0.2.scad`, `frame-stand-v2.0.2.scad`,
  `latch-and-keeper-v2.0.2.scad`, and `roller-v2.0.2.scad` carry their accepted
  geometry into the 2.0.2 set unchanged.
- The two prepared Bambu Studio projects are
  `fabrication/canonical/3mf/frame-and-stand-v2.0.2.project.3mf` and
  `fabrication/canonical/3mf/everything-else-v2.0.2.project.3mf`. The latter uses
  a native Bambu package, retains the prepared capstan and dry-rig support
  enforcer, and passed a full non-interactive Bambu load-and-slice round trip.
- The retained support-painted component inputs live under the
  `component-sources/` subfolders in Canonical 3MF and STL. They are internal
  assembly sources, not separate current-release downloads.
- Superseded 2.0.0 and 2.0.1 working copies are grouped under their respective
  `D:\Double Take Frames\Superseded\<version>` folders; they do not remain in
  active Canonical or public-download folders.
- Release 1.0.0 remains recoverable through Git tag `design-v1.0.0`; it is not
  part of the active Canonical folders or current public downloads.

## Pending canon

- There are no active Pending Canon SCAD candidates immediately after the
  2.0.2 promotion.
- `fabrication/pending-canon/stl/Combined capstan and clock string guide.stl`
  remains Pending Canon. It is a user-supplied export whose exact relationship
  to the verified 2.0.2 sources is still unverified; do not publish or promote
  it by inference.

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
- Weight assembly instructions cover inserting the brad pin, seating the
  weight, securing the latch, locking it with the zipper, and fastening the
  cover image with the brad pin sideways like a mustache.
- The zipper-insertion illustration remains a temporary live asset and may be
  refined later without blocking the current design release.
- Clock-string-guide instructions and inventory art reflect the 2.0.2 captive
  guide, and the capstan step places the capstan over that guide.

## Working rules

- `Canonical`: currently accepted truth; use by default.
- `Pending Canon`: tracked intended successor under review; do not publish as
  canonical without explicit promotion.
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
