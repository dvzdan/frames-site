$fn = 96;

inch = 25.4;
eps  = 0.05;

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

// Common outward Y plane for the latch pad, tunnel-side stop, and weight
// stops/backer. Keeping one datum makes all three contact faces flush.
shared_contact_depth_y = 8.0;

// wall will auto-expand to fit both latch base and tunnel
wall_margin = 5;
// 
// LATCH BASE PARAMS
// =========================================================
pad_w = 16;   // X
pad_h = 16;   // Z
pad_t = shared_contact_depth_y; // protrusion toward viewer => negative Y

standoff_d = 9.5;
standoff_h = 0.8;   // along Y
post_d     = 5.5;
post_h     = 4.0;   // along Y
neck_d     = 4.7;
neck_h     = 1.4;   // along Y

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

tip_x0 = bar_x_outer - tip_len;
tip_x1 = bar_x_outer;

// =========================================================
// TUNNEL PARAMS
// =========================================================
tunnel_w_x = 8.0;
tunnel_d_y = 13.0;
tunnel_h_z = 14.0;

slot_margin_y = 1;
slot_h_z      = 2.5;
slot_offset_z = -2.45; // preserves the existing -1.2 mm slot ceiling

// underside cubby
cubby_wall_y  = 1.0;
cubby_drop_z  = 6;
cubby_depth_z = 6.1;  // gains the 1.1 mm removed from the zipper-head slot
cubby_extra_y = -1.0;
cubby_floor_z = 1.2;

// placement controls
tunnel_gap_from_tip = 4.0;
tunnel_mount_dx     = 0.0;
tunnel_mount_dz     = 0.0;

tunnel_y_back  = 1;
tunnel_y_front = tunnel_y_back - tunnel_d_y;

// Move the complete zipper/tunnel mechanism outward as one unchanged unit.
// A solid wall of this thickness occupies its former wall-side position.
tunnel_system_standoff_y = 5.0;

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

tunnel_z0 = -tunnel_h_z/2 + tunnel_mount_dz;
tunnel_z1 =  tunnel_h_z/2 + tunnel_mount_dz;

slot_x0 = tunnel_x0 - eps;
slot_x1 = tunnel_x1 + eps;

slot_y0 = tunnel_y_front + slot_margin_y;
slot_y1 = tunnel_y_back  - slot_margin_y;

slot_zc = (tunnel_z0 + tunnel_z1) / 2 + slot_offset_z;
slot_z0 = slot_zc - slot_h_z/2;
slot_z1 = slot_zc + slot_h_z/2;

//=========================================================
// WEIGHT SIDE GUARDS
// =========================================================
weight_stack_w_x = 32;                // two bare stick-on wheel weights
weight_guard_slop_x = 3;              // 1.5 mm clearance per side
blinder_gap_x = weight_stack_w_x + weight_guard_slop_x; // 35 mm clear opening
carriage_center_x = -23.5;   // <-- set this to the carriage center
blinder_dx = 0;            // <-- shift knob
blinder_wall_x = 1.2;
blinder_y0 = tunnel_y_front;
blinder_y1 = tunnel_y_back;
blinder_z0 = tunnel_z1;
blinder_h_z = 6.0; 

// Continue each lateral guard to the relocated tunnel's outward Y face.
// The extension slopes downward toward a short blunt tip so a moving paper
// edge meets a lead-in surface rather than the former square guard end.
blinder_ramp_y0 = tunnel_y_front - tunnel_system_standoff_y;
blinder_ramp_tip_d_y = 0.6;
blinder_ramp_tip_h_z = 0.8;

blinder_left_x1  = carriage_center_x + blinder_dx - blinder_gap_x/2;
blinder_left_x0  = blinder_left_x1 - blinder_wall_x;

blinder_right_x0 = carriage_center_x + blinder_dx + blinder_gap_x/2;
blinder_right_x1 = blinder_right_x0 + blinder_wall_x;

// Carry the full guard clearance through the supporting geometry below.
weight_clear_x0 = blinder_left_x1;
weight_clear_x1 = blinder_right_x0;
latch_pad_x0 = weight_clear_x1;
latch_pad_x1 = pad_w/2;

// Lightweight stationary backer for the weight stack. X positioning comes
// from the double weights and lateral guides, so this contact can stay narrow.
weight_retainer_w_x = 12.0;
weight_backer_w_x = weight_retainer_w_x;
weight_backer_h_z = 5.0;
weight_backer_extension_y = shared_contact_depth_y;
zipper_head_max_h_z = 1.5;
latch_arm_h_z = 6.0;
weight_piece_h_z = 19.0;               // measured bulk wheel-weight height
weight_stack_height_factor_z = 1.0;    // all weight pieces sit at equal Z
resting_latch_top_z = slot_z0 + zipper_head_max_h_z + latch_arm_h_z;
captured_weight_top_z = resting_latch_top_z
                        + weight_stack_height_factor_z * weight_piece_h_z;
captured_weight_bottom_z = captured_weight_top_z - weight_piece_h_z;
weight_backer_xc = (weight_clear_x0 + weight_clear_x1) / 2;
weight_backer_x0 = weight_backer_xc - weight_backer_w_x/2;
weight_backer_x1 = weight_backer_xc + weight_backer_w_x/2;
weight_backer_y0 = -weight_backer_extension_y;
weight_backer_y1 = wall_t;
weight_backer_z1 = captured_weight_top_z;
weight_backer_z0 = weight_backer_z1 - weight_backer_h_z;
weight_backer_zc = (weight_backer_z0 + weight_backer_z1) / 2;

// Straight guide roof over the rear weight layer. A thin vertical tie stick
// attached to the moving weight stack passes through the roof slot, capturing
// the stack in X/Y while leaving it free to travel in Z.
weight_layer_depth_y = 5.0;
weight_overhang_clearance_y = 0.6;
weight_overhang_top_clearance_z = 0.6;
weight_overhang_roof_t_z = 1.5;
// Raise the connected upper backer/web/roof assembly without moving the
// separate lower nubs or increasing the established +27 mm wall envelope.
weight_retainer_raise_z = 2.0;
// After the raise, the roof top is +26.9 mm, leaving 0.1 mm below the wall top.
weight_retainer_wall_margin_z = 0.1;

// Measured wooden coffee stirrer in a deliberately loose guide slot. This is
// retention, not a bearing fit: generous X/Y clearance prevents the stick
// from wedging as the latch moves. The outer roof margin encloses the slot.
weight_guide_stick_w_x = 0.20 * inch;  // 5.08 mm
weight_guide_stick_d_y = 0.05 * inch;  // 1.27 mm
weight_stick_slot_clearance_x = 2.00;  // total clearance => 7.08 mm slot
weight_stick_slot_clearance_y = 1.75;  // total clearance => 3.02 mm slot
weight_stick_slot_outer_margin_y = 1.5;

weight_stick_slot_w_x = weight_guide_stick_w_x
                      + weight_stick_slot_clearance_x;
weight_stick_slot_d_y = weight_guide_stick_d_y
                      + weight_stick_slot_clearance_y;
weight_stick_slot_xc = weight_backer_xc;
weight_stick_slot_yc = weight_backer_y0
                     - weight_layer_depth_y
                     - weight_overhang_clearance_y;
weight_stick_slot_x0 = weight_stick_slot_xc - weight_stick_slot_w_x/2;
weight_stick_slot_x1 = weight_stick_slot_xc + weight_stick_slot_w_x/2;
weight_stick_slot_y0 = weight_stick_slot_yc - weight_stick_slot_d_y/2;
weight_stick_slot_y1 = weight_stick_slot_yc + weight_stick_slot_d_y/2;

weight_overhang_x0 = weight_backer_x0;
weight_overhang_x1 = weight_backer_x1;
weight_overhang_roof_y0 = weight_stick_slot_y0
                        - weight_stick_slot_outer_margin_y;
weight_overhang_roof_y1 = wall_t;
weight_overhang_roof_z0 = weight_backer_z1
                        + weight_overhang_top_clearance_z;
weight_overhang_roof_z1 = weight_overhang_roof_z0
                        + weight_overhang_roof_t_z;

// Fill the small wall-side gap between the upper Y stop and retainer roof.
weight_backer_web_z0 = weight_backer_z1;
weight_backer_web_z1 = weight_overhang_roof_z0;

// Two wall-rooted Y stops contact the lower portions of the two rear weights.
// Their centers follow the centers of the two 16 mm pieces rather than landing
// on the adhesive seam between them.
lower_weight_stop_bottom_inset_z = 1.0;
lower_weight_stop_each_w_x = 8.0;
lower_weight_stop_center_offset_x = weight_stack_w_x / 4; // +/- 8 mm
lower_weight_stop_extension_y = weight_backer_extension_y;
lower_weight_stop_h_z = 2.0;
lower_weight_stop_y0 = -lower_weight_stop_extension_y;
lower_weight_stop_y1 = wall_t;
lower_weight_stop_z0 = captured_weight_bottom_z
                     + lower_weight_stop_bottom_inset_z;
lower_weight_stop_z1 = lower_weight_stop_z0 + lower_weight_stop_h_z;
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

// The 5 mm backing follows only the three wall-contact footprints of the
// relocated system instead of filling their entire rectangular envelope.
tunnel_backing_y0 = tunnel_y_back - tunnel_system_standoff_y;
tunnel_backing_y1 = tunnel_y_back;

// =========================================================
// AUTO WALL FOOTPRINT
// =========================================================
hardware_x0 = min(latch_pad_x0, tunnel_x0);
hardware_x1 = max(latch_pad_x1, visor_x1);

hardware_z0 = min(-pad_h/2, min(tunnel_z0 - cubby_drop_z, visor_drop_z0));
hardware_z1 = max( pad_h/2, tunnel_z1);

wall_w = (hardware_x1 - hardware_x0) + 2*wall_margin;
wall_h = (hardware_z1 - hardware_z0) + 2*wall_margin;

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
    z1 = blinder_z0 + blinder_h_z;

    union() {
        rect_prism(blinder_left_x0, blinder_left_x1,
                   blinder_y0, blinder_y1,
                   blinder_z0, z1);

        rect_prism(blinder_right_x0, blinder_right_x1,
                   blinder_y0, blinder_y1,
                   blinder_z0, z1);

        lateral_guard_lead_in(blinder_left_x0, blinder_left_x1, z1);
        lateral_guard_lead_in(blinder_right_x0, blinder_right_x1, z1);
    }
}

module lateral_guard_lead_in(x0, x1, z1) {
    hull() {
        // Short printable nose at the common tunnel/guard outward plane.
        rect_prism(
            x0, x1,
            blinder_ramp_y0,
            blinder_ramp_y0 + blinder_ramp_tip_d_y,
            blinder_z0,
            blinder_z0 + blinder_ramp_tip_h_z
        );

        // Overlap the existing full-height guard at the ramp root.
        rect_prism(
            x0, x1,
            blinder_y0,
            blinder_y0 + blinder_ramp_tip_d_y,
            blinder_z0,
            z1
        );
    }
}

module stationary_weight_backer() {
    union() {
        rect_prism(
            weight_backer_x0, weight_backer_x1,
            weight_backer_y0, weight_backer_y1,
            weight_backer_z0, weight_backer_z1
        );

        rect_prism(
            weight_backer_x0, weight_backer_x1,
            weight_backer_y0, weight_backer_y1,
            weight_backer_web_z0, weight_backer_web_z1
        );
    }
}

module lower_weight_stop_nubs() {
    for (side = [-1, 1]) {
        nub_xc = weight_backer_xc
               + side * lower_weight_stop_center_offset_x;

        rect_prism(
            nub_xc - lower_weight_stop_each_w_x/2,
            nub_xc + lower_weight_stop_each_w_x/2,
            lower_weight_stop_y0, lower_weight_stop_y1,
            lower_weight_stop_z0, lower_weight_stop_z1
        );
    }
}

module weight_overhang_retainer() {
    difference() {
        rect_prism(
            weight_overhang_x0, weight_overhang_x1,
            weight_overhang_roof_y0, weight_overhang_roof_y1,
            weight_overhang_roof_z0, weight_overhang_roof_z1
        );

        rect_prism(
            weight_stick_slot_x0, weight_stick_slot_x1,
            weight_stick_slot_y0, weight_stick_slot_y1,
            weight_overhang_roof_z0 - eps,
            weight_overhang_roof_z1 + eps
        );
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
        difference() {
            wall_x0 = hardware_x0 - wall_margin - rig_wall_extra_x;
            wall_x1 = hardware_x1 + wall_margin + rig_wall_extra_x;

            wall_z0 = hardware_z0 - wall_margin + 2 - rig_wall_extra_z
                      + clock_wall_profile_dz;

            base_wall_z1 = hardware_z1 + wall_margin + 7 + rig_wall_extra_z
                           + clock_wall_profile_dz;
            wall_z1 = max(
                base_wall_z1,
                weight_overhang_roof_z1
                    + weight_retainer_raise_z
                    + weight_retainer_wall_margin_z
            );

            rect_prism(
                wall_x0, wall_x1,
                0, wall_t,
                wall_z0, wall_z1
            );
        }
}

module latch_base_only() {
    union() {
        rect_prism(latch_pad_x0, latch_pad_x1, pad_y_wall, pad_y_out, -pad_h/2, pad_h/2);
        cyl_y_span(standoff_d, standoff_y0, standoff_y1);
        cyl_y_span(post_d,     post_y0,     post_y1);
        cyl_y_span(neck_d,     neck_y0,     neck_y1);
    }
}

module slotted_tunnel_only() {
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

module tunnel_system_backing_wall() {
    union() {
        // Main tunnel body footprint.
        rect_prism(
            tunnel_x0, tunnel_x1,
            tunnel_backing_y0, tunnel_backing_y1,
            tunnel_z0, tunnel_z1
        );

        // Thin upper visor footprint.
        rect_prism(
            visor_x0, visor_x1,
            tunnel_backing_y0, tunnel_backing_y1,
            visor_z0, visor_z1
        );

        // Original inner-stop footprint.
        rect_prism(
            inner_stop_x0, inner_stop_x1,
            tunnel_backing_y0, tunnel_backing_y1,
            inner_stop_z0, inner_stop_z1
        );
    }
}

module relocated_tunnel_system() {
    translate([0, -tunnel_system_standoff_y, 0]) {
        slotted_tunnel_only();
        tunnel_visor();
        tunnel_visor_drop();
        tunnel_inner_stop();
        tunnel_crook();
    }
}

module assembly() {
    union() {
        wall_only();
        latch_base_only();
        tunnel_system_backing_wall();
        relocated_tunnel_system();
        carriage_blinders();
        translate([0, 0, weight_retainer_raise_z]) {
            stationary_weight_backer();
            weight_overhang_retainer();
        }
        lower_weight_stop_nubs();
    }
}

assembly();
