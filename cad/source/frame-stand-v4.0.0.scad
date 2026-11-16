// DOUBLE TAKE FRAMES — CANONICAL FRAME STAND
// DTF_RELEASE: 4.0.0
// Version: 4.0.0
// Based on canonical frame-stand-v3.0.0.scad.
// Status: CANONICAL
//
// Lowers the passive overflow crest from Z=9 mm to Z=7 mm, matching the
// intended low red-line spout rather than using most of the stand's depth as
// fill capacity.  The cassette seat remains at Z=11 mm, so a full 4 mm wall
// band is hydraulically incapable of becoming submerged during upright fill.
// This safety-first level requires about 5 mm of diffuser projection below the
// cassette to retain 1 mm of working immersion.
//
// Makes the rear fill spout a passive overflow weir: its complete outer rim
// ends at the design waterline below the cassette resting plane.
// The spout-to-basin opening stops at that same elevation, leaving a continuous
// solid dry bulkhead above it.  Excess fill therefore exits through the low
// spout before the water surface can reach the cassette or cardboard backing.
//
// With reservoir=true, raises the cassette rest by 5 mm above a floor-grown basin,
// puts the unique low sump directly under the cassette diffuser opening, and
// aligns the rear filling spout to that same diffuser datum.  Every wet-side
// floor rises gently away from the sump, including the complete spout floor.
// Rounded interior transitions prioritize printability and water tightness.
// With reservoir=false, produces the unchanged canonical v3.0.0 stand geometry.
//
// Original canonical release history follows.
// Released: 2026-09-24
// Versioning: Semantic Versioning 2.0.0 (https://semver.org/)
// Changes in 3.0.0:
// - Carried forward unchanged for the clipless keyed wall-rig and latch release.
// Changes in 2.0.4:
// - Carried forward unchanged for the coordinated capstan and clock-string-guide release.
// Changes in 2.0.3:
// - Carried forward unchanged for the corrected prepared-project packaging.
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

// Variant selector. The reservoir experiment remains available but off by
// default so the established stand is the neutral/standard configuration.
reservoir = false;

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

dry_foot_h = 5.0;
// The wet stand needs positive separation between the operating water level
// and both the cassette floor and cardboard backing.  Extending the feet and
// all cassette-supporting structure together preserves the established fit
// while gaining the full requested 5 mm of vertical safety room.
wet_cassette_rise_h = reservoir ? 5.0 : 0.0;
foot_h = dry_foot_h + wet_cassette_rise_h;
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

// WATER BASIN
// Four nominal 0.6 mm lines/layers provide a conservative watertight shell.
// The exterior remains flat on the print bed.  Only the inside floor slopes:
// a broad shallow sump is the unique low point and all perimeter areas climb
// by less than 1 mm, enough to drain without creating steep wet-side ledges.
water_pool_floor_t = 2.4;
water_pool_perimeter_floor_z = water_pool_floor_t + 0.8;
// Shared cassette datum from the pending main frame: the diffuser/wick hole
// reuses integrated_drain_x/y.  Keeping the formula here prevents the stand
// from silently drifting when viewed independently.
water_pool_sump_x = 11.4;
water_pool_sump_y = (wall_offset + (bottom_d - 8.0))/2 + 3.0;
water_pool_sump_half_x = 5.2;
water_pool_sump_half_y = 5.4;
// Carry the basin wall all the way under the existing 4 mm resting ledge so
// that ledge is supported from the print floor rather than becoming a wet-side
// cantilever.
water_pool_wall_t = collar_t + rest_lip_t;
water_pool_top_z = collar_z0 + rest_lip_h;
water_pool_inner_fillet_r = 2.4;
water_pool_curve_fn = 48;
// A 5 mm diffuser tail reaches 1 mm into the nominal water at this level while
// the water remains a definite 4 mm below the cassette resting plane.  The
// rear spout rim is an open overflow at exactly this datum, making the upper
// 4 mm of the basin wall a physically enforced dry bulkhead rather than spare
// capacity that can be accidentally filled.
water_pool_design_freeboard_z = 4.0;
water_pool_design_fill_z = water_pool_top_z-water_pool_design_freeboard_z;
water_pool_dry_bulkhead_z0 = water_pool_design_fill_z;
water_pool_dry_bulkhead_h = water_pool_top_z-water_pool_dry_bulkhead_z0;
water_pool_min_diffuser_immersion_z = 1.0;
water_pool_required_diffuser_tail_z =
    water_pool_design_freeboard_z+water_pool_min_diffuser_immersion_z;

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

// REAR WATER-FILL SPOUT
// Centered directly behind the diffuser hole.  The former convenience
// location between the center and right posts is intentionally retired.
water_spout_cx = water_pool_sump_x;
water_spout_outer_w_x = 18.0;
water_spout_outer_x0 = water_spout_cx-water_spout_outer_w_x/2;
water_spout_outer_x1 = water_spout_cx+water_spout_outer_w_x/2;
water_spout_projection_y = 20.0;
// Only a small fused overlap enters the existing rear wall; the tall pour well
// remains behind the cassette envelope rather than occupying its rear corner.
water_spout_wall_overlap_y = 0.6;
water_spout_outer_y0 = outer_y1-water_spout_wall_overlap_y;
water_spout_outer_y1 = outer_y1+water_spout_projection_y;
// The complete exposed spout rim is the passive overflow crest.  It must be
// lower than every cassette-supporting surface so overfill leaves the stand.
water_spout_top_z = water_pool_design_fill_z;
water_spout_wall_t = 2.4;
water_spout_near_floor_z = water_pool_perimeter_floor_z+0.2;
water_spout_far_floor_z = water_spout_near_floor_z+1.0;
water_spout_inner_fillet_r = 2.4;
water_spout_port_w_x = 10.0;

// Moving only this post is preferable to offsetting the hydraulic path.  It
// remains well inboard of the side wall and leaves a printable gap around the
// directly aligned spout.
rear_left_post_x = max(
    inner_x0+18.0,
    reservoir
        ? water_spout_outer_x1+rear_post_w/2+3.0
        : inner_x0+18.0
);
rear_center_post_x = (inner_x0+inner_x1)/2;
rear_right_post_x = inner_x1-18.0;

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

// FLOOR-GROWN WATER BASIN
// Start with one continuous outer block from the print bed to the frame-resting
// plane, then remove a rounded, shallowly pitched cavity from above.  A low
// center pad beneath the diffuser and four higher perimeter columns form the
// drainage envelope.  Minkowski rounding then makes the floor/wall joints
// continuous and curvilinear without changing the flat printable underside.
module water_pool_sloped_cavity_core(
    x0,x1,y0,y1,z1,r
) {
    sump_core_half_x = max(eps,water_pool_sump_half_x-r);
    sump_core_half_y = max(eps,water_pool_sump_half_y-r);

    hull() {
        // Higher perimeter datums: the complete boundary drains inward.
        for(x=[x0+r,x1-r], y=[y0+r,y1-r])
            translate([x-eps/2,y-eps/2,water_pool_perimeter_floor_z+r])
                cube([eps,eps,z1-water_pool_perimeter_floor_z+2*eps]);

        // The only low area is a compact pad centered under the diffuser.
        translate([
            water_pool_sump_x-sump_core_half_x,
            water_pool_sump_y-sump_core_half_y,
            water_pool_floor_t+r
        ])
            cube([
                2*sump_core_half_x,
                2*sump_core_half_y,
                z1-water_pool_floor_t+2*eps
            ]);
    }
}

module water_pool_shell() {
    cavity_x0 = outer_x0 + water_pool_wall_t;
    cavity_x1 = outer_x1 - water_pool_wall_t;
    cavity_y0 = outer_y0 + water_pool_wall_t;
    cavity_y1 = outer_y1 - water_pool_wall_t;
    cavity_w = cavity_x1 - cavity_x0;
    cavity_d = cavity_y1 - cavity_y0;
    cavity_h = water_pool_top_z - water_pool_floor_t;
    r = water_pool_inner_fillet_r;

    assert(water_pool_floor_t >= 2.4-eps,
           "water basin floor is thinner than four 0.6 mm layers");
    assert(water_pool_wall_t >= 2.4-eps,
           "water basin wall is thinner than four 0.6 mm lines");
    assert(cavity_w > 2*r && cavity_d > 2*r,
           "water basin fillet consumes the interior cavity");
    assert(cavity_h > 0,
           "water basin has no usable depth above its floor");
    assert(water_pool_sump_x-water_pool_sump_half_x
               >= cavity_x0+r-eps
           && water_pool_sump_x+water_pool_sump_half_x
               <= cavity_x1-r+eps,
           "diffuser sump reaches the basin X wall");
    assert(water_pool_sump_y-water_pool_sump_half_y
               >= cavity_y0+r-eps
           && water_pool_sump_y+water_pool_sump_half_y
               <= cavity_y1-r+eps,
           "diffuser sump reaches the basin Y wall");
    assert(water_pool_design_fill_z
               <= water_pool_top_z-water_pool_design_freeboard_z+eps,
           "water design level lost its cassette-floor freeboard");
    assert(water_pool_dry_bulkhead_h >= 4.0-eps,
           "enforced dry bulkhead is less than 4 mm tall");
    assert(water_pool_design_fill_z
               >= water_pool_top_z-water_pool_required_diffuser_tail_z
                  +water_pool_min_diffuser_immersion_z-eps,
           "specified diffuser tail no longer reaches the safe waterline");

    difference() {
        translate([outer_x0, outer_y0, 0])
            cube([
                outer_x1 - outer_x0,
                outer_y1 - outer_y0,
                water_pool_top_z
            ]);

        minkowski() {
            water_pool_sloped_cavity_core(
                cavity_x0,cavity_x1,
                cavity_y0,cavity_y1,
                water_pool_top_z+eps,r
            );
            sphere(r=r,$fn=water_pool_curve_fn);
        }
    }
}

module water_spout_sloped_cavity_core(
    x0,x1,y0,y1,z1,r
) {
    core_w = x1-x0-2*r;

    hull() {
        // Near edge is lower; the main basin then continues down to the sump.
        translate([x0+r,y0+r,water_spout_near_floor_z+r])
            cube([
                core_w,eps,
                z1-water_spout_near_floor_z+2*eps
            ]);
        // The pouring end is deliberately the highest point in the wet path.
        translate([x0+r,y1-r-eps,water_spout_far_floor_z+r])
            cube([
                core_w,eps,
                z1-water_spout_far_floor_z+2*eps
            ]);
    }
}

module rear_water_spout_shell() {
    cavity_x0 = water_spout_outer_x0+water_spout_wall_t;
    cavity_x1 = water_spout_outer_x1-water_spout_wall_t;
    cavity_y0 = water_spout_outer_y0+water_spout_wall_t;
    cavity_y1 = water_spout_outer_y1-water_spout_wall_t;
    cavity_w = cavity_x1-cavity_x0;
    cavity_d = cavity_y1-cavity_y0;
    r = water_spout_inner_fillet_r;

    assert(cavity_w > 2*r && cavity_d > 2*r,
           "rear water spout fillet consumes its pour opening");
    assert(water_spout_outer_x0 >= outer_x0-eps,
           "diffuser-aligned rear spout reaches beyond the stand side");
    assert(water_spout_outer_x1
               <= rear_left_post_x-rear_post_w/2-3.0+eps,
           "diffuser-aligned rear spout crowds the relocated left post");
    assert(water_spout_far_floor_z < water_pool_design_fill_z-eps,
           "spout floor reaches the nominal water level");
    assert(abs(water_spout_top_z-water_pool_design_fill_z) < eps,
           "spout rim no longer enforces the design waterline");
    assert(water_pool_top_z-water_spout_top_z
               >= water_pool_design_freeboard_z-eps,
           "spout overflow can wet the cassette-side bulkhead");

    difference() {
        translate([
            water_spout_outer_x0,
            water_spout_outer_y0,
            0
        ])
            cube([
                water_spout_outer_x1-water_spout_outer_x0,
                water_spout_outer_y1-water_spout_outer_y0,
                water_spout_top_z
            ]);

        // Rounded open-top pour well.  Its floor rises toward the pouring end,
        // so no local low spot remains behind the diffuser-aligned channel.
        minkowski() {
            water_spout_sloped_cavity_core(
                cavity_x0,cavity_x1,
                cavity_y0,cavity_y1,
                water_spout_top_z+eps,r
            );
            sphere(r=r,$fn=water_pool_curve_fn);
        }
    }
}

module water_spout_yz_extrude_x(x0,x1) {
    multmatrix([
        [0,0,1,x0],
        [1,0,0,0],
        [0,1,0,0],
        [0,0,0,1]
    ])
        linear_extrude(height=x1-x0)
            children();
}

module rear_water_spout_connection_void() {
    // Open only through the wet zone, terminating at the low overflow crest.
    // The rear wall from that crest to the cassette seat remains continuous,
    // forming the dry Z-face that accidental overfill cannot reach.
    port_x0 = water_spout_cx-water_spout_port_w_x/2;
    port_x1 = water_spout_cx+water_spout_port_w_x/2;
    port_y0 = outer_y1-water_pool_wall_t-eps;
    port_y1 = port_y0
        +water_pool_wall_t+water_spout_wall_t
        +water_spout_inner_fillet_r+2*eps;

    // The connection continues the same downhill path: high in the spout,
    // lower at the basin perimeter, then lower again at the diffuser sump.
    water_spout_yz_extrude_x(port_x0,port_x1)
        polygon(points=[
            [port_y0,water_pool_perimeter_floor_z-eps],
            [port_y1,water_spout_near_floor_z-eps],
            [port_y1,water_spout_top_z+eps],
            [port_y0,water_spout_top_z+eps]
        ]);
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
    rear_post(rear_left_post_x);
    rear_post(rear_center_post_x);
    rear_post(rear_right_post_x);

    rear_post_friction_pad(rear_left_post_x);
    rear_post_friction_pad(rear_center_post_x);
    rear_post_friction_pad(rear_right_post_x);
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
difference() {
    union() {
        if(reservoir) {
            water_pool_shell();
            rear_water_spout_shell();
        }

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

    if(reservoir)
        rear_water_spout_connection_void();
}
