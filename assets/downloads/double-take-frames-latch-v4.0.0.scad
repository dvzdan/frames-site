// DOUBLE TAKE FRAMES — DRY/WET UNIVERSAL LATCH
// DTF_RELEASE: 4.0.0
// Release revision: 4.0.0
// Based on latch-and-keeper-v2.0.4-pending.scad and the approved geometry from
// latch-top-eyelet-v0.2.6-experimental.scad.
// Status: CANONICAL.
//
// Pending change in 2.2.4:
// - Extends the removable wet-eyelet cutter-access neck to 2.40 mm in Z.
// - Thickens the permanent eyelet opposite the cut: the radial wall increases
//   from 2.20 to 3.00 mm and its X thickness increases from 3.40 to 4.20 mm.
// - Preserves the 2.40 mm bore, mounting center, and 0.60 mm snip core.
//
// Pending change in 2.2.3:
// - Extends the removable wet-eyelet neck to 1.80 mm in Z so cutter jaws can
//   engage it without loading and splitting the permanent eyelet ring.
// - Retains the centered 0.60 mm one-nozzle core as the actual snip section.
//
// Pending change in 2.2.2:
// - Tapers each wet-loop snip neck through the loop thickness as well as in
//   its Y/Z profile, using opposed conical face reliefs.
// - Leaves only a centered 0.60 mm one-nozzle core to cut while preserving the
//   full-strength permanent ring and root away from the disposable neck.
//
// Pending change in 2.2.1:
// - Toughens only the wet=true top suspension loops: increases their X
//   thickness, radial wall, and latch-root engagement.
// - Replaces the sub-line snip ligament with a calculated tapered neck whose
//   weakest radial section is one predictable 0.60 mm nozzle line.
// - Leaves the standard/dry latch and every mating datum unchanged.
//
// Pending change in 2.2.0:
// - Mirrors the complete wet latch in X about the fixed rig's wall midpoint.
//   The pivot eye, bayonet keyway, weight corral, keyed socket, and both wet
//   suspension eyelets therefore reverse together and remain registered with
//   wall-rig v2.1.0.
// - Keeps wet_latch=false geometry and every local working dimension unchanged.
//
// Pending change in 2.1.3:
// - Replaces each rounded wet-eyelet snip-slot cap with a tapered polygonal
//   void. Its upper roof is 45 degrees in print Z, eliminating the tiny
//   downward-facing cap facets that could form stalactites.
// - Preserves the approved user-facing bridge location and at least 0.45 mm
//   of sacrificial material for post-print snipping.
//
// Pending change in 2.1.2:
// - Raises both user-facing wet-eyelet snip voids by 15 degrees to provide
//   clearer cutter access above the adjoining latch structure.
// - Keeps the 0.90 mm void width and 0.45 mm sacrificial bridge unchanged.
//
// Pending change in 2.1.1:
// - Mirrors both wet-eyelet snip voids across the Y centerline so the slit is
//   visible to the user in the installed assembly.
// - Keeps the approved downward Z orientation, 0.90 mm void width, and
//   0.45 mm sacrificial bridge unchanged.
//
// Pending change in 2.1.0:
// - Adds the same diagonal near-open void to both wet-latch suspension
//   eyelets. Each void merges with the bore but stops 0.45 mm short of the
//   exterior, leaving a one-line sacrificial bridge that can be snipped.
// - The voids exist only on the wet-latch eyelets; dry geometry is unchanged.
//
// Pending change in 2.0.5:
// - Consolidates the standard and double-top-eyelet latch carriages behind one
//   boolean. wet_latch=false emits the unchanged neutral/standard carriage;
//   wet_latch=true adds only the two established top suspension eyelets, far
//   ledge, and buttress from the v0.2.6 wet trial.
// - The 13.0 mm clear pocket, Y=-8.0 mm installed centerline, pivot eye, keyed
//   socket, retaining walls, and flat-floor print orientation are unchanged.
//
$fn = 96;

eps = 0.05;

// 0 = clipless keyed latch only (default)
// 1 = FN-weight latch only
// 2 = legacy C-shaped keeper only
render_part = 0;

// false = neutral/standard dry latch carriage
// true  = standard carriage plus the double top-eyelet wet suspension
wet_latch = false;

// Must match wall-rig v2.1.0. Mirroring about the fixed wall envelope's center
// reverses the wet mechanism without translating or widening the assembly.
wet_rig_wall_x0 = -66.1;
wet_rig_wall_x1 =  16.0;
wet_assembly_mirror_x = (wet_rig_wall_x0 + wet_rig_wall_x1) / 2;

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

// =========================================================
// OPTIONAL WET DOUBLE-TOP-EYELET SUSPENSION
// =========================================================
// These are the unchanged working dimensions from top-eyelet v0.2.6.  The two
// bores share one Y/Z centerline and run longitudinally along X.
pva_nominal_d = 0.40;
support_eye_axis_y = (corral_outer_y0 + corral_outer_y1) / 2;
wet_latch_print_nozzle_d = 0.60;
support_eye_t_x = 4.20;
support_eye_inner_r = 1.20;
support_eye_outer_r = 4.20;
support_eye_base_half_w_y = latch_t / 2;
support_eye_center_z = corral_wall_z1 + 3.00;
support_eye_base_z0 = corral_wall_z1 - eps;
support_eye_base_z1 = corral_wall_z1 + 1.20;

support_eye_pivot_x = (pivot_transition_x0 + pivot_transition_x1) / 2;
support_eye_far_wall_overlap_x = 0.20;
support_eye_far_clearance_x = 1.00;
support_eye_far_x = corral_floor_x0 - support_eye_far_clearance_x
                    - support_eye_t_x / 2;
support_eye_far_ledge_t_z = 1.20;
support_eye_far_base_z0 = corral_wall_z1 - support_eye_far_ledge_t_z;
support_eye_far_base_z1 = corral_wall_z1;
support_eye_far_gusset_t_y = 2*support_eye_base_half_w_y;
support_eye_far_gusset_drop_z = 2.40;

// Post-print snip opening for both wet suspension eyelets. In the eyelet's
// Y/Z profile this points down and toward -Y so it faces the user when the
// latch is installed.
// The subtraction joins the bore but deliberately stops before the outside.
support_eye_snip_void_w = 0.90;
support_eye_snip_bridge = wet_latch_print_nozzle_d;
support_eye_snip_inner_y = -(support_eye_inner_r-0.10);
support_eye_snip_inner_top_z = support_eye_snip_void_w/2;
support_eye_snip_inner_bottom_z = -support_eye_snip_void_w/2;
support_eye_snip_outer_tip_w_z = 4*wet_latch_print_nozzle_d;
// Solve the 45-degree tapered roof against the circular eye profile so the
// lower outside tip leaves exactly one nozzle line of radial material. This
// makes the disposable neck predictable without weakening the working ring.
support_eye_snip_outer_target_r =
    support_eye_outer_r-support_eye_snip_bridge;
support_eye_snip_outer_solution_k =
    support_eye_snip_inner_top_z
    +abs(support_eye_snip_inner_y)
    -support_eye_snip_outer_tip_w_z;
support_eye_snip_outer_y = -(
    support_eye_snip_outer_solution_k
    +sqrt(
        2*pow(support_eye_snip_outer_target_r,2)
        -pow(support_eye_snip_outer_solution_k,2)
    )
    )/2;
support_eye_snip_outer_top_z = support_eye_snip_inner_top_z
    -abs(support_eye_snip_outer_y-support_eye_snip_inner_y);
support_eye_snip_outer_bottom_z = support_eye_snip_outer_top_z
    -support_eye_snip_outer_tip_w_z;
support_eye_snip_core_t_x = wet_latch_print_nozzle_d;
support_eye_snip_face_relief_d = 1.80;
support_eye_snip_core_relief_d = 0.70;
support_eye_snip_face_relief_depth_x =
    (support_eye_t_x-support_eye_snip_core_t_x)/2;

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

// Profile coordinates are [Y,Z]. The extrusion transform maps its local
// extrusion axis to global X, so both wet eyelet bores run longitudinally.
module support_eye_outer_profile_2d(
    base_z0=support_eye_base_z0,
    base_z1=support_eye_base_z1
) {
    hull() {
        translate([support_eye_axis_y,support_eye_center_z])
            circle(r=support_eye_outer_r,$fn=48);
        translate([
            support_eye_axis_y-support_eye_base_half_w_y,
            base_z0
        ])
            square([
                2*support_eye_base_half_w_y,
                base_z1-base_z0
            ]);
    }
}

module support_eye_profile_2d(
    base_z0=support_eye_base_z0,
    base_z1=support_eye_base_z1
) {
    difference() {
        support_eye_outer_profile_2d(base_z0,base_z1);
        translate([support_eye_axis_y,support_eye_center_z])
            circle(r=support_eye_inner_r,$fn=48);
        support_eye_snip_void_2d();
    }
}

module support_eye_snip_void_2d() {
    translate([support_eye_axis_y,support_eye_center_z])
        polygon([
            [support_eye_snip_inner_y,
             support_eye_snip_inner_top_z],
            [support_eye_snip_outer_y,
             support_eye_snip_outer_top_z],
            [support_eye_snip_outer_y,
             support_eye_snip_outer_bottom_z],
            [support_eye_snip_inner_y,
             support_eye_snip_inner_bottom_z]
        ]);
}

module support_eye_snip_thickness_reliefs(xc) {
    neck_y = support_eye_axis_y
        +support_eye_snip_outer_y
        -support_eye_snip_bridge/2;
    neck_z = support_eye_center_z
        +(support_eye_snip_outer_top_z
          +support_eye_snip_outer_bottom_z)/2;

    // Opposed tapered pockets remove the full-thickness cutting burden but
    // stop one nozzle line apart at the eye's X center plane.
    translate([
        xc-support_eye_t_x/2-eps,
        neck_y,
        neck_z
    ])
        rotate([0,90,0])
            cylinder(
                h=support_eye_snip_face_relief_depth_x+eps,
                d1=support_eye_snip_face_relief_d,
                d2=support_eye_snip_core_relief_d,
                $fn=32
            );

    translate([
        xc+support_eye_t_x/2+eps,
        neck_y,
        neck_z
    ])
        rotate([0,-90,0])
            cylinder(
                h=support_eye_snip_face_relief_depth_x+eps,
                d1=support_eye_snip_face_relief_d,
                d2=support_eye_snip_core_relief_d,
                $fn=32
            );
}

module support_eye(
    xc,
    base_z0=support_eye_base_z0,
    base_z1=support_eye_base_z1
) {
    difference(){
        multmatrix([
            [0,0,1,xc-support_eye_t_x/2],
            [1,0,0,0],
            [0,1,0,0],
            [0,0,0,1]
        ])
            linear_extrude(height=support_eye_t_x)
                support_eye_profile_2d(base_z0,base_z1);

        support_eye_snip_thickness_reliefs(xc);
    }
}

module far_support_eye_ledge() {
    eye_inner_face_x = support_eye_far_x + support_eye_t_x/2;
    rect_prism(
        eye_inner_face_x-eps,
        corral_floor_x0+support_eye_far_wall_overlap_x,
        support_eye_axis_y-support_eye_base_half_w_y,
        support_eye_axis_y+support_eye_base_half_w_y,
        support_eye_far_base_z0,
        support_eye_far_base_z1
    );
}

module far_support_eye_gusset() {
    eye_outer_face_x = support_eye_far_x - support_eye_t_x/2;
    wall_root_x = corral_floor_x0 + support_eye_far_wall_overlap_x;
    gusset_y0 = support_eye_axis_y - support_eye_far_gusset_t_y/2;

    multmatrix([
        [1,0,0,0],
        [0,0,1,gusset_y0],
        [0,1,0,0],
        [0,0,0,1]
    ])
        linear_extrude(height=support_eye_far_gusset_t_y)
            polygon([
                [eye_outer_face_x+eps, support_eye_far_base_z0+eps],
                [wall_root_x,          support_eye_far_base_z0+eps],
                [wall_root_x,          support_eye_far_base_z0
                                       -support_eye_far_gusset_drop_z]
            ]);
}

module top_suspension_eye_assembly() {
    far_support_eye_ledge();
    far_support_eye_gusset();
    support_eye(
        support_eye_far_x,
        support_eye_far_base_z0,
        support_eye_far_base_z1
    );
    support_eye(support_eye_pivot_x);
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

            // Matching opposite wall for universal dry/water use. It rises
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
            if(wet_latch)
                top_suspension_eye_assembly();
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

module selected_swinging_latch(){
    if(wet_latch)
        translate([2*wet_assembly_mirror_x,0,0])
            mirror([1,0,0])
                swinging_latch();
    else
        swinging_latch();
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
assert(!wet_latch
       || 2*support_eye_inner_r >= 2*pva_nominal_d+0.8-eps,
       "wet support-eye passage is too tight for two nominal PVA strands");
assert(!wet_latch
       || support_eye_outer_r-support_eye_inner_r >= 1.80-eps,
       "wet support-eye working arch is too thin");
assert(!wet_latch
       || support_eye_snip_bridge >= wet_latch_print_nozzle_d-eps,
       "wet support-eye snip bridge is below one nozzle line");
assert(!wet_latch
       || support_eye_snip_core_t_x >= wet_latch_print_nozzle_d-eps,
       "wet support-eye snip core is below one nozzle line");
assert(!wet_latch
       || (support_eye_snip_face_relief_depth_x > 0
           && support_eye_snip_face_relief_d
                > support_eye_snip_core_relief_d),
       "wet support-eye thickness taper is invalid");
assert(!wet_latch
       || support_eye_snip_bridge+support_eye_snip_void_w
              < support_eye_outer_r-support_eye_inner_r+eps,
       "wet support-eye snip void leaves no radial bridge");
assert(!wet_latch
       || abs((support_eye_snip_outer_top_z
               -support_eye_snip_inner_top_z)
              /(support_eye_snip_outer_y-support_eye_snip_inner_y))
              >= 1-eps,
       "wet support-eye snip-void roof is shallower than 45 degrees");
assert(!wet_latch
       || support_eye_outer_r
          -sqrt(pow(support_eye_snip_outer_y,2)
                +pow(support_eye_snip_outer_bottom_z,2))
              >= support_eye_snip_bridge-eps,
       "wet support-eye snip void leaves too little sacrificial bridge");
assert(!wet_latch
       || 2*support_eye_inner_r <= 2.40+eps,
       "wet eyelet bore exceeds the intended short bridge span");
assert(!wet_latch
       || (support_eye_axis_y-support_eye_base_half_w_y >= -eps
           && support_eye_axis_y+support_eye_base_half_w_y <= latch_t+eps),
       "wet support-eye bases leave the solid latch Y span");
assert(!wet_latch
       || (support_eye_pivot_x-support_eye_t_x/2
               >= pivot_transition_x0-eps
           && support_eye_pivot_x+support_eye_t_x/2
               <= pivot_transition_x1+eps),
       "wet pivot support eye is not fully rooted in the transition");
assert(!wet_latch
       || abs(corral_floor_x0-(support_eye_far_x+support_eye_t_x/2)
              -support_eye_far_clearance_x) < eps,
       "wet far support eye lost its intended 1 mm clearance ledge");
assert(!wet_latch
       || support_eye_far_x+support_eye_t_x/2
              <= latch_key_notch_x0-1.90+eps,
       "wet far support eye intrudes into the keyed socket");
assert(!wet_latch
       || abs(support_eye_axis_y
              -(corral_outer_y0+corral_outer_y1)/2) < eps,
       "wet top support eyes no longer share the latch centerline");

if (render_part == 0 || render_part == 1)
    selected_swinging_latch();
else if (render_part == 2)
    c_keeper();
