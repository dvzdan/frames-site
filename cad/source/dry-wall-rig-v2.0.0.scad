// DOUBLE TAKE FRAMES DESIGN RELEASE
// DTF_RELEASE: 2.0.0
// Released: 2026-08-31
// Versioning: Semantic Versioning 2.0.0 (https://semver.org/)
// Status: CANONICAL
// Changes in 2.0.0:
// - Carried forward without geometry changes for the coordinated 2.0.0 release.
// Full release notes: https://doubletakeframes.com/build/#design-release
//
// Public dry-wall rig source. Shared latch modules remain here so the mating
// geometry stays synchronized; the default output is the fixed wall rig.
$fn = 96;

inch = 25.4;
eps  = 0.05;

// 0 = closed assembly review, 1 = fixed rig, 2 = moving latch,
// 3 = keeper, 4 = separated printable parts
render_part = 1;
show_weight_proxy = false;

// =========================================================
// CONVENTIONAL FRAME
// x: right is +
// y: away from viewer is +
// z: up is +
// wall plane is y = 0
//
// mounted hardware projecting toward viewer lives in NEGATIVE y
// =========================================================

// =========================================================
// GLOBAL / WALL
// =========================================================
show_wall = true;
wall_t    = 1.0;

// wall will auto-expand to fit both latch base and tunnel
wall_margin = 5;
// 
// LATCH BASE PARAMS
// =========================================================
pad_w = 16;   // X
pad_h = 16;   // Z
pivot_boss_d = 13.0;

standoff_d = 9.5;
standoff_h = 0.8;   // along Y
post_d     = 5.5;
post_h     = 4.0;   // along Y
neck_d     = 4.7;
neck_h     = 1.4;   // along Y

// The corral is the Y source of truth. Center the eye plane on its complete
// outer depth, then derive the wall-rooted pad extension needed to put the
// shoulder/post stack there.
corral_clear_d_y = 13.0;
corral_wall_t = 1.2;
corral_global_outer_y1 = -0.30;
corral_center_y_target = corral_global_outer_y1
                         - (corral_clear_d_y + 2*corral_wall_t)/2;
pad_t = -corral_center_y_target - standoff_h - post_h/2;

// These are retained only because tunnel placement is still
// logically referenced from where the latch bar tip used to be.
eye_outer_d = 13.0;
arm_len     = 1.5 * inch;
tip_len     = 2.0;

// =========================================================
// LATCH BASE Y STACK
// =========================================================
pad_y_wall = 0;
pad_y_out  = -pad_t;

standoff_y0 = pad_y_out;
standoff_y1 = standoff_y0 - standoff_h;

post_y0 = standoff_y1;
post_y1 = post_y0 - post_h;

neck_y0 = post_y1;
neck_y1 = neck_y0 - neck_h;

// =========================================================
// LATCH REFERENCE X/Z GEOMETRY
// =========================================================
bar_x_inner = -(eye_outer_d/2 - 0.5);
bar_x_outer = bar_x_inner - arm_len;

// Legacy fixed-rig datum only. The old solid extension at this location was
// an abandoned bevel experiment and is intentionally not part of the latch.
tip_x0 = bar_x_outer - tip_len;
tip_x1 = bar_x_outer;

// =========================================================
// MOVING LATCH — CORRAL FLOOR + RELOCATABLE PIVOT EYE
// =========================================================
latch_t = 3.4;
bar_up = 2.5;
bar_t = latch_t + bar_up;
arm_w = 6.0;
tip_w = 6.0;
bottom_relief = 0.8;
bottom_y_round = 0.6;
eye_inner_d = post_d + 2*0.22;

// Solid far-end extension outside the centered 41.5 mm weight pocket. Five
// millimeters leaves useful material on every side of the enclosed key socket.
corral_end_wall_t_x = 5.0;

// Keep the weight pocket on the canonical paper/cassette centerline. The new
// 5 mm keyed extension grows only toward the zipper, so move the zipper package
// left by the same 5 mm to preserve the original tunnel-to-corral gap.
latch_package_shift_x = 0;
zipper_package_shift_x = -corral_end_wall_t_x;
pivot_x = 4.0 + latch_package_shift_x;

// Keep the latch eye centered within the 4 mm post length. Because pad_t is
// derived above, the eye plane also lands on the corral's Y centerline.
latch_install_y = post_y1 + (post_h-latch_t)/2;

corral_clear_w_x = 41.5;
corral_depth_z = 8.0;
corral_floor_t = 1.2;
canonical_weight_center_x = -27.0;

// Size changes are split evenly across the pocket so the weight, cassette,
// and paper retain their shared canonical X centerline.
corral_inner_x0 = canonical_weight_center_x - corral_clear_w_x/2;
corral_inner_x1 = canonical_weight_center_x + corral_clear_w_x/2;
// Add a solid keyed extension beyond the 41.5 mm weight pocket.
corral_floor_x0 = corral_inner_x0 - corral_end_wall_t_x;
corral_floor_x1 = corral_inner_x1 + corral_wall_t;

// Keep the floor close to the frame wall while clearing it through the swing.
// The frame wall itself is the +Y side and broad anti-racking stop.
corral_outer_y1 = corral_global_outer_y1 - latch_install_y;
corral_inner_y1 = corral_outer_y1 - corral_wall_t;
corral_inner_y0 = corral_inner_y1 - corral_clear_d_y;
corral_outer_y0 = corral_inner_y0 - corral_wall_t;

corral_global_outer_y0 = latch_install_y + corral_outer_y0;
corral_global_inner_y0 = latch_install_y + corral_inner_y0;
corral_global_inner_y1 = latch_install_y + corral_inner_y1;

// Compact transition into the pivot eye. It occupies exactly the eye's Y
// plane: keeper outside, fixed shoulder inside. Extending it farther in either
// direction would embed it in one of those fixed retention features.
pivot_transition_x0 = corral_floor_x1;
pivot_transition_x1 = pivot_x - (eye_inner_d/2 + 0.25);
pivot_transition_y0 = 0;
pivot_transition_y1 = latch_t;

// Placeholder proxy height; X/Y are measured.
weight_piece_w_x = 40.0;
weight_piece_d_y = 12.0;
weight_proxy_h_z = 6.5;

// Preserve the canonical keeper unchanged.
clip_outer_d = 10.0;
clip_t       = 1.8;
grip_hole_d  = 4.65;
gap_w        = 2.8;
flat_depth   = 1.5;
keeper_install_y = neck_y1;

// =========================================================
// TUNNEL PARAMS
// =========================================================
tunnel_w_x = 8.0;
tunnel_d_y = 13.0;
tunnel_h_z = 14.0;       // retained only to preserve the canonical -7 mm floor
tunnel_roof_t_z = 1.2;   // printable roof above the unchanged zipper slot

slot_margin_y = 1;
slot_h_z      = 2.5;
slot_offset_z = -2.45; // local slot datum; package-level Z shift is applied below

// underside cubby
cubby_wall_y  = 1.0;
cubby_drop_z  = 6;
cubby_depth_z = 6.1;  // gains the 1.1 mm removed from the zipper-head slot
cubby_extra_y = -1.0;
cubby_floor_z = 1.2;

// placement controls
tunnel_gap_from_tip = 4.0;
tunnel_mount_dx     = zipper_package_shift_x;
tunnel_mount_dz     = 0.6;

tunnel_y_back  = 1;
tunnel_y_front = tunnel_y_back - tunnel_d_y;

// =========================================================
// CROOK PARAMS
// =========================================================
crook_w_x      = 1.6;
crook_t_y      = 2.6;
crook_drop_z   = 10.0;
crook_left_dx  = 9.0;
crook_rise_z   = 6.0;
crook_mount_dx = 0.0;
crook_mount_dy = 0.0;

// =========================================================
// DERIVED TUNNEL PLACEMENT
// =========================================================
tunnel_x1 = tip_x0 - tunnel_gap_from_tip + tunnel_mount_dx;
tunnel_x0 = tunnel_x1 - tunnel_w_x;

tunnel_corral_gap_x = corral_floor_x0 - tunnel_x1;
assert(tunnel_corral_gap_x >= 2.0,
       str("Tunnel-to-corral X gap too small: ",
           tunnel_corral_gap_x, " mm"));

tunnel_z0 = -tunnel_h_z/2 + tunnel_mount_dz;

slot_x0 = tunnel_x0 - eps;
slot_x1 = tunnel_x1 + eps;

slot_y0 = tunnel_y_front + slot_margin_y;
slot_y1 = tunnel_y_back  - slot_margin_y;

// Decouple the zipper datum from the now-trimmed tunnel roof. This preserves
// the canonical slot at -3.7..-1.2 mm while allowing dead mass above it to go.
slot_zc = tunnel_mount_dz + slot_offset_z;
slot_z0 = slot_zc - slot_h_z/2;
slot_z1 = slot_zc + slot_h_z/2;
tunnel_z1 = slot_z1 + tunnel_roof_t_z;

// =========================================================
// PRIMARY LATCH Z DATUM
// =========================================================
// Preserve the established corral and pivot Z datums while raising only the
// zipper package. The physical prototype retains more gap than the nominal CAD
// stack predicts, so the +0.6 mm shift intentionally closes more of the
// observed as-printed clearance without moving the corral or pivot.
corral_floor_z0 = -0.90;
zipper_corral_nominal_gap_z = corral_floor_z0 - slot_z1;
corral_floor_z  = corral_floor_z0 + corral_floor_t;
corral_wall_z1 = corral_floor_z + corral_depth_z;
pivot_z = (corral_floor_z0 + corral_wall_z1) / 2;
pivot_eye_flat_z = corral_floor_z0;
pivot_eye_flat_local_z = pivot_eye_flat_z - pivot_z;

//=========================================================
// SINGLE FN WHEEL-WEIGHT GARAGE
// =========================================================
garage_slide_clear_x = 0.30;
garage_slide_clear_y = 0.30;
garage_roof_overlap_x = 3.0;
garage_roof_underside_z = corral_floor_z + 9.0;
garage_roof_t_z = 1.2;
garage_roof_cup_run_y = 4.0;
garage_roof_cup_drop_z = 0.60;
garage_middle_roof_w_x = 4.0;
garage_right_roof_w_x = garage_middle_roof_w_x;
garage_right_roof_center_x = corral_inner_x1 - 6.0;
garage_middle_right_raise_z = 2.0;

// Paper-safe reinforcement for wall-rooted horizontal features. The added
// material is tallest at the wall and tapers to zero at the free edge, so a
// descending sheet encounters a glide ramp rather than a square shoulder.
paper_ramp_root_h_z = 2.0;
paper_ramp_slice_y = 0.08;

// The pivot radius locates the corral in X, so no fixed -X stop is required.
// The left roof remains wall-rooted and carries the loose Y-retention tooth.
garage_left_roof_x0 = corral_floor_x0;
weight_clear_x0 = corral_floor_x0 - garage_slide_clear_x;

blinder_y0 = corral_global_outer_y0 - garage_slide_clear_y;
blinder_y1 = tunnel_y_back;
garage_roof_cup_y1 = blinder_y0 + garage_roof_cup_run_y;
blinder_z0 = tunnel_z1;
blinder_z1 = garage_roof_underside_z + garage_roof_t_z;
blinder_h_z = blinder_z1 - blinder_z0;

// Far-end Y key. A roof-hung vertical tooth drops into a socket that is fully
// enclosed in X and Y and open only at the top. The latch swings downward to
// disengage it; the pivot remains the sole right-end restraint.
latch_key_tooth_w_x = 1.4;
latch_key_tooth_w_y = 3.0;
latch_key_clear_xy = 0.60;
latch_key_clear_z = 0.60;
latch_key_engagement_z = 3.0;
latch_key_roof_overlap_z = 0.30;

latch_key_xc = (corral_floor_x0 + corral_inner_x0) / 2;
latch_key_local_yc = (corral_outer_y0 + corral_outer_y1) / 2;
latch_key_global_yc = latch_install_y + latch_key_local_yc;

latch_key_tooth_x0 = latch_key_xc - latch_key_tooth_w_x/2;
latch_key_tooth_x1 = latch_key_xc + latch_key_tooth_w_x/2;
latch_key_notch_x0 = latch_key_tooth_x0 - latch_key_clear_xy;
latch_key_notch_x1 = latch_key_tooth_x1 + latch_key_clear_xy;

latch_key_tooth_y0 = latch_key_global_yc - latch_key_tooth_w_y/2;
latch_key_tooth_y1 = latch_key_global_yc + latch_key_tooth_w_y/2;
latch_key_notch_y0 = latch_key_local_yc
                     - latch_key_tooth_w_y/2 - latch_key_clear_xy;
latch_key_notch_y1 = latch_key_local_yc
                     + latch_key_tooth_w_y/2 + latch_key_clear_xy;

latch_key_tooth_z0 = corral_wall_z1 - latch_key_engagement_z;
latch_key_tooth_z1 = garage_roof_underside_z
                     + latch_key_roof_overlap_z;
latch_key_notch_z0 = latch_key_tooth_z0 - latch_key_clear_z;

// Preserve the roof overlap over the actual weight pocket while leaving the
// far end open in X; the pivot radius now supplies all X location.
garage_left_roof_x1 = corral_inner_x0 + garage_roof_overlap_x;

// Carry the full guard clearance through the supporting geometry below.
// The pivot pedestal is circular; rectangular corners add no useful support
// and intrude into the corral's swept envelope.
latch_pad_x0 = pivot_x - pivot_boss_d/2;
latch_pad_x1 = pivot_x + pivot_boss_d/2;
// =========================================================

// =========================================================
// VISOR
// =========================================================
visor_t_z        = 1.0;
visor_overlap_x  = 1.0;
visor_extra_y    = .5;

visor_x0    = tunnel_x1 - visor_overlap_x;
visor_x1    = weight_clear_x0;

visor_y0    = tunnel_y_front - visor_extra_y;
visor_y1    = tunnel_y_back;

visor_z0    = tunnel_z1 - visor_t_z;
visor_z1    = tunnel_z1;

// =========================================================
// VISOR DROP
// =========================================================
visor_drop_y_t = 1.0;
visor_drop_z   = 14.0;

visor_drop_x0 = visor_x0;
visor_drop_x1 = visor_x1;

visor_drop_y0 = visor_y0;
visor_drop_y1 = visor_y0 + visor_drop_y_t;

visor_drop_z0 = visor_z0 - visor_drop_z;
visor_drop_z1 = visor_z0;

// =========================================================
// INNER STOP
// =========================================================
inner_stop_x_w       = 2.0;
inner_stop_gap_z     = 0.8;
inner_stop_depth_y   = 3.0;

inner_stop_x0 = visor_x1 - inner_stop_x_w;
inner_stop_x1 = visor_x1;

inner_stop_y0 = -inner_stop_depth_y;
inner_stop_y1 = wall_t;

inner_stop_z0 = slot_z1 + inner_stop_gap_z;
inner_stop_z1 = visor_z0;

// =========================================================
// AUTO WALL FOOTPRINT
// =========================================================
hardware_x0 = min(latch_pad_x0, tunnel_x0);
hardware_x1 = max(latch_pad_x1, visor_x1);

// Preserve the hardware-derived values for clearance checks, but do not let
// them resize the backing plane. The current structures are X-indifferent and
// remain at their present coordinates inside the canonical wall rectangle.
hardware_z0 = min(-pad_h/2, min(tunnel_z0 - cubby_drop_z, visor_drop_z0));
hardware_z1 = max( pad_h/2, tunnel_z1);

weight_pocket_center_x = (corral_inner_x0 + corral_inner_x1) / 2;
assert(abs(weight_pocket_center_x - canonical_weight_center_x) < eps,
       str("Weight pocket left canonical X centerline: ",
           weight_pocket_center_x, " mm"));

// Preserve the canonical wall plane's absolute bounds as well as its size.
// Its historical rectangle is slightly asymmetric around the weight path.
canonical_wall_x0 = -66.1;
canonical_wall_x1 =  16.0;
canonical_wall_z0 = -13.0;
canonical_wall_z1 =  27.0;

wall_w = canonical_wall_x1 - canonical_wall_x0;
wall_h = canonical_wall_z1 - canonical_wall_z0;

// =========================================================
// HELPERS
// =========================================================
module rect_prism(x0, x1, y0, y1, z0, z1) {
    translate([min(x0,x1), min(y0,y1), min(z0,z1)])
        cube([abs(x1-x0), abs(y1-y0), abs(z1-z0)]);
}

module cyl_y_span(d, y0, y1) {
    translate([0, max(y0,y1), 0])
        rotate([90,0,0])
            cylinder(d=d, h=abs(y1-y0), center=false);
}

module tunnel_crook() {
    crook_top_z = tunnel_z0 - cubby_drop_z;

    crook_xc = (slot_x0 + slot_x1) / 2 + crook_mount_dx;
    crook_yc = ((slot_y0 - cubby_extra_y/2) + (slot_y1 + cubby_extra_y/2)) / 2 + crook_mount_dy;

    crook_vert_x0 = crook_xc - crook_w_x/2;
    crook_vert_x1 = crook_xc + crook_w_x/2;
    crook_vert_y0 = crook_yc - crook_t_y/2;
    crook_vert_y1 = crook_yc + crook_t_y/2;
    crook_vert_z0 = crook_top_z - crook_drop_z;
    crook_vert_z1 = crook_top_z;

    crook_horiz_x0 = crook_xc - crook_left_dx;
    crook_horiz_x1 = crook_xc;
    crook_horiz_y0 = crook_vert_y0;
    crook_horiz_y1 = crook_vert_y1;
    crook_horiz_z0 = crook_vert_z0;
    crook_horiz_z1 = crook_vert_z0 + crook_w_x;

    union() {
        rect_prism(crook_vert_x0, crook_vert_x1, crook_vert_y0, crook_vert_y1, crook_vert_z0, crook_vert_z1);
        rect_prism(crook_horiz_x0, crook_horiz_x1, crook_horiz_y0, crook_horiz_y1, crook_horiz_z0, crook_horiz_z1);
    }
}
module carriage_blinders() {
    // Roof-hung positive tooth. Its upper end overlaps the left roof so it is
    // not a side cantilever from the wall.
    rect_prism(latch_key_tooth_x0, latch_key_tooth_x1,
               latch_key_tooth_y0, latch_key_tooth_y1,
               latch_key_tooth_z0, latch_key_tooth_z1);

    // Three wall-rooted roof lips provide Z retention while leaving open space
    // for the tether. The right lip duplicates the middle one without adding
    // another vertical guide beside the pivot.
    garage_roof_lip(garage_left_roof_x0,
                    garage_left_roof_x1,
                    false);

    translate([0, 0, garage_middle_right_raise_z]) {
        garage_roof_lip((corral_inner_x0 + corral_inner_x1)/2
                            - garage_middle_roof_w_x/2,
                        (corral_inner_x0 + corral_inner_x1)/2
                            + garage_middle_roof_w_x/2,
                        false);

        garage_roof_lip(garage_right_roof_center_x
                            - garage_right_roof_w_x/2,
                        garage_right_roof_center_x
                            + garage_right_roof_w_x/2,
                        false);
    }
}

module paper_glide_ramp(x0, x1, free_y, root_y, base_z) {
    // A zero-height endpoint is represented by a very shallow embedded slice
    // so the hull remains manifold and merges cleanly into the base plate.
    hull() {
        rect_prism(x0, x1,
                   free_y, free_y + paper_ramp_slice_y,
                   base_z - eps, base_z);
        rect_prism(x0, x1,
                   root_y - paper_ramp_slice_y, root_y,
                   base_z - eps, base_z + paper_ramp_root_h_z);
    }
}

module garage_roof_lip(x0, x1, include_cup=true) {
    nose_slice_y = 0.05;

    // Flat wall-rooted portion.
    rect_prism(x0, x1,
               garage_roof_cup_y1, blinder_y1,
               garage_roof_underside_z, blinder_z1);

    paper_glide_ramp(x0, x1,
                     garage_roof_cup_y1, blinder_y1,
                     blinder_z1);

    if (include_cup) {
        // The left roof retains its shallow outer cup because it also carries
        // the keyed end structure. The middle and right ribs stop 4 mm sooner
        // over the weight's main body rather than following the round flange.
        hull() {
            rect_prism(x0, x1,
                       garage_roof_cup_y1 - nose_slice_y,
                       garage_roof_cup_y1,
                       garage_roof_underside_z, blinder_z1);

            rect_prism(x0, x1,
                       blinder_y0,
                       blinder_y0 + nose_slice_y,
                       garage_roof_underside_z - garage_roof_cup_drop_z,
                       blinder_z1 - garage_roof_cup_drop_z);
        }
    }
}
// =========================================================
// GEOMETRY
// =========================================================
rig_wall_extra_x = 3.0;
rig_wall_extra_z = 2.0;

// shifts only the wall profile upward so its ledge/bar Z can match wet rig
clock_wall_profile_dz = 5.0;
module wall_only() {
    if (show_wall)
        rect_prism(
            canonical_wall_x0, canonical_wall_x1,
            0, wall_t,
            canonical_wall_z0, canonical_wall_z1
        );
}

module latch_base_only() {
    union() {
        // Round wall-rooted pedestal: the complete rectangular pad is gone,
        // leaving a direct and rotation-friendly load path to the pivot stack.
        translate([pivot_x,0,pivot_z])
            cyl_y_span(pivot_boss_d, pad_y_wall, pad_y_out);

        translate([pivot_x,0,pivot_z]) {
            cyl_y_span(standoff_d, standoff_y0, standoff_y1);
            cyl_y_span(post_d,     post_y0,     post_y1);
            cyl_y_span(neck_d,     neck_y0,     neck_y1);
        }
    }
}

module slotted_tunnel_only() {
    union() {
        difference() {
            union() {
                rect_prism(tunnel_x0, tunnel_x1, tunnel_y_front, tunnel_y_back, tunnel_z0, tunnel_z1);
                rect_prism(slot_x0, slot_x1,
                    slot_y0 - cubby_extra_y/2 - cubby_wall_y,
                    slot_y1 + cubby_extra_y/2 + cubby_wall_y,
                    tunnel_z0 - cubby_drop_z, tunnel_z0);
            }

            rect_prism(slot_x0, slot_x1, slot_y0, slot_y1, slot_z0, slot_z1);

            rect_prism(slot_x0, slot_x1,
                slot_y0 - cubby_extra_y/2,
                slot_y1 + cubby_extra_y/2,
                tunnel_z0 - cubby_drop_z + cubby_floor_z,
                tunnel_z0 - cubby_drop_z + cubby_floor_z + cubby_depth_z);
        }

        paper_glide_ramp(tunnel_x0, tunnel_x1,
                         tunnel_y_front, tunnel_y_back,
                         tunnel_z1);
    }
}

module tunnel_visor() {
    rect_prism(visor_x0, visor_x1, visor_y0, visor_y1, visor_z0, visor_z1);
}
visor_drop_corner_chop_x = 6.0;
visor_drop_corner_chop_z = 6.0;
module tunnel_visor_drop() {
    difference() {
        rect_prism(visor_drop_x0, visor_drop_x1,
                   visor_drop_y0, visor_drop_y1,
                   visor_drop_z0, visor_drop_z1);

        // remove bottom-outboard corner of vertical drop to avoid support
        rect_prism(
            visor_drop_x1 - visor_drop_corner_chop_x,
            visor_drop_x1 + eps,
            visor_drop_y0 - eps,
            visor_drop_y1 + eps,
            visor_drop_z0 - eps,
            visor_drop_z0 + visor_drop_corner_chop_z
        );
    }
}
module tunnel_inner_stop() {
    rect_prism(inner_stop_x0, inner_stop_x1, inner_stop_y0, inner_stop_y1, inner_stop_z0, inner_stop_z1);
}

module tunnel_system() {
    slotted_tunnel_only();
    // The former visor span, curtain, and inner stop restrained the old
    // uncontained weight/latch package. The pivot-constrained keyed corral
    // supersedes all three; leaving them out removes snagging surfaces from
    // the latch's swept path.
    tunnel_crook();
}

module fixed_rig() {
    union() {
        wall_only();
        latch_base_only();
        tunnel_system();
        carriage_blinders();
    }
}

// =========================================================
// MOVING LATCH — ZIPPER-DATUM CORRAL WITH RELOCATED PIVOT
// =========================================================
module canonical_latch_core() {
    translate([pivot_x,0,pivot_z])
        difference() {
            // The corral floor is now the latch beam. Retain only the
            // canonical pivot eye; the redundant long arm is gone.
            cyl_y_span(eye_outer_d, 0, latch_t);
            cyl_y_span(eye_inner_d, -0.1, latch_t + 0.2);

            // Remove only the unused outer arc below the corral shelf so the
            // complete moving latch prints on one coplanar Z surface. This
            // cut remains well below the pivot bore and does not alter fit.
            rect_prism(-eye_outer_d/2 - 1,
                        eye_outer_d/2 + 1,
                       -0.1, latch_t + 0.2,
                       -eye_outer_d/2 - 1,
                        pivot_eye_flat_local_z);
        }
}

module fn_weight_corral() {
    difference() {
      union() {
        // Shallow floor beneath both the pocket and solid keyed extension.
        rect_prism(corral_floor_x0, corral_floor_x1,
                   corral_outer_y0, corral_outer_y1,
                   corral_floor_z0, corral_floor_z);

        // Retain only the -Y wall. The frame wall itself closes the +Y side
        // with 0.30 mm running clearance, so a second printed wall there is
        // redundant.
        rect_prism(corral_inner_x0, corral_inner_x1,
                   corral_outer_y0, corral_inner_y0,
                   corral_floor_z, corral_wall_z1);

        // Only the pivot-side X wall belongs to the moving latch. The fixed
        // rig's left guide closes the opposite end when the latch is parked.
        rect_prism(corral_inner_x1, corral_floor_x1,
                   corral_outer_y0, corral_outer_y1,
                   corral_floor_z, corral_wall_z1);

        // Full-depth far-end wall outside the 41.5 mm weight pocket. This is
        // deliberately substantial so the Y-retention notch is not carried
        // by a thin side-wall cantilever.
        rect_prism(corral_floor_x0, corral_inner_x0,
                   corral_outer_y0, corral_outer_y1,
                   corral_floor_z, corral_wall_z1);

        // Short load path from the pen into the eye, confined to the eye plane
        // so it clears both the keeper and fixed shoulder.
        rect_prism(pivot_transition_x0, pivot_transition_x1,
                   pivot_transition_y0, pivot_transition_y1,
                   corral_floor_z0, corral_wall_z1);
      }

      // Fully enclosed X/Y socket, open only at the top. It swings downward
      // off the fixed tooth while the closed latch is positively guided in Y.
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

// =========================================================
// KEEPER — UNCHANGED CANONICAL GEOMETRY
// =========================================================
module c_keeper() {
    difference() {
        cyl_y_span(clip_outer_d, 0, clip_t);
        cyl_y_span(grip_hole_d, -0.1, clip_t + 0.2);

        rect_prism(0, clip_outer_d/2 + 0.5,
                   -0.1, clip_t + 0.1,
                   -gap_w/2, gap_w/2);

        rect_prism(grip_hole_d/2 - 0.2,
                   grip_hole_d/2 - 0.2 + flat_depth,
                   -0.1, clip_t + 0.1,
                   -gap_w/2 - 0.4, gap_w/2 + 0.4);
    }
}

module fn_weight_proxy() {
    proxy_x0 = corral_inner_x0 + (corral_clear_w_x-weight_piece_w_x)/2;
    proxy_x1 = proxy_x0 + weight_piece_w_x;
    proxy_y0 = corral_global_inner_y0 + (corral_clear_d_y-weight_piece_d_y)/2;
    proxy_y1 = proxy_y0 + weight_piece_d_y;

    color([0.42,0.44,0.46,0.85])
        rect_prism(proxy_x0, proxy_x1,
                   proxy_y0, proxy_y1,
                   corral_floor_z, corral_floor_z + weight_proxy_h_z);
}

module closed_assembly() {
    color([0.78,0.72,0.48]) fixed_rig();
    color([0.18,0.48,0.88])
        translate([0, latch_install_y, 0]) swinging_latch();
    color([0.90,0.45,0.12])
        translate([pivot_x, keeper_install_y, pivot_z]) c_keeper();
    if (show_weight_proxy) fn_weight_proxy();
}

if (render_part == 0)
    closed_assembly();
else if (render_part == 1)
    fixed_rig();
else if (render_part == 2)
    swinging_latch();
else if (render_part == 3)
    c_keeper();
else {
    fixed_rig();
    translate([20, -28, 0]) swinging_latch();
    // Keep the separate keeper clear of the translated latch's pivot eye.
    // The latch reaches X=33 here; the keeper now begins at X=40.
    translate([45, -28, 0]) c_keeper();
}
