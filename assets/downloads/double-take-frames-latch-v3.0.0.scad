// DOUBLE TAKE FRAMES — CANONICAL LATCH
// DTF_RELEASE: 3.0.0
// Released: 2026-09-24
// Versioning: Semantic Versioning 2.0.0 (https://semver.org/)
// Status: CANONICAL
// Changes in 3.0.0:
// - Adds the missing second 1.2 mm long retaining wall so the pen/weight is
//   laterally captive with the latch in either cassette orientation.
//   The 13.0 mm clear pocket, Y=-8.0 mm installed centerline,
//   pivot eye, keyed socket, and flat-floor print orientation are unchanged.
// - Replaces C-clip retention with a loose, printable bayonet keyway that
//   installs over the wall-rig lug and becomes captive after rotation.
//
$fn = 96;

eps = 0.05;

// =========================================================
// FN WEIGHT LATCH
// =========================================================
post_d = 5.5;
// The keyed nub provides axial retention, so this pivot can remain freely
// rotating without the excessive wobble of the former 0.60 mm radial gap.
// A 0.40 mm radial gap remains generous for horizontal-hole shrinkage.
clear_radial = 0.25;
eye_inner_d = post_d + 2 * clear_radial;
eye_outer_d = 14.0;

// Clipless bayonet retention. A single inside/arm-side bore recess admits the
// fixed peg nub only at the installation angle. The outer eye ring stays
// continuous; rotation puts intact bore material behind the nub.
bayonet_lug_outer_r = 5.00;
// A symmetric one-nozzle-wide outer tip is simpler and more reliable than a
// barely visible one-sided taper. The structural root remains 1.80 mm wide.
bayonet_lug_tip_w = 0.60;
bayonet_key_radial_clear = 0.50;
// Preserve the approved 2.00 mm notch height where it meets the bore. At the
// outer mouth, its flat lower edge and diagonal upper roof leave 0.30 mm above
// the symmetric tip and 0.70 mm below it.
bayonet_notch_outer_r = bayonet_lug_outer_r + bayonet_key_radial_clear;
bayonet_notch_w = 2.00;
bayonet_notch_upper_mouth_clear = 0.30;
bayonet_notch_lower_z = -bayonet_notch_w / 2;
bayonet_notch_upper_bore_z = bayonet_notch_w / 2;
bayonet_notch_upper_mouth_z =
    bayonet_lug_tip_w / 2 + bayonet_notch_upper_mouth_clear;
bayonet_notch_bore_x =
    -sqrt(pow(eye_inner_d / 2, 2) - pow(bayonet_notch_upper_bore_z, 2));

latch_t = 3.4;
pivot_x = 4.0;

corral_clear_w_x = 41.5;
corral_clear_d_y = 13.0;
corral_wall_t = 1.2;
corral_depth_z = 8.0;
corral_floor_t = 1.2;
corral_end_wall_t_x = 5.0;
canonical_weight_center_x = -27.0;

// Match the installed latch plane used by the canonical wall rig.
standoff_h = 0.8;
post_h = 4.0;
corral_global_outer_y1 = -0.30;
corral_center_y_target = corral_global_outer_y1
                         - (corral_clear_d_y + 2 * corral_wall_t) / 2;
pad_t = -corral_center_y_target - standoff_h - post_h / 2;
post_y1 = -pad_t - standoff_h - post_h;
latch_install_y = post_y1 + (post_h - latch_t) / 2;

corral_inner_x0 = canonical_weight_center_x - corral_clear_w_x / 2;
corral_inner_x1 = canonical_weight_center_x + corral_clear_w_x / 2;
corral_floor_x0 = corral_inner_x0 - corral_end_wall_t_x;
corral_floor_x1 = corral_inner_x1 + corral_wall_t;

corral_outer_y1 = corral_global_outer_y1 - latch_install_y;
corral_inner_y1 = corral_outer_y1 - corral_wall_t;
corral_inner_y0 = corral_inner_y1 - corral_clear_d_y;
corral_outer_y0 = corral_inner_y0 - corral_wall_t;

installed_corral_yc = latch_install_y
                      + (corral_inner_y0 + corral_inner_y1) / 2;
installed_eye_yc = latch_install_y + latch_t / 2;

corral_floor_z0 = -0.90;
corral_floor_z = corral_floor_z0 + corral_floor_t;
corral_wall_z1 = corral_floor_z + corral_depth_z;
pivot_z = (corral_floor_z0 + corral_wall_z1) / 2;
pivot_eye_flat_local_z = corral_floor_z0 - pivot_z;

pivot_transition_x0 = corral_floor_x1;
pivot_transition_x1 = pivot_x - (eye_inner_d / 2 + 0.25);

// Far-end Y-retention socket. The matching roof-hung tooth belongs to the
// fixed wall rig; this socket is open at the top so the latch disengages
// cleanly as it swings downward.
latch_key_tooth_w_x = 1.4;
latch_key_tooth_w_y = 3.0;
latch_key_clear_xy = 0.60;
latch_key_clear_z = 0.60;
latch_key_engagement_z = 3.0;

latch_key_xc = (corral_floor_x0 + corral_inner_x0) / 2;
latch_key_local_yc = (corral_outer_y0 + corral_outer_y1) / 2;
latch_key_notch_x0 = latch_key_xc - latch_key_tooth_w_x / 2
                     - latch_key_clear_xy;
latch_key_notch_x1 = latch_key_xc + latch_key_tooth_w_x / 2
                     + latch_key_clear_xy;
latch_key_notch_y0 = latch_key_local_yc - latch_key_tooth_w_y / 2
                     - latch_key_clear_xy;
latch_key_notch_y1 = latch_key_local_yc + latch_key_tooth_w_y / 2
                     + latch_key_clear_xy;
latch_key_notch_z0 = corral_wall_z1 - latch_key_engagement_z
                     - latch_key_clear_z;

// =========================================================
// HELPERS
// =========================================================
module rect_prism(x0, x1, y0, y1, z0, z1) {
    translate([min(x0, x1), min(y0, y1), min(z0, z1)])
        cube([abs(x1 - x0), abs(y1 - y0), abs(z1 - z0)]);
}

module cyl_y_span(d, y0, y1) {
    translate([0, max(y0, y1), 0])
        rotate([90, 0, 0])
            cylinder(d=d, h=abs(y1 - y0), center=false);
}

// =========================================================
// PRINTABLE PARTS
// =========================================================
module canonical_latch_core() {
    translate([pivot_x, 0, pivot_z])
        difference() {
            cyl_y_span(eye_outer_d, 0, latch_t);
            cyl_y_span(eye_inner_d, -0.1, latch_t + 0.2);

            // Flatten only the unused lower eye arc so the complete latch
            // prints on the same plane as the corral floor.
            rect_prism(-eye_outer_d / 2 - 1,
                       eye_outer_d / 2 + 1,
                       -0.1, latch_t + 0.2,
                       -eye_outer_d / 2 - 1,
                       pivot_eye_flat_local_z);
        }
}

module fn_weight_corral() {
    difference() {
        union() {
            // Shallow floor beneath the weight pocket and keyed extension.
            rect_prism(corral_floor_x0, corral_floor_x1,
                       corral_outer_y0, corral_outer_y1,
                       corral_floor_z0, corral_floor_z);

            // Viewer-facing wall. The frame wall closes the opposite side.
            rect_prism(corral_inner_x0, corral_inner_x1,
                       corral_outer_y0, corral_inner_y0,
                       corral_floor_z, corral_wall_z1);

            // Matching opposite wall for either cassette orientation. It rises
            // directly from the existing floor, so the established flat-floor
            // print orientation gains no bridge or unsupported shelf. At
            // 1.2 mm it is two nominal lines with a 0.6 mm nozzle.
            rect_prism(corral_inner_x0, corral_inner_x1,
                       corral_inner_y1, corral_outer_y1,
                       corral_floor_z, corral_wall_z1);

            // Pivot-side wall.
            rect_prism(corral_inner_x1, corral_floor_x1,
                       corral_outer_y0, corral_outer_y1,
                       corral_floor_z, corral_wall_z1);

            // Substantial far-end wall carrying the retention socket.
            rect_prism(corral_floor_x0, corral_inner_x0,
                       corral_outer_y0, corral_outer_y1,
                       corral_floor_z, corral_wall_z1);

            // Compact load path from the corral into the pivot eye.
            rect_prism(pivot_transition_x0, pivot_transition_x1,
                       0, latch_t,
                       corral_floor_z0, corral_wall_z1);
        }

        rect_prism(latch_key_notch_x0, latch_key_notch_x1,
                   latch_key_notch_y0, latch_key_notch_y1,
                   latch_key_notch_z0, corral_wall_z1 + eps);
    }
}

module swinging_latch() {
    difference() {
        union() {
            canonical_latch_core();
            fn_weight_corral();
        }

        // One asymmetric keyway cut after the eye and transition are united:
        // flat lower edge, printable diagonal upper roof, and full clearance
        // at the bore. No later union can fill the subtraction back in.
        translate([pivot_x,0,pivot_z])
            translate([0, latch_t + 0.1, 0])
                rotate([90,0,0])
                    linear_extrude(height = latch_t + 0.2)
                        polygon(points = [
                            [-bayonet_notch_outer_r, bayonet_notch_lower_z],
                            [0, bayonet_notch_lower_z],
                            [0, bayonet_notch_upper_bore_z],
                            [bayonet_notch_bore_x,
                             bayonet_notch_upper_bore_z],
                            [-bayonet_notch_outer_r,
                             bayonet_notch_upper_mouth_z]
                        ]);
    }
}

assert(corral_clear_w_x == 41.5);
assert(corral_clear_d_y == 13.0);
assert(pivot_transition_x1 > pivot_transition_x0);
assert(abs(installed_corral_yc + 8.0) < eps,
       "pen/weight pocket no longer uses the measured Y=-8 mm centerline");
assert(abs(installed_eye_yc - installed_corral_yc) < eps,
       "pen/weight pocket is no longer centered on the pivot eye");
assert(abs((corral_inner_y1-corral_inner_y0) - corral_clear_d_y) < eps,
       "opposite wall changed the 13 mm clear pocket depth");
assert(eye_outer_d / 2 - bayonet_notch_outer_r >= 1.49,
       "inside notch must preserve the continuous outer eye ring");
assert(bayonet_lug_outer_r - eye_inner_d / 2 >= 0.8,
       "bayonet lug has too little radial retention engagement");

swinging_latch();
