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
// - Uses captive 16 mm flanges coordinated with the revised clock-string guide.
// - Adds keyed bottom-flange loading slots and revised string anchors.
// Full release notes: https://doubletakeframes.com/build/#design-release
//
// Canonical captive-flange capstans.
//
// The capstans use 16 mm flanges. The hour horn is moved outward to suit that
// flange, and the upside-down minute capstan uses a recessed orientation mark.
// Canonical bores, drum geometry, heights, and the eyelet's 9 mm datum remain.

$fn = 32;
eps = 0.05;

// Selected fits retained from canonical. These modeled bores deliberately
// differ from the supplied movement-member ODs: 3.17 mm inner and 5.05 mm
// middle. They are fit dimensions, not transcriptions of movement specs.
minute_bore_d = is_undef(shared_minute_capstan_bore_d)
    ? 3.40 : shared_minute_capstan_bore_d;
hour_bores = [5.15];
minute_lower_clearance_d = 5.92;
minute_lower_clearance_h = 3.0; // Preserve canonical transition datum.

// Main geometry. The added height moves only the upper flange; established
// lower seating, anchor, and minute-bore-transition datums remain unchanged.
canonical_total_h = 5.0;
total_h = is_undef(shared_capstan_total_h)
    ? 6.0 : shared_capstan_total_h;
flange_h = 0.80;
drum_d = 7.4; // Printed winding-drum OD; unrelated to movement sleeve specs.
flange_d = is_undef(shared_capstan_flange_d)
    ? 16.0 : shared_capstan_flange_d; // MOCKUP: canonical is 9.0
eyelet_reference_flange_d = 9.0; // Keep canonical eyelet outer position.
bore_mouth_extra = 0.35;
bore_mouth_h = 0.55;
part_spacing_x = flange_d+1;     // Preserve 1 mm between enlarged parts.

// Bottom-flange installation key. It shares the fixed beak/string-anchor
// radial datum (+Y) and cannot accept the beak when the capstan is upside down.
bottom_insertion_notch_enabled = is_undef(shared_bottom_insertion_notch_enabled)
    ? true : shared_bottom_insertion_notch_enabled;
bottom_insertion_notch_clearance_per_side =
    is_undef(shared_beak_notch_clearance_per_side)
        ? 0.40 : shared_beak_notch_clearance_per_side;
bottom_insertion_notch_w_x =
    (is_undef(shared_beak_tangential_w) ? 4.0 : shared_beak_tangential_w)
    + 2*bottom_insertion_notch_clearance_per_side;

// ---------- sacrificial print supports ----------

breakaway_supports_enabled = false;
breakaway_support_count = 6;
breakaway_post_radius = 7.3;
breakaway_body_d = 1.2;
breakaway_neck_d = 0.65;
breakaway_neck_h = 0.30;

// Existing external string anchor retained unchanged.
string_eyelet_enabled = true;
string_eyelet_flange_gap_z = 0.60;
string_eyelet_w_x = 1.8;
string_eyelet_drum_overlap_y = 0.20;
string_eyelet_beyond_flange_y = is_undef(shared_string_eyelet_beyond_flange_y)
    ? 0.65 : shared_string_eyelet_beyond_flange_y;
string_eyelet_inner_face_h_z = 2.35;
string_eyelet_outer_face_h_z = 1.85;
string_eyelet_wall_z = 0.35;
string_eyelet_outer_wall_y = 0.8;    // Retain canonical hook-tip strength.
string_eyelet_void_inset_y = 0.70;

// Hour indicator horn: canonical size shifted radially toward the 16 mm rim.
indicator_horn_enabled = true;
indicator_horn_inner_y = 6.05;
indicator_horn_outer_y = 7.25;
indicator_horn_w_x = 0.90;
indicator_horn_h_z = 1.00;
indicator_horn_taper_y = 0.30;

// Bed-facing rounded orientation mark for the upside-down minute capstan.
// It stays inside the retaining rim and does not cut through the 0.8 mm flange.
minute_mark_w_x = 1.6;
minute_mark_y0 = 4.8;
minute_mark_y1 = 6.9;
minute_mark_depth_z = 0.40;

module cyl(d, h, z=0) {
    translate([0, 0, z]) cylinder(d=d, h=h);
}

module prism_x(points_yz, w_x) {
    n = len(points_yz);
    polyhedron(
        points = concat(
            [for (p = points_yz) [-w_x/2, p[0], p[1]]],
            [for (p = points_yz) [ w_x/2, p[0], p[1]]]
        ),
        faces = concat(
            [[for (i = [n-1:-1:0]) i]],
            [[for (i = [0:n-1]) i+n]],
            [for (i = [0:n-1]) [i, (i+1)%n, ((i+1)%n)+n, i+n]]
        )
    );
}

module top_indicator_horn(enabled=indicator_horn_enabled) {
    if (enabled)
        prism_x(
            [
                [indicator_horn_inner_y, total_h],
                [indicator_horn_outer_y, total_h],
                [indicator_horn_outer_y-indicator_horn_taper_y, total_h+indicator_horn_h_z],
                [indicator_horn_inner_y, total_h+indicator_horn_h_z]
            ],
            indicator_horn_w_x
        );
}

function eyelet_channel_z0() = flange_h + string_eyelet_flange_gap_z;
function eyelet_channel_z1() = total_h - flange_h - string_eyelet_flange_gap_z;
function eyelet_mid_z() = total_h/2; // Recenter with beak in widened gap.
function eyelet_inner_y() = drum_d/2 - string_eyelet_drum_overlap_y;
function eyelet_outer_y() = eyelet_reference_flange_d/2 + string_eyelet_beyond_flange_y;
function eyelet_inner_z0() = eyelet_mid_z() - string_eyelet_inner_face_h_z/2;
function eyelet_inner_z1() = eyelet_mid_z() + string_eyelet_inner_face_h_z/2;
function eyelet_outer_z0() = eyelet_mid_z() - string_eyelet_outer_face_h_z/2;
function eyelet_outer_z1() = eyelet_mid_z() + string_eyelet_outer_face_h_z/2;
function eyelet_void_inner_y() = drum_d/2 - string_eyelet_void_inset_y;
function eyelet_void_outer_y() = eyelet_outer_y() - string_eyelet_outer_wall_y;
function eyelet_void_inner_z0() = eyelet_inner_z0() + string_eyelet_wall_z;
function eyelet_void_inner_z1() = eyelet_inner_z1() - string_eyelet_wall_z;
function eyelet_void_outer_z0() = eyelet_outer_z0() + string_eyelet_wall_z;
function eyelet_void_outer_z1() = eyelet_outer_z1() - string_eyelet_wall_z;

module flipped_trapezoid_eyelet_solid_body() {
    intersection() {
        prism_x(
            [
                [eyelet_inner_y(), eyelet_inner_z0()],
                [eyelet_outer_y(), eyelet_outer_z0()],
                [eyelet_outer_y(), eyelet_outer_z1()],
                [eyelet_inner_y(), eyelet_inner_z1()]
            ],
            string_eyelet_w_x
        );
        translate([0, 0, total_h/2])
            cube([flange_d+2, flange_d+2, eyelet_channel_z1()-eyelet_channel_z0()], center=true);
    }
}

module flipped_trapezoid_eyelet_inner_polygon_void() {
    prism_x(
        [
            [eyelet_void_inner_y(), eyelet_void_inner_z0()],
            [eyelet_void_outer_y(), eyelet_void_outer_z0()],
            [eyelet_void_outer_y(), eyelet_void_outer_z1()],
            [eyelet_void_inner_y(), eyelet_void_inner_z1()]
        ],
        string_eyelet_w_x + 2*eps
    );
}

module polygon_cut_flipped_trapezoid_eyelet() {
    difference() {
        flipped_trapezoid_eyelet_solid_body();
        flipped_trapezoid_eyelet_inner_polygon_void();
    }
}

module bottom_insertion_notch() {
    if (bottom_insertion_notch_enabled)
        translate([0, 0, -eps])
            linear_extrude(height=flange_h+2*eps)
                hull() {
                    // Rounded inner end is tangent to the drum: no drum cut.
                    translate([0, drum_d/2+bottom_insertion_notch_w_x/2])
                        circle(d=bottom_insertion_notch_w_x);
                    // Carry the slot completely through the outer flange rim.
                    translate([0, flange_d/2+bottom_insertion_notch_w_x/2])
                        circle(d=bottom_insertion_notch_w_x);
                }
}

module capstan_shell(with_indicator_horn=true) {
    difference() {
        union() {
            cyl(drum_d, total_h);
            cyl(flange_d, flange_h);
            cyl(flange_d, flange_h, total_h-flange_h);
            if (string_eyelet_enabled) polygon_cut_flipped_trapezoid_eyelet();
            top_indicator_horn(with_indicator_horn && indicator_horn_enabled);
        }
        bottom_insertion_notch();
    }
}

module minute_orientation_mark() {
    translate([0, 0, total_h-minute_mark_depth_z])
        linear_extrude(height=minute_mark_depth_z+eps)
            hull()
                for (mark_y = [minute_mark_y0, minute_mark_y1])
                    translate([0, mark_y])
                        circle(d=minute_mark_w_x);
}

module minute_capstan() {
    difference() {
        // Printed upside down; omit the horn so the lower cavity prints cleanly.
        capstan_shell(with_indicator_horn=false);
        translate([0, 0, -eps])
            cylinder(d=minute_lower_clearance_d,
                     h=minute_lower_clearance_h+eps);
        translate([0, 0, -eps])
            cylinder(d=minute_lower_clearance_d+bore_mouth_extra, h=bore_mouth_h+eps);
        translate([0, 0, minute_lower_clearance_h])
            cylinder(d=minute_bore_d,
                     h=total_h-minute_lower_clearance_h+eps);
        minute_orientation_mark();
    }
}

module hour_capstan(bore_d=5.15) {
    difference() {
        capstan_shell(with_indicator_horn=true);
        translate([0, 0, -eps])
            cylinder(d=bore_d, h=total_h+2*eps);
        translate([0, 0, -eps])
            cylinder(d=bore_d+bore_mouth_extra, h=bore_mouth_h+eps);
    }
}

module breakaway_post(angle) {
    post_xy = [
        breakaway_post_radius*cos(angle),
        breakaway_post_radius*sin(angle)
    ];
    lower_flange_z1 = flange_h;
    upper_flange_z0 = total_h-flange_h;
    body_z0 = lower_flange_z1+breakaway_neck_h;
    body_z1 = upper_flange_z0-breakaway_neck_h;

    // Bottom snip neck, short rigid body, and top snip neck. The body remains
    // at the accessible outer edge and never approaches the eyelet sweep.
    translate([post_xy[0], post_xy[1], lower_flange_z1-eps])
        cylinder(d=breakaway_neck_d, h=breakaway_neck_h+eps);
    translate([post_xy[0], post_xy[1], body_z0-eps])
        cylinder(d=breakaway_body_d, h=body_z1-body_z0+2*eps);
    translate([post_xy[0], post_xy[1], body_z1])
        cylinder(d=breakaway_neck_d, h=breakaway_neck_h+eps);
}

module breakaway_post_set() {
    if (breakaway_supports_enabled)
        for (i=[0:breakaway_support_count-1])
            breakaway_post(i*360/breakaway_support_count);
}

module minute_capstan_print_layout() {
    // Former horn face on the bed; the recessed marker becomes a bed imprint.
    translate([0, 0, total_h])
        rotate([180, 0, 0])
            minute_capstan();
    breakaway_post_set();
}

module hour_capstan_print_layout(bore_d=5.15) {
    hour_capstan(bore_d);
    breakaway_post_set();
}

// Render minute + hour, matching the canonical file's deliverable pattern.
minute_capstan_print_layout();
for (i=[0:len(hour_bores)-1])
    translate([(i+1)*part_spacing_x, 0, 0])
        hour_capstan_print_layout(hour_bores[i]);
