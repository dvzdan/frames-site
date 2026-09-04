// DOUBLE TAKE FRAMES DESIGN RELEASE
// DTF_RELEASE: 2.0.3
// Released: 2026-09-04
// Versioning: Semantic Versioning 2.0.0 (https://semver.org/)
// Status: CANONICAL
// Changes in 2.0.3:
// - Carried forward unchanged for the corrected prepared-project packaging.
// Changes in 2.0.2:
// - Carried forward unchanged for the native 3MF packaging hotfix.
// Changes in 2.0.1:
// - Carried forward unchanged for the prepared-project packaging correction.
// Changes in 2.0.0:
// - Coordinates the captive 16 mm-flange capstans and revised clock-string guide.
// - Centralizes their shared mechanical dimensions and print-plate arrangement.
// Full release notes: https://doubletakeframes.com/build/#design-release
//
// Combined controller for the coordinated capstans and clock/string guide.
// Adjust shared mechanical references here; both component models consume them.

// ---------- shared movement / capstan references ----------

shared_capstan_flange_d = 16.0;
shared_capstan_flange_clearance_r = 0.5;
// Raise only the upper flange by 1 mm: internal flange gap 3.4 -> 4.4 mm.
shared_capstan_total_h = 6.0;
// Reduce total guide X envelope by 0.5 mm (0.25 mm per end).
shared_clock_guide_len_x = 58.0;

// SOURCE: supplied snap-in/no-thread movement dimension image.
// These are movement sleeve/shaft outside diameters—not capstan drum sizes.
shared_stationary_collar_d = 6.8;
shared_hour_sleeve_d = 5.05;   // Middle concentric rotating member.
shared_minute_sleeve_d = 3.17; // Inner concentric rotating member.

// Printed fit: 0.23 mm diametrical relief over the 3.17 mm minute member.
// This is only 0.025 mm more radial clearance than the former 3.35 mm bore.
shared_minute_capstan_bore_d = 3.40;

// Two-line stationary floor for a 0.4 mm nozzle. This gains 0.4 mm of
// bottom-flange clearance versus the former 1.2 mm floor.
shared_stationary_floor_thickness = 0.8;
shared_stationary_floor_attachment_overlap_r = 1.0;
// Tiny diametrical reduction: modeled stationary-floor bore = 6.75 mm.
// This is a locating adjustment, not a claim that the movement spec is 6.75.
shared_stationary_collar_bore_fit_allowance = -0.05;

// The bottom-flange loading slots derive from the fixed beak width.
shared_beak_tangential_w = 4.0;
shared_beak_notch_clearance_per_side = 0.40;
shared_bottom_insertion_notch_enabled = true;
// Recenter beak/anchor in the 1 mm-wider flange gap.
shared_beak_axial_center_shift = 0.50;

// Shorter radial hook for additional rotating clearance. Only the outer end
// moves inward; the 0.8 mm tip wall and drum attachment remain unchanged.
shared_string_eyelet_beyond_flange_y = 0.65;

// ---------- output ----------

show_capstans = true;
show_clock_string_guide = true;

// Scope each component so identically named local parameters cannot leak
// between models. The shared references above remain visible to both scopes.
module coordinated_capstans() {
    include <capstans-v2.0.3.scad>
}

module coordinated_clock_string_guide() {
    include <clock-string-guide-v2.0.3.scad>
}

// Print-plate arrangement: guide above, capstan pair below.
if (show_clock_string_guide)
    translate([0, 12, 0])
        coordinated_clock_string_guide();

if (show_capstans)
    translate([-shared_capstan_flange_d/2, -12, 0])
        coordinated_capstans();
