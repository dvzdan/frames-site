// DOUBLE TAKE FRAMES — STATIONARY-COLLAR STRING HOOP
// DTF_RELEASE: 4.0.0
// Status: CANONICAL
//
// Replaces the long pressure bar with one-purpose geometry:
// - a tight collar around the clock movement's immobile 6.8 mm outer sleeve;
// - a short backboard rooted in that collar;
// - one projecting, side-loadable string hoop at the established boss datum.
// The rotating hour and minute capstans remain completely separate.
// Clock-body retention is intentionally omitted; mounting putty remains the
// simpler optional remedy if a particular movement fits loosely.
// v3.2.2 restores the collar/backboard base to the exact 0.80 mm thickness of
// v3.1.3's thin central stationary floor. The former 3.00 mm value incorrectly
// inherited the old pressure bar's full thickness and made the base excessive.
// v3.2.1 restores the complete v3.1.3 functional boss interface verbatim:
// collar fit, boss envelope, round seat, angled side-loading slit, full beak,
// and internal beak channel. Only the long pressure bar remains removed.

$fn = 64;
eps = 0.05;

// 0 = print layout, collar rear face on the bed
// 1 = installed-coordinate preview
render_mode = 0;

// Exact established stationary-sleeve fit from v3.1.3.
stationary_column_spec_d = 6.80;
stationary_collar_bore_d = 6.25;
stationary_collar_outer_d = 10.80;
stationary_collar_depth_y = 0.80;
stationary_axis_z = -0.46;

// Exact v3.1.3 boss and side-load interface.
string_boss_w_x = 6.00;
string_boss_d_y = 4.00;
string_boss_h_z = 1.60;
string_hole_d = 2.50;
string_boss_xc = 0;
string_boss_y0 = 1.30;
string_boss_z0 = 8.90;
string_hole_xc = string_boss_xc;
string_hole_yc = string_boss_y0+string_boss_d_y/2;
beak_rigid_raise_y = 1.20;

hoop_center_x = string_hole_xc;
hoop_center_y = string_hole_yc+beak_rigid_raise_y;
hoop_plate_z0 = string_boss_z0;
hoop_plate_h_z = string_boss_h_z;
hoop_hole_d = string_hole_d;
hoop_plate_w_x = string_boss_w_x;
hoop_front_y = string_boss_y0+beak_rigid_raise_y+string_boss_d_y;
capstan_flange_d = 16.00;
capstan_flange_clearance_z =
    hoop_plate_z0-(stationary_axis_z+capstan_flange_d/2);

side_loading_slot_w_y = 0.50;
side_loading_slot_angle_deg = 25;
side_loading_slot_hole_overlap = 0.40;
side_loading_slot_shift_x = 0.35;

// Exact complete beak from v3.1.3.
beak_root_xc = string_hole_xc;
beak_tip_xc = string_hole_xc;
beak_wall_y = 1.20;
beak_root_front_y = string_hole_yc+string_hole_d/2+0.25;
beak_axial_center_shift_y = 0.50;
beak_tip_d_y = 0.80;
beak_tip_front_y = 3.60+beak_axial_center_shift_y;
beak_tip_back_y = beak_tip_front_y-beak_tip_d_y;
beak_tip_yc = (beak_tip_back_y+beak_tip_front_y)/2;
beak_root_yc = (beak_wall_y+beak_root_front_y)/2;
beak_root_d_y = beak_root_front_y-beak_wall_y;
beak_root_z = string_boss_z0+0.10;
beak_root_w_x = 5.00;
beak_root_h_z = 1.50;
beak_tip_shoulder_w_x = 4.00;
beak_tip_apex_w_x = 0.8*beak_tip_shoulder_w_x;
beak_tip_taper_h_z = 0.60;
clock_spindle_top_cassette_y = 8.00;
beak_tip_center_cassette_y = clock_spindle_top_cassette_y-1.00;
guide_origin_cassette_y = 1.00;
beak_tip_z = beak_tip_center_cassette_y-guide_origin_cassette_y;
beak_outlet_local_z = beak_tip_z+0.45;
beak_channel_tip_yc = 2.80+beak_axial_center_shift_y;
beak_channel_root_d = 1.00;
beak_channel_tip_d = 1.00;

// The backboard stays behind the rotating flange plane. Its top arm occupies
// the old boss envelope but has no clock-retention function.
backboard_w_x = 6.00;
backboard_y0 = -stationary_collar_depth_y/2;
backboard_y1 = stationary_collar_depth_y/2;
backboard_z0 = stationary_axis_z + stationary_collar_outer_d/2 - 1.40;
backboard_z1 = hoop_plate_z0 + hoop_plate_h_z;

assert(stationary_collar_bore_d < stationary_column_spec_d,
       "stationary collar is not a friction fit");
assert((stationary_collar_outer_d-stationary_collar_bore_d)/2 >= 2.0-eps,
       "stationary collar wall is too thin");
assert(side_loading_slot_w_y < hoop_hole_d,
       "side-loading mouth must remain narrower than the string seat");
assert(capstan_flange_clearance_z >= 1.0,
       "outboard hoop arm intrudes into the rotating capstan sweep");

module cyl_y(d,y0,y1,xc=0,zc=0){
    translate([xc,y1,zc])
        rotate([90,0,0])
            cylinder(d=d,h=y1-y0);
}

module stationary_collar(){
    difference(){
        cyl_y(
            stationary_collar_outer_d,
            -stationary_collar_depth_y/2,
             stationary_collar_depth_y/2,
            0,
            stationary_axis_z
        );
        cyl_y(
            stationary_collar_bore_d,
            -stationary_collar_depth_y/2-eps,
             stationary_collar_depth_y/2+eps,
            0,
            stationary_axis_z
        );
    }
}

module collar_backboard(){
    // Rear radial spoke/backboard: it rises beside the stationary sleeve only
    // at the collar plane, then hands off to the outboard axial post above the
    // rotating flange envelope.
    translate([
        -backboard_w_x/2,
        backboard_y0,
        backboard_z0
    ])
        cube([
            backboard_w_x,
            backboard_y1-backboard_y0,
            backboard_z1-backboard_z0
        ]);
}

module projecting_hoop_arm_solid(){
    // Axial post/arm outside the capstan sweep. In a side view this is the
    // upright green leg and short basketball-hoop rim from the concept sketch.
    translate([
        -hoop_plate_w_x/2,
        backboard_y0,
        hoop_plate_z0
    ])
        cube([
            hoop_plate_w_x,
            hoop_front_y-backboard_y0,
            hoop_plate_h_z
        ]);
}

module side_loading_slot_cutter(){
    hole_yc = string_hole_yc+beak_rigid_raise_y;
    slot_centerline_offset = string_hole_d/2
        -side_loading_slot_w_y/2
        -side_loading_slot_hole_overlap;
    slot_inner_x = string_hole_xc
        -cos(side_loading_slot_angle_deg)*slot_centerline_offset
        +side_loading_slot_shift_x;
    slot_inner_y = hole_yc
        +sin(side_loading_slot_angle_deg)*slot_centerline_offset;
    slot_outer_y = string_boss_y0+beak_rigid_raise_y+string_boss_d_y+3;
    slot_outer_x = slot_inner_x
        +tan(side_loading_slot_angle_deg)*(slot_outer_y-slot_inner_y);
    slot_z0 = -20;
    slot_z1 = 20;

    hull(){
        translate([slot_inner_x,slot_inner_y,(slot_z0+slot_z1)/2])
            cylinder(
                h=slot_z1-slot_z0,
                d=side_loading_slot_w_y,
                center=true
            );
        translate([slot_outer_x,slot_outer_y,(slot_z0+slot_z1)/2])
            cylinder(
                h=slot_z1-slot_z0,
                d=side_loading_slot_w_y,
                center=true
            );
    }
}

module captive_beak_solid(){
    translate([0,beak_rigid_raise_y,0])
        hull(){
            translate([beak_root_xc,beak_root_yc,beak_root_z])
                cube([
                    beak_root_w_x,
                    beak_root_d_y,
                    beak_root_h_z
                ],center=true);

            translate([beak_tip_xc,beak_tip_yc,0])
                rotate([90,0,0])
                    linear_extrude(height=beak_tip_d_y,center=true)
                        polygon(points=[
                            [-beak_tip_apex_w_x/2,beak_tip_z],
                            [ beak_tip_apex_w_x/2,beak_tip_z],
                            [ beak_tip_shoulder_w_x/2,
                              beak_tip_z+beak_tip_taper_h_z],
                            [-beak_tip_shoulder_w_x/2,
                              beak_tip_z+beak_tip_taper_h_z]
                        ]);
        }
}

module captive_beak_channel(){
    hull(){
        translate([
            string_hole_xc,
            string_hole_yc+beak_rigid_raise_y,
            string_boss_z0+0.80
        ])
            sphere(d=beak_channel_root_d);
        translate([
            beak_tip_xc,
            beak_channel_tip_yc+beak_rigid_raise_y,
            beak_outlet_local_z
        ])
            sphere(d=beak_channel_tip_d);
    }
}

module hoop_string_void(){
    translate([
        hoop_center_x,
        hoop_center_y,
        hoop_plate_z0-eps
    ])
        cylinder(
            d=hoop_hole_d,
            h=hoop_plate_h_z+2*eps
        );

    side_loading_slot_cutter();
}

module stationary_string_hoop_installed(){
    difference(){
        union(){
            stationary_collar();
            collar_backboard();
            projecting_hoop_arm_solid();
            captive_beak_solid();
        }
        hoop_string_void();
        captive_beak_channel();
    }
}

module stationary_string_hoop_print_layout(){
    // Installed +Y becomes print +Z. The collar rear face, backboard, and rear
    // edge of the projecting arm all begin on the build plate as one body.
    translate([0,0,stationary_collar_depth_y/2])
        rotate([90,0,0])
            stationary_string_hoop_installed();
}

if(render_mode==1)
    stationary_string_hoop_installed();
else
    stationary_string_hoop_print_layout();
