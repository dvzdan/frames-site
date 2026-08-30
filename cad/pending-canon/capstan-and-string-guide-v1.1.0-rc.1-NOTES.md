# Captive capstan and clock-string-guide candidate 1.1.0-rc.1

These coordinated files are Pending Canon based on canonical release 1.0.0.
They do not replace the immutable canonical or public 1.0.0 files until physical
testing succeeds and the user explicitly promotes them.

## Coordinated changes

- The capstan's only changed geometry is flange diameter: **9.0 → 16.0 mm**.
- Its bores, 7.4 mm drum, height, and flange thickness remain canonical. The
  eyelet outer end is pulled radially inward for rotating clearance while its
  canonical 0.8 mm outer wall, 1.8 mm width, vertical faces, and drum attachment
  are retained. Only the opening length shortens, leaving a shorter and stronger
  cantilever without making threading difficult.
  The minute horn is disabled so that capstan can print upside down without
  internal support debris; a shallow recessed radial mark replaces its indexing
  function. The minute mark is now a wider, deeper rounded slot for visibility.
  The hour horn retains its canonical size but is shifted radially outward near
  the 16 mm flange edge. Pair spacing is increased only to
  clear the sacrificial supports. The eyelet is held at its original 9 mm-flange
  datum.
- Both capstans have a rounded radial loading slot through only the assembly-
  bottom flange, aligned with the +Y string-anchor datum. Its 4.8 mm width is
  derived from the shared 4.0 mm beak width plus 0.4 mm clearance per side.
  The rounded inner end is tangent to the 7.4 mm drum, so the drum remains
  intact; the opposite flange remains whole to prevent upside-down insertion.
- Both capstans are widened axially from 5.0 to **6.0 mm** by moving only the
  upper flange outward. The usable gap between their 0.8 mm flanges therefore
  increases from 3.4 to **4.4 mm**. The bottom flange, loading notch, and minute-
  bore transition retain their former datums. The string-anchor center and
  guide beak both shift 0.5 mm toward the raised flange, keeping them centered
  and mutually aligned in the wider gap.
- The print layout places the minute capstan upside down and the hour capstan
  upright. Modeled supports are disabled by default so Bambu Studio can create
  established manual/painted normal supports. The former six breakaway posts
  remain available by setting `breakaway_supports_enabled=true`.
- The guide uses a **17.0 mm** opening around the 16.0 mm flange while retaining
  the canonical boss dimensions. There is now one thickness boundary: a
  19.0 mm-wide circular/rectangular footprint is uniformly 0.8 mm thick, and
  the bar immediately outside it retains its canonical 3.0 mm thickness. The
  former overlapping annular relief—and its moat-like second step—are removed.
  The 0.8 mm region continues straight down as a rectangle, closing the former
  bottom opening and tying the two guide sides together.
  Its overall X envelope is reduced from 58.5 to **58.0 mm**, relieving the
  existing end-to-end tension fit by 0.25 mm per side. No retention bump is
  included yet.
  Its added beak is a closed, wall-backed wedge rooted on the canonical string
  hole. Guide-local +Y controls its eventual -Z projection, while guide-local
  +Z controls its cassette +Y height. The point center is set approximately to
  cassette +Y **7.0 mm**, 1.0 mm below the assumed 8.0 mm spindle/top-flange
  datum. Only the loading hole and
  intended outlet remain open. No assumed capstan-position sweep is subtracted
  from the printable guide; physical flange clearance remains a fit adjustment.
  Its outer body has a broad 5.0 mm root outside the flange boundary, then
  becomes a 0.8 mm flange-normal tongue inside the envelope. That tongue is
  widened to 4.0 mm tangentially for stiffness. The 1.0 mm passage becomes an
  open centered groove only in this terminal region, relying on the adjacent
  capstan flanges for axial containment instead of sacrificing clearance to a
  fully enclosed printed tunnel.
- A movement-facing circular floor now spans the entire capstan-flange area.
  The yellow addition is exactly **0.8 mm thick** along the spindle axis. This
  is a robust two-line wall for a 0.4 mm nozzle and adds 0.4 mm of clearance
  relative to the former 1.2 mm floor. Its
  17.0 mm functional envelope clears the 16.0 mm flange by 0.5 mm per side,
  then extends another 1.0 mm radially to overlap and fuse into the surviving
  purple rear web. The supplied snap-in/no-thread movement image specifies
  concentric movement-member outside diameters of **6.8 mm**, **5.05 mm**, and
  **3.17 mm**. These are movement sleeve/shaft dimensions, not the printed
  capstan's 7.4 mm winding-drum OD. The stationary-floor bore is modeled at
  **6.75 mm**, using an explicit -0.05 mm diametrical locating adjustment while
  preserving 6.8 mm as the documented movement datum. The hour capstan retains
  its 5.15 mm fit bore. The minute bore is lightly relieved from 3.35 to
  **3.40 mm** so it can seat fully on the specified 3.17 mm inner member.
- The guide's exported print layout is inverted so the boss/top edge is on the
  bed and the beak grows upward from its wall-backed root. The
  `clock_pressure_bar()` module remains in canonical assembly coordinates.

## Files

- `capstans-and-clock-string-guide-captive-v1.1.0-rc.1.scad` — combined master SCAD
  with one shared parameter block for the flange, guide clearance, snap-in
  movement sleeves, 0.8 mm stationary floor, shared beak width, and keyed
  bottom-flange insertion slots. Treat this as the authoritative working file.
- `capstans-captive-v1.1.0-rc.1.scad` — printable minute/hour candidate pair.
- `clock-string-guide-captive-v1.1.0-rc.1.scad` — printable coordinated guide candidate.
- `captive-fit-check.scad` — assembly visualization only.
- `beak-capstan-clearance-check.scad` — samples the eyelet through a complete
  revolution; a successful check renders no interference geometry.
- `flange-clearance-check.scad` — diagnostic only; it visualizes assumed flange
  interference but does not modify the printable guide.
- `collision-check.scad` — retained only as a diagnostic for the historical
  assembly-scene offsets; those offsets are not treated as design authority.

## Before promotion

Print and test the larger-flange capstans with the beaked guide. Confirm free
capstan rotation, verify the beak clears the eyelet throughout a full rotation,
and confirm that the line cannot pass through either axial beak/flange gap.
