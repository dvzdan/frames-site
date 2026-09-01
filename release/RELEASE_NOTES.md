# Double Take Frames design releases

Only the current design files are publicly downloadable. This history explains
what changed between releases.

## 2.0.0 - 2026-08-31

Coordinated main-frame, capstan, and clock-string-guide release.

- Promoted the latest water-cassette geometry as the shared main-frame source.
  Its saved default is the dry configuration (`dry = true`, `wet = false`).
- Introduced the captive capstans and matching clock-string guide. These 2.0.0
  components form a coordinated pair and replace the 1.x versions together.
- Added a combined OpenSCAD controller for viewing or rendering the capstan and
  guide set.
- Rebuilt both prepared 3MF projects with the new meshes while retaining the
  established nozzle profiles and support enforcers.
- Carried the dry-wall rig, frame stand, latch and keeper, and roller geometry
  forward unchanged as part of the complete 2.0.0 release set.

Compatibility note: do not mix a 2.0.0 capstan or clock-string guide with its
1.x counterpart.

Known documentation note: the general how-it-works video may still show the
earlier weight mechanism; the current written assembly instructions govern.

## 1.0.0 - 2026-08-30

Initial versioned public design release.

- Established the current printed-part geometry as the 1.x compatibility baseline.
- Adopted the 25 g Gallardo FN-Series zinc clip-on wheel weight system.
- Replaced the former thick cotton ligature with a simple brad pin/clip.
- Included the current latch, keeper/C-clip, clock-string guide, frame, stand,
  roller, and capstan source files.
- Added consistent release identification to source and prepared print projects.

Known documentation note: the general how-it-works video may still show the
earlier weight mechanism; the current written assembly instructions govern.
