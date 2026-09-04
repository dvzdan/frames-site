// DOUBLE TAKE FRAMES DESIGN RELEASE
// DTF_RELEASE: 2.0.2
// Released: 2026-09-04
// Versioning: Semantic Versioning 2.0.0 (https://semver.org/)
// Status: CANONICAL
// Changes in 2.0.2:
// - Carried forward unchanged for the native 3MF packaging hotfix.
// Changes in 2.0.1:
// - Carried forward unchanged for the prepared-project packaging correction.
// Changes in 2.0.0:
// - Carried forward without geometry changes for the coordinated 2.0.0 release.
// Full release notes: https://doubletakeframes.com/build/#design-release
//
$fn = 96;
eps = 0.05;

// =========================================================
// DETACHABLE FRONT BAND + SIDE WALLS + REAR POSTS + FEETS
// Continuous low rail all around.
// Side walls sit on rail but do not connect to front/back above rail.
// Non-friction resting fit.
//
// Corrected:
// - Feet overlap collar/body in Z by foot_body_z_overlap, not just eps.
// - Each foot is shifted a few mm inward under the basket while keeping
//   the original front/rear foot depth.
// =========================================================

inch = 25.4;

// CASSETTE REFERENCE VALUES
cassette_w = 6.91 * inch;

bottom_t    = 3.0;
wall_t      = 3.0;
wall_offset = 0.0;

front_frame_t    = 1.2;
acrylic_gap      = 1.0;
spacer_thickness = 7.0;

front_buildout_total = front_frame_t + acrylic_gap + spacer_thickness;
front_buildout_y0    = wall_offset - front_buildout_total;

roller_r    = 0.75 * inch;
glide_t     = 2.0;
fang_embed  = 0.6;
rail_back_y = 8.0;
roller_cy   = wall_offset + wall_t;

glide_y  = roller_cy + roller_r - glide_t - fang_embed;
bottom_d = glide_y + glide_t + rail_back_y;

backing_board_extra_y = 1/20 * inch;

cassette_x0 = 0;
cassette_x1 = cassette_w;
cassette_y0 = front_buildout_y0;
cassette_y1 = bottom_d + backing_board_extra_y;

// FIT / GEOMETRY
clear_x = 0.3;
clear_y = 0.25;

collar_t = 2.4;

foot_h = 5.0;
foot_body_z_overlap = 1.0;
collar_z0 = foot_h - foot_body_z_overlap;

collar_h = 34.0;
side_wall_h = 18.0;
inner_x0 = cassette_x0 - clear_x;
inner_x1 = cassette_x1 + clear_x;
inner_y0 = cassette_y0 - clear_y;
inner_y1 = cassette_y1 + clear_y;

outer_x0 = inner_x0 - collar_t;
outer_x1 = inner_x1 + collar_t;
outer_y0 = inner_y0 - collar_t;
outer_y1 = inner_y1 + collar_t;

// RESTING LEDGE
rest_lip_t = 4.0;
rest_lip_h = 2.0;

// LOW RAIL
low_rail_h = 12.0;

// SIDE WALLS
side_wall_gap_front = 8.0;
side_wall_gap_rear  = 8.0;
side_wall_t = collar_t;

// REAR POSTS
rear_post_w = 7.0;
rear_post_t = collar_t;
post_bevel = 0.8;

// Localized friction take-up on the three rear backing-board capture posts.
// These project into the existing Y clearance without moving the posts or
// tightening the stand's overall envelope. The upper ramp eases insertion.
rear_post_friction_pad_d = 0.20;
rear_post_friction_pad_w = 3.5;
rear_post_friction_pad_z0 = collar_z0 + low_rail_h - 2.0;
rear_post_friction_pad_z1 = collar_z0 + collar_h - post_bevel;
rear_post_friction_ramp_h = 5.0;

// FEET
front_foot_proj = 16.0;
rear_foot_proj  = 18.0;

front_foot_w = 18.0;
rear_foot_w  = 24.0;

front_foot_inset_x = 16.0;
foot_round = 2.0;

// How far the inner edge of each foot reaches under the basket.
// Original effectively stopped ~0.6 mm short of the inner edge.
foot_y_overlap = 3.0;

// HELPERS
module rounded_rect_prism(x0, x1, y0, y1, z0, z1, r=2) {
    hull() {
        translate([x0+r, y0+r, z0]) cylinder(r=r, h=z1-z0);
        translate([x1-r, y0+r, z0]) cylinder(r=r, h=z1-z0);
        translate([x0+r, y1-r, z0]) cylinder(r=r, h=z1-z0);
        translate([x1-r, y1-r, z0]) cylinder(r=r, h=z1-z0);
    }
}

module beveled_post(xsz, ysz, h, b) {
    bx = min(b, xsz/2 - eps);
    by = min(b, ysz/2 - eps);

    union() {
        cube([xsz, ysz, h - b]);

        translate([0, 0, h - b])
        hull() {
            cube([xsz, ysz, eps]);

            translate([bx, by, b])
                cube([
                    max(eps, xsz - 2*bx),
                    max(eps, ysz - 2*by),
                    eps
                ]);
        }
    }
}

// FRONT BAND
module front_band() {
    translate([outer_x0, outer_y0, collar_z0])
        cube([
            outer_x1 - outer_x0,
            collar_t,
            collar_h
        ]);
}

// CONTINUOUS LOW RAIL
module front_low_rail() {
    translate([outer_x0, outer_y0, collar_z0])
        cube([outer_x1 - outer_x0, collar_t, low_rail_h]);
}

module left_low_rail() {
    translate([outer_x0, outer_y0, collar_z0])
        cube([collar_t, outer_y1 - outer_y0, low_rail_h]);
}

module right_low_rail() {
    translate([outer_x1 - collar_t, outer_y0, collar_z0])
        cube([collar_t, outer_y1 - outer_y0, low_rail_h]);
}

module rear_low_rail() {
    translate([outer_x0, outer_y1 - collar_t, collar_z0])
        cube([outer_x1 - outer_x0, collar_t, low_rail_h]);
}

module low_rails() {
    // front rail overlaps lower part of front band; harmless and strengthens base
    front_low_rail();
    left_low_rail();
    right_low_rail();
    rear_low_rail();
}

// SIDE WALLS
module left_side_wall() {
    y0 = inner_y0 + side_wall_gap_front;
    y1 = inner_y1 - side_wall_gap_rear;

    translate([outer_x0, y0, collar_z0])
        cube([
            side_wall_t,
            y1 - y0,
            side_wall_h
        ]);
}

module right_side_wall() {
    y0 = inner_y0 + side_wall_gap_front;
    y1 = inner_y1 - side_wall_gap_rear;

    translate([inner_x1, y0, collar_z0])
        cube([
            side_wall_t,
            y1 - y0,
            side_wall_h
        ]);
}

// REAR POSTS
module rear_post(x_center) {
    translate([x_center - rear_post_w/2, inner_y1, collar_z0])
        beveled_post(rear_post_w, rear_post_t, collar_h, post_bevel);
}

module rear_post_friction_pad(x_center) {
    pad_x0 = x_center - rear_post_friction_pad_w/2;
    full_pad_y0 = inner_y1 - rear_post_friction_pad_d;
    ramp_z0 = rear_post_friction_pad_z1 - rear_post_friction_ramp_h;

    hull() {
        translate([pad_x0, full_pad_y0, rear_post_friction_pad_z0])
            cube([rear_post_friction_pad_w, rear_post_friction_pad_d + eps, eps]);
        translate([pad_x0, full_pad_y0, ramp_z0])
            cube([rear_post_friction_pad_w, rear_post_friction_pad_d + eps, eps]);
        translate([pad_x0, inner_y1 - eps, rear_post_friction_pad_z1])
            cube([rear_post_friction_pad_w, 2*eps, eps]);
    }
}

module rear_posts() {
    left_post_x = inner_x0 + 18.0;
    center_post_x = (inner_x0 + inner_x1) / 2;
    right_post_x = inner_x1 - 18.0;

    rear_post(left_post_x);
    rear_post(center_post_x);
    rear_post(right_post_x);

    rear_post_friction_pad(left_post_x);
    rear_post_friction_pad(center_post_x);
    rear_post_friction_pad(right_post_x);
}

// BOTTOM RESTING LEDGE
module bottom_rest_lip() {
    translate([inner_x0, inner_y0, collar_z0])
        cube([inner_x1 - inner_x0, rest_lip_t, rest_lip_h]);

    translate([inner_x0, inner_y1 - rest_lip_t, collar_z0])
        cube([inner_x1 - inner_x0, rest_lip_t, rest_lip_h]);

    translate([inner_x0, inner_y0, collar_z0])
        cube([rest_lip_t, inner_y1 - inner_y0, rest_lip_h]);

    translate([inner_x1 - rest_lip_t, inner_y0, collar_z0])
        cube([rest_lip_t, inner_y1 - inner_y0, rest_lip_h]);
}

// FEET
module front_left_foot() {
    x0 = outer_x0 + front_foot_inset_x;
    x1 = x0 + front_foot_w;

    // Same foot depth as original, shifted inward for a few mm of underlap.
    y1 = inner_y0 + foot_y_overlap;
    y0 = y1 - front_foot_proj;

    rounded_rect_prism(x0, x1, y0, y1, 0, foot_h, foot_round);
}

module front_right_foot() {
    x1 = outer_x1 - front_foot_inset_x;
    x0 = x1 - front_foot_w;

    // Same foot depth as original, shifted inward for a few mm of underlap.
    y1 = inner_y0 + foot_y_overlap;
    y0 = y1 - front_foot_proj;

    rounded_rect_prism(x0, x1, y0, y1, 0, foot_h, foot_round);
}

module rear_center_foot() {
    x0 = (outer_x0 + outer_x1)/2 - rear_foot_w/2;
    x1 = x0 + rear_foot_w;

    // Same foot depth as original, shifted inward for a few mm of underlap.
    y0 = inner_y1 - foot_y_overlap;
    y1 = y0 + rear_foot_proj;

    rounded_rect_prism(x0, x1, y0, y1, 0, foot_h, foot_round);
}

// FINAL
union() {
    front_band();
    low_rails();

    left_side_wall();
    right_side_wall();
    rear_posts();

    bottom_rest_lip();

    front_left_foot();
    front_right_foot();
    rear_center_foot();
}
