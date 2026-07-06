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
