## Canonical project routing - mandatory

At the start of every task in this worktree, read `PROJECT_STATE.md` and
`project-state/assets.json`, then inspect the current branch and working tree.
Treat repository evidence and these tracked records as authoritative over chat
memory. If they disagree with the files, stop and reconcile the discrepancy
before editing or publishing.

This `frames-site-cloudflare` worktree is the **authoritative public frontend**
for `https://doubletakeframes.com/`. Every browser-visible page, route, style,
script, poster, downloadable public file, and public image or video asset
belongs here. Public media belongs under this worktree's `assets/` tree; the
build copies that tree into `dist/assets/`.

The Apps Script backend worktree is:

`C:\Users\zack and lil\frames-site`

Use that backend worktree only for Apps Script functions, the sheet-backed
CMS/content feed, Google Drive/Sheets integration, and backend behavior. Do not
put canonical public media or public layout changes there.

Large original recordings, extracted frames, and editing intermediates belong
on `D:`. Only selected, web-ready deliverables belong in this worktree's
`assets/` tree.

These folders are separate worktrees of the same Git repository. This worktree
may be on a feature branch during active work; production deploys from
`codex/cloudflare-port`. Check the current branch, finish or merge the feature
branch intentionally, and do not assume every push from this worktree is a
production deployment.

Before editing for a website request:

1. Classify the change as public frontend/media or Apps Script/backend.
2. Switch to the matching worktree before creating or editing files.
3. Confirm the deployment target in that worktree's documentation.
4. State which worktree is being changed.
5. Keep one canonical copy of each public asset in this Cloudflare worktree.

## Canonical CAD routing - mandatory

The user's visible file system is
`C:\Users\zack and lil\Documents\Double Take Frames` with exactly three tiers:

- `1 - Canonical`: currently accepted files; use these by default.
- `2 - Pending Canon`: tracked likely replacements under review.
- `3 - Experimental`: non-authoritative trials stored on `D:`.

Each tier has the same user-facing subdivisions: `SCAD - Editable Design Files`,
`STL - Single Print Models`, and `3MF - Complete Print Projects`. Preserve this
plain-language naming when adding or moving files.

Do not require the user to navigate repository internals. Promote files only in
the direction Experimental -> Pending Canon -> Canonical, and only with explicit
user approval for the promotion to Canonical.

For the weight-system mechanism, the editable SCAD source of truth is under
`cad/source/`. The matching files under `assets/downloads/` are public release
copies generated from that source; do not edit those copies by hand.

After changing a mapped SCAD source, run `npm run cad:sync`. Before committing
or deploying, run `npm run cad:check` (also included in `npm test`). The check
fails if a public download or its manifest differs from the canonical source.

`C:\Users\zack and lil\Documents\codex-scad-experiment` is historical working
material, not canonical input. Do not copy from it or update it automatically.
Large renders, snapshots, meshes, and experiments belong on `D:`.

## Assembly instruction panel house style

When creating assembly-instruction visuals, build a dedicated instruction SCAD scene rather than using the full master assembly.

Use `assets/instruction images/03-trap-and-weight/01-insert-trap-rig.png` as the current style target for assembly-instruction panels. Match its overall layout language, neutral arrows with motion chevrons, compact step bubbles, white image cards with black labels, semantic SCAD colors, ghosted blue rig features where appropriate, and caption styling. Do not treat the geometry in the reference image as authoritative for future steps; use each step's SCAD scene for geometry.

## Asset staging

Live image assets belong only in `assets/`, `assets/setup-kit/`, and
`assets/instruction images/`.

When creating or testing generated images, save candidates under
`drafts/generated-images/candidates/` first. Put failed or rejected attempts in
`drafts/generated-images/failed/`.

Move an image into `assets/`, `assets/setup-kit/`, or
`assets/instruction images/` only after it is selected as the live website,
setup-kit, or finished instruction asset.

### SCAD scene rules

Include only the parts directly involved in the instruction plus enough nearby context for orientation.

Comment out or suppress non-interacting geometry that does not help explain the step.

If removing contextual geometry entirely would be confusing, keep it ghosted.

Pose parts in a mid-assembly, partially inserted, or completed state that best explains the action.

### Semantic color rules

Large substrate / frame / base structure: gray

Primary moving part: blue

Receiver / receptacle / slot / small target feature: yellow

Additional active parts: use additional distinct colors as needed

Non-interacting / contextual geometry: ghosted version of its object color or neutral ghosting

### Ghosting rules

Ghosted geometry should remain recognizable but visually subordinate.

Hidden or secondary features belonging to the moving blue part should remain in the blue family, with reduced opacity and mild softening/blur.

Do not recolor active-part features gray if they belong to the blue moving part.

When feature-shape ambiguity is preferred, use stronger ghosting/soft blur so the feature reads as contextual rather than exact.

### Final panel layout

The final instruction panel should include:

- one main assembly image,
- optional image cards for referenced parts,
- movement indicators,
- compact step-number bubbles,
- a caption box.

### Image card rules

Place image cards in a corner or side column.

Use plain white cards with subtle shadow and no colored border.

Show the part image in its semantic object color.

Label each card in black or very dark gray text.

Do not color-match card label text to the object color.

### Arrow / indicator rules

Movement arrows must be visually distinct from pointing indicators.

Movement arrows should use neutral dark color and include motion chevrons/trails.

Pointing indicators, if used, should omit motion treatment.

Step numbers should appear in compact white bubbles with neutral outline and dark text.

### Caption rules

Keep the caption short and instructional.

Color-code object names in the caption to match the semantic object colors.

Style motion words such as Slide in a way that matches the movement-indicator language, e.g. bold.

Include step numbers in the caption where useful.

Step numbers in the caption should remain neutral, not object-colored.

### Style goals

Clear, low-clutter, semantically color-coded, instructional.

Prefer simplified CAD-based clarity over realism or decorative rendering.

Preserve visual consistency across all instruction panels.
