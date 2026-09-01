// DOUBLE TAKE FRAMES DESIGN RELEASE
// DTF_RELEASE: 2.0.0
// Released: 2026-08-31
// Versioning: Semantic Versioning 2.0.0 (https://semver.org/)
// Status: CANONICAL
// Changes in 2.0.0:
// - Carried forward without geometry changes for the coordinated 2.0.0 release.
// Full release notes: https://doubletakeframes.com/build/#design-release
//
$fn = 96;

eps = 0.05;

// 0 = separated printable latch and keeper
// 1 = FN-weight latch only
// 2 = C-shaped keeper only
render_part = 0;

// =========================================================
// FN WEIGHT LATCH
// =========================================================
post_d = 5.5;
clear_radial = 0.22;
eye_inner_d = post_d + 2 * clear_radial;
eye_outer_d = 13.0;

latch_t = 3.4;
pivot_x = 4.0;

corral_clear_w_x = 41.5;
corral_clear_d_y = 13.0;
corral_wall_t = 1.2;
corral_depth_z = 8.0;
corral_floor_t = 1.2;
corral_end_wall_t_x = 5.0;
canonical_weight_center_x = -27.0;

// Match the installed latch plane used by the canonical dry-wall rig.
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

corral_floor_z0 = -0.90;
corral_floor_z = corral_floor_z0 + corral_floor_t;
corral_wall_z1 = corral_floor_z + corral_depth_z;
pivot_z = (corral_floor_z0 + corral_wall_z1) / 2;
pivot_eye_flat_local_z = corral_floor_z0 - pivot_z;

pivot_transition_x0 = corral_floor_x1;
pivot_transition_x1 = pivot_x - (eye_inner_d / 2 + 0.25);

// Far-end Y-retention socket. The matching roof-hung tooth belongs to the
// fixed dry-wall rig; this socket is open at the top so the latch disengages
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
// C-SHAPED KEEPER
// =========================================================
clip_outer_d = 10.0;
clip_t = 1.8;
grip_hole_d = 4.65;
gap_w = 2.8;
flat_depth = 1.5;

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
    union() {
        canonical_latch_core();
        fn_weight_corral();
    }
}

module c_keeper() {
    difference() {
        cyl_y_span(clip_outer_d, 0, clip_t);
        cyl_y_span(grip_hole_d, -0.1, clip_t + 0.2);

        rect_prism(0, clip_outer_d / 2 + 0.5,
                   -0.1, clip_t + 0.1,
                   -gap_w / 2, gap_w / 2);

        rect_prism(grip_hole_d / 2 - 0.2,
                   grip_hole_d / 2 - 0.2 + flat_depth,
                   -0.1, clip_t + 0.1,
                   -gap_w / 2 - 0.4, gap_w / 2 + 0.4);
    }
}

assert(corral_clear_w_x == 41.5);
assert(corral_clear_d_y == 13.0);
assert(pivot_transition_x1 > pivot_transition_x0);

if (render_part == 1)
    swinging_latch();
else if (render_part == 2)
    c_keeper();
else {
    swinging_latch();
    translate([18, 0, 0]) c_keeper();
}
