// DOUBLE TAKE FRAMES DESIGN RELEASE
// DTF_RELEASE: 2.0.1
// Released: 2026-09-02
// Versioning: Semantic Versioning 2.0.0 (https://semver.org/)
// Status: CANONICAL
// Changes in 2.0.1:
// - Carried forward unchanged for the prepared-project packaging correction.
// Changes in 2.0.0:
// - Coordinates the guide with captive 16 mm-flange capstans.
// - Adds the closed beak, stationary floor, and keyed string-loading geometry.
// Full release notes: https://doubletakeframes.com/build/#design-release
//
// Canonical captive-beak clock-string guide.
//
// The canonical bar and boss are unchanged. A closed wedge grows directly out
// of the pressure-bar wall and guides the string into the flange cavity.

$fn = 64;
eps = 0.05;

// Canonical pressure bar.
clock_bar_len_x = is_undef(shared_clock_guide_len_x)
    ? 58.0 : shared_clock_guide_len_x;
clock_bar_t_y = 3.0;
clock_bar_h_z = 21.0;
canonical_clock_bar_hole_d = 15.0;
capstan_flange_d = is_undef(shared_capstan_flange_d)
    ? 16.0 : shared_capstan_flange_d;
capstan_flange_clearance_r = is_undef(shared_capstan_flange_clearance_r)
    ? 0.5 : shared_capstan_flange_clearance_r;
clock_bar_hole_d = capstan_flange_d+2*capstan_flange_clearance_r;
clock_bar_hole_z_offset = -0.06;
end_chamfer_y = 1.2;

// One thickness boundary: inside this footprint the guide is the shared
// 0.8 mm stationary floor; immediately outside it the canonical 3 mm bar
// remains full thickness. The extra radial millimeter is the fused tie-in.
flange_relief_d = clock_bar_hole_d + 2*(
    is_undef(shared_stationary_floor_attachment_overlap_r)
        ? 1.0 : shared_stationary_floor_attachment_overlap_r
);
flange_relief_remaining_y = is_undef(shared_stationary_floor_thickness)
    ? 0.8 : shared_stationary_floor_thickness;
flange_relief_beak_spine_w_x = 6.2;
boss_crown_keystone_tip_w_x = 1.6;
boss_crown_keystone_top_w_x = flange_relief_beak_spine_w_x;

// Stationary movement-collar addition.
// Supplied snap-in/no-thread movement image: outer stationary member 6.8 mm,
// middle rotating member 5.05 mm, and inner rotating member 3.17 mm. These are
// movement sleeve/shaft ODs, not printed capstan winding-drum diameters.
// Keep any desired printed snap interference separate from the part datum.
stationary_collar_addition_enabled = true;
stationary_collar_spec_d = is_undef(shared_stationary_collar_d)
    ? 6.8 : shared_stationary_collar_d;
stationary_collar_bore_fit_allowance =
    is_undef(shared_stationary_collar_bore_fit_allowance)
        ? 0.0 : shared_stationary_collar_bore_fit_allowance;
stationary_collar_bore_d = stationary_collar_spec_d
    + stationary_collar_bore_fit_allowance;
stationary_pad_thickness_y = is_undef(shared_stationary_floor_thickness)
    ? 0.8 : shared_stationary_floor_thickness;
stationary_pad_flange_envelope_d = clock_bar_hole_d; // 17 mm: 0.5 mm/side.
stationary_pad_attachment_overlap_r =
    is_undef(shared_stationary_floor_attachment_overlap_r)
        ? 1.0 : shared_stationary_floor_attachment_overlap_r;
stationary_pad_outer_d = stationary_pad_flange_envelope_d
    + 2*stationary_pad_attachment_overlap_r;

// Canonical string-feed boss.
string_boss_w_x = 6.0;
string_boss_d_y = 4.0;
string_boss_h_z = 1.6;
string_hole_d = 2.5;
string_boss_xc = 0;
string_boss_y0 = clock_bar_t_y/2 - 0.2;
string_boss_z0 = clock_bar_h_z/2 - string_boss_h_z;
string_hole_xc = string_boss_xc;
string_hole_yc = string_boss_y0 + string_boss_d_y/2;

// Both root and tip penetrate the wall's +Y face. This eliminates the floating
// underside and closes the former side escape openings.
beak_root_xc = string_hole_xc;
beak_tip_xc = string_hole_xc;
beak_wall_y = clock_bar_t_y/2-0.30;
beak_root_front_y = string_hole_yc+string_hole_d/2+0.25;
beak_axial_center_shift_y = is_undef(shared_beak_axial_center_shift)
    ? 0.50 : shared_beak_axial_center_shift;
// In the final assembly guide-local +Y becomes eventual -Z. Keep this
// projection independently registered to the wall and loading-hole geometry.
// Inside the flange envelope, minimize flange-normal thickness and recover
// stiffness with tangential width. The 1 mm channel intentionally opens into
// a groove here; the two capstan flanges provide axial containment.
beak_tip_d_y = 0.80;
beak_tip_front_y = 3.60+beak_axial_center_shift_y;
beak_tip_back_y = beak_tip_front_y-beak_tip_d_y;
beak_tip_yc = (beak_tip_back_y+beak_tip_front_y)/2;
beak_root_yc = (beak_wall_y+beak_root_front_y)/2;
beak_root_d_y = beak_root_front_y-beak_wall_y;
beak_root_z = string_boss_z0+0.1;
beak_root_w_x = 5.0;
beak_root_h_z = 1.5;
beak_tip_shoulder_w_x = is_undef(shared_beak_tangential_w)
    ? 4.0 : shared_beak_tangential_w;
beak_tip_apex_w_x = 0.8*beak_tip_shoulder_w_x;
beak_tip_taper_h_z = 0.60;

// Cassette +Y datum assumption (tune from the physical movement): spindle and
// top flange are approximately coplanar at +Y 8 mm; beak point is ~1 mm lower.
clock_spindle_top_cassette_y = 8.0;
beak_tip_center_cassette_y = clock_spindle_top_cassette_y-1.0;
guide_origin_cassette_y = 1.0;
beak_tip_z = beak_tip_center_cassette_y-guide_origin_cassette_y;
// Put the outlet just behind/above the printable point. This lets the exterior
// reach a real point without asking a 1 mm channel to fit through the apex.
beak_outlet_local_z = beak_tip_z+0.45;
beak_outlet_cassette_y = beak_outlet_local_z+guide_origin_cassette_y;

beak_channel_tip_yc = 2.80+beak_axial_center_shift_y;
beak_channel_root_d = 1.0;
beak_channel_tip_d = 1.0;

module chamfered_bar_body() {
    linear_extrude(height=clock_bar_h_z, center=true)
        polygon(points=[
            [-clock_bar_len_x/2+end_chamfer_y, -clock_bar_t_y/2],
            [ clock_bar_len_x/2-end_chamfer_y, -clock_bar_t_y/2],
            [ clock_bar_len_x/2, -clock_bar_t_y/2+end_chamfer_y],
            [ clock_bar_len_x/2,  clock_bar_t_y/2],
            [-clock_bar_len_x/2,  clock_bar_t_y/2],
            [-clock_bar_len_x/2, -clock_bar_t_y/2+end_chamfer_y]
        ]);
}

module flange_relieved_bar_body() {
    relief_y0 = -clock_bar_t_y/2+flange_relief_remaining_y;
    relief_depth_y = clock_bar_t_y-flange_relief_remaining_y;
    relief_yc = relief_y0+relief_depth_y/2+eps/2;
    lower_relief_h_z = clock_bar_h_z/2+clock_bar_hole_z_offset+eps;
    lower_relief_zc = -clock_bar_h_z/2+lower_relief_h_z/2;

    difference() {
        chamfered_bar_body();
        union() {
            // Circular upper boundary around the complete flange envelope.
            translate([0, relief_yc, clock_bar_hole_z_offset])
                rotate([90, 0, 0])
                    cylinder(
                        h=relief_depth_y+eps,
                        d=flange_relief_d,
                        center=true
                    );

            // Continue that same boundary straight down as a rectangle.
            translate([0, relief_yc, lower_relief_zc])
                cube([
                    flange_relief_d,
                    relief_depth_y+eps,
                    lower_relief_h_z
                ], center=true);
        }
    }
}

module clock_opening_cutter() {
    cutter_h_y = clock_bar_t_y+string_boss_d_y+2;
    canonical_crown_z = clock_bar_hole_z_offset+canonical_clock_bar_hole_d/2;
    enlarged_crown_z = clock_bar_hole_z_offset+clock_bar_hole_d/2;

    union() {
        // Canonical opening remains beneath the boss-support spine.
        translate([0, 0, clock_bar_hole_z_offset])
            rotate([90, 0, 0])
                cylinder(
                    h=cutter_h_y,
                    d=canonical_clock_bar_hole_d,
                    center=true
                );

        // Enlarge to 17 mm, retaining only a tapered full-thickness keystone
        // beneath the boss instead of the former flat 6-7 mm-wide inner lip.
        difference() {
            translate([0, 0, clock_bar_hole_z_offset])
                rotate([90, 0, 0])
                    cylinder(
                        h=cutter_h_y,
                        d=clock_bar_hole_d,
                        center=true
                    );
            rotate([90, 0, 0])
                linear_extrude(height=cutter_h_y+2*eps, center=true)
                    polygon(points=[
                        [-boss_crown_keystone_tip_w_x/2, canonical_crown_z-eps],
                        [ boss_crown_keystone_tip_w_x/2, canonical_crown_z-eps],
                        [ boss_crown_keystone_top_w_x/2, enlarged_crown_z+eps],
                        [-boss_crown_keystone_top_w_x/2, enlarged_crown_z+eps]
                    ]);
        }
    }
}

module canonical_pressure_bar() {
    difference() {
        union() {
            flange_relieved_bar_body();

            translate([
                string_boss_xc-string_boss_w_x/2,
                string_boss_y0,
                string_boss_z0
            ])
                cube([string_boss_w_x, string_boss_d_y, string_boss_h_z]);

        }

        // Enlarged opening with a canonical-size crown beneath the boss.
        clock_opening_cutter();

        // Preserve canonical bottom-open arch.
        translate([
            -clock_bar_hole_d/2-eps,
            -clock_bar_t_y/2-string_boss_d_y-eps,
            -clock_bar_h_z/2-eps
        ])
            cube([
                clock_bar_hole_d+2*eps,
                clock_bar_t_y+string_boss_d_y+2*eps,
                clock_bar_h_z/2+clock_bar_hole_z_offset+eps
            ]);

        // Existing vertical loading hole.
        translate([string_hole_xc, string_hole_yc, string_boss_z0-0.4])
            cylinder(
                h=string_boss_h_z+0.8+2*eps,
                d=string_hole_d,
                center=false
            );

    }
}

module captive_beak_solid() {
    hull() {
        // Wide root remains outside the flange boundary and spreads load into
        // the full-thickness boss/wall.
        translate([beak_root_xc, beak_root_yc, beak_root_z])
            cube([
                beak_root_w_x,
                beak_root_d_y,
                beak_root_h_z
            ], center=true);

        // Wide, thin functional tongue. Its radial taper supplies clearance;
        // its tangential width supplies stiffness without crowding either
        // flange face.
        translate([beak_tip_xc, beak_tip_yc, 0])
            rotate([90, 0, 0])
                linear_extrude(height=beak_tip_d_y, center=true)
                    polygon(points=[
                        [-beak_tip_apex_w_x/2, beak_tip_z],
                        [ beak_tip_apex_w_x/2, beak_tip_z],
                        [ beak_tip_shoulder_w_x/2,
                          beak_tip_z+beak_tip_taper_h_z],
                        [-beak_tip_shoulder_w_x/2,
                          beak_tip_z+beak_tip_taper_h_z]
                    ]);
    }
}

module captive_beak_channel() {
    hull() {
        translate([string_hole_xc, string_hole_yc, string_boss_z0+0.8])
            sphere(d=beak_channel_root_d);
        translate([beak_tip_xc, beak_channel_tip_yc, beak_outlet_local_z])
            sphere(d=beak_channel_tip_d);
    }
}

module stationary_collar_snap_pad() {
    pad_center_y = -clock_bar_t_y/2+stationary_pad_thickness_y/2;
    lower_floor_h_z = clock_bar_h_z/2+clock_bar_hole_z_offset+eps;
    lower_floor_zc = -clock_bar_h_z/2+lower_floor_h_z/2;

    if (stationary_collar_addition_enabled)
        difference() {
            union() {
                // Circular floor under the complete capstan-flange sweep.
                translate([0, pad_center_y, clock_bar_hole_z_offset])
                    rotate([90, 0, 0])
                        cylinder(
                            d=stationary_pad_outer_d,
                            h=stationary_pad_thickness_y,
                            center=true
                        );

                // Simple rectangular continuation closes the former open
                // bottom and ties the two guide legs together.
                translate([0, pad_center_y, lower_floor_zc])
                    cube([
                        stationary_pad_outer_d,
                        stationary_pad_thickness_y,
                        lower_floor_h_z
                    ], center=true);
            }

            // Axial locating bore over the stationary collar. Rotating hour
            // and minute members remain entirely inside this stationary datum.
            translate([0, pad_center_y, clock_bar_hole_z_offset])
                rotate([90, 0, 0])
                    cylinder(
                        d=stationary_collar_bore_d,
                        h=stationary_pad_thickness_y+2*eps,
                        center=true
                    );
        }
}

module clock_pressure_bar() {
    difference() {
        union() {
            canonical_pressure_bar();
            stationary_collar_snap_pad();
            captive_beak_solid();
        }
        captive_beak_channel();
    }
}

module clock_pressure_bar_print_layout() {
    // Put the boss/top edge on the bed. The wall-backed beak then grows upward
    // from its root instead of beginning as an unsupported island in the arch.
    translate([0, 0, clock_bar_h_z/2])
        rotate([180, 0, 0])
            clock_pressure_bar();
}

clock_pressure_bar_print_layout();
