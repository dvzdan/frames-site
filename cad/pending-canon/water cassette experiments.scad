// WATER CASSETTE EXPERIMENTS
// Experimental copy of the shared cassette. The canonical main cassette is
// intentionally unchanged.
//
// Current experiment:
// - replace the delicate drip aperture with a robust direct-drop outlet;
// - replace the removable bucket with a fused lower reservoir and narrow riser;
// - branch a rigid, sheltered string-wetting chamber from the high water column;
// - pass PVA string through that chamber with a short exposed wet span;
// - provide a two-hole side-wall bridge for a luggage-tag / girth hitch;
// - provide a bottom drain and recessed plug seat.

$fn=128;
inch=25.4;
eps=0.05;

// Variant switches.
// dry controls clock-mechanism-specific cassette geometry.
// wet controls water-reveal-specific cassette geometry.
dry = false;
wet = true;

// Wet-system experiment selector. Only one lower receiver should be active.
wet_use_legacy_bucket = false;
wet_use_integrated_pva_receiver = true;

// Legacy dry-cassette presentation switch. The dot-pull branch keeps this
// false: the front skin stays closed while the internal side-winding passage
// through the gusset and clock outline remains present.
front_clock_cutout = false;

// Print support switch.
// true  = include temporary print-support/scaffolding geometry.
// false = omit the top scaffold/crossbar and the two floor gussets.
print_supports = true;

// =========================================================
// VARIANT OWNERSHIP NOTES
//
// dry-only = actual clock/prank hardware and its necessary cuts/supports.
// wet-only = water reservoir, bucket, water-side hooks, and water port cuts.
// neutral  = shared cassette/frame/paper/roller/trap structure.
//
// Some legacy module names are misleading. Do not assume ownership from
// a clock/water-ish name alone; check the comments near the module and
// the dry_variant_* / wet_variant_* grouping at the bottom.
// =========================================================

cassette_w=6.91*inch;
wall_h=9.0*inch+1;
photo_w_nom=5.0*inch;
photo_h_nom=7.0*inch;
bottom_t=3.0;
wall_t=3.0;
wall_offset=0.0;
side_frame_t=1.2;
bottom_t_thin=bottom_t-1.4;
bottom_w=cassette_w;
wall_w=cassette_w;
sacrificial_y=0.0;
cutout_side_nom=56.0;
cutout_area_nudge=1.0;
cutout_side=sqrt(cutout_side_nom*cutout_side_nom+cutout_area_nudge);
cutout_w=cutout_side;
clock_side_web=3.0;
cutout_x=cassette_w-clock_side_web-cutout_w;
cutout_z=bottom_t;
frame_w=8.0*inch;
nominal_spot_w=photo_w_nom;
nominal_spot_h=photo_h_nom;
nominal_border_left=(frame_w-nominal_spot_w)/2;
nominal_border_bottom=2.0*inch;
frame_x0=(wall_w-frame_w)/2;
frame_z0=bottom_t;
nominal_spot_x0=frame_x0+nominal_border_left;
nominal_spot_x1=nominal_spot_x0+nominal_spot_w;
nominal_spot_z0=frame_z0+nominal_border_bottom;
nominal_spot_z1=nominal_spot_z0+nominal_spot_h;
front_mask_inset_each_side=5.0;
view_x0=nominal_spot_x0+front_mask_inset_each_side;
view_x1=nominal_spot_x1-front_mask_inset_each_side;
view_z0=nominal_spot_z0+front_mask_inset_each_side;
view_z1=nominal_spot_z1-front_mask_inset_each_side;
view_w=view_x1-view_x0;
view_h=view_z1-view_z0;
hidden_pocket_fit=.8;
hidden_pocket_x0=nominal_spot_x0-hidden_pocket_fit/2;
hidden_pocket_x1=nominal_spot_x1+hidden_pocket_fit/2;
paper_slot_x0=hidden_pocket_x0;
paper_slot_x1=hidden_pocket_x1;
paper_gate_hole_w=3.0;
roller_raise_z=12;
roller_w=5.1*inch+4+12;
roller_r=0.75*inch;
roller_x=(cassette_w-roller_w)/2;
roller_cy=wall_offset+wall_t;
roller_cz=bottom_t+wall_h-roller_r+roller_raise_z;
gap_w=4.0*inch;
glide_t=2.0;
fang_embed=0.6;
glide_total_w=roller_w;
glide_each_w=(glide_total_w-gap_w)/2;
left_glide_x=roller_x;
right_glide_x=roller_x+glide_each_w+gap_w;
glide_y=roller_cy+roller_r-glide_t-fang_embed;
right_fang_w=glide_each_w;
connect_drop=3.0;
merge_overlap=1.6;
roller_trim_z=roller_cz-connect_drop;
glide_top_z=roller_trim_z+merge_overlap;
glide_h=glide_top_z;
fang_z1=glide_h;
fang_main_target_h=0.75*inch;
fang_main_z1=fang_z1;
fang_main_z0=fang_main_z1-fang_main_target_h;
rail_back_y=8.0;
rear_rail_h=wall_h+3.0;
backer_plane_y=glide_y+glide_t+rail_back_y;
side_lip_proj_y=2.0;
bottom_d=backer_plane_y;
clock_body_side=cutout_w;
clock_body_z0=cutout_z;
clock_body_z1=cutout_z+clock_body_side;
clock_stop_y0=wall_offset+wall_t-eps;
clock_top_stop_y_outer=backer_plane_y-clock_stop_y0;
clock_tab_w=8.0;
clock_tab_h_full=8.0;
clock_tab_h=clock_tab_h_full/2.0;
clock_top_tab_raise=0.4*inch;
clock_top_tab_lower=2.0;
clock_top_tab_z0=clock_body_z1-clock_tab_h_full+clock_top_tab_raise-clock_top_tab_lower;
target_roof_to_cassette_top=23.2;
shell_inner_top_z=rear_rail_h+target_roof_to_cassette_top;
side_panel_t=side_frame_t;
cassette_full_z0=bottom_t;
cassette_full_z1=shell_inner_top_z;
cassette_full_h=cassette_full_z1-cassette_full_z0;
side_lip_overlap_x=3;
side_lip_y1=bottom_d;
side_lip_y0=bottom_d-side_lip_proj_y;
side_lip_y_len=side_lip_y1-side_lip_y0;
bottom_shelf_open_h=8.0;
top_insert_open_h=14.0;
side_lip_z0=bottom_t+bottom_shelf_open_h;
side_lip_top_drop_z = 57;
side_lip_z1 = shell_inner_top_z - top_insert_open_h - side_lip_top_drop_z;
side_lip_h=side_lip_z1-side_lip_z0;
// Clock-side gussets/seatbelt void are intentionally isolated from
// the adjustable side/back retention rail. 5.0 matches the known-good
// thick-rail cassette geometry, while side_lip_overlap_x can now be
// tuned without moving or reshaping the clock-side gusset.
clock_side_gusset_overlap_x = 5.0;
clock_side_gusset_x1 = side_panel_t + clock_side_gusset_overlap_x;

top_cross_t=1.6;
top_cross_z0=shell_inner_top_z-top_cross_t;
top_cross_z1=shell_inner_top_z;
top_cross_z_len=top_cross_z1-top_cross_z0;
// Independent interior roof skin. Keep top_cross_t/top_cross_z0 unchanged so
// every existing roof-relative feature retains its original Z position.
top_cross_reinforcement_t=0.8;
tube_od=0.84*inch;
tube_r=tube_od/2;
tube_top_clearance=7.0;
tube_cz=top_cross_z1-tube_top_clearance-tube_r;
nipple_cy=roller_cy+tube_r+2;

front_frame_t=1.2;
acrylic_entry_gap = 1.2;
acrylic_gap = 1.0;

// Acrylic fit knobs.
// Sheet dimensions are X (width) by Z (height). The height is recorded here
// for fit review; the shelf-height knob below controls its vertical position.
acrylic_sheet_w = 147.0;
acrylic_sheet_h = 172.0;
// Increase/decrease this for a looser/tighter horizontal fit. This clearance
// is applied independently to each side of the sheet.
acrylic_side_clearance_x = 0.30;
acrylic_center_x = wall_w/2;
acrylic_channel_x0 = acrylic_center_x - acrylic_sheet_w/2 - acrylic_side_clearance_x;
acrylic_channel_x1 = acrylic_center_x + acrylic_sheet_w/2 + acrylic_side_clearance_x;

spacer_thickness=7;
front_buildout_total=front_frame_t+acrylic_gap+spacer_thickness;
front_buildout_y0=wall_offset-front_buildout_total;
acrylic_slot_y0=front_buildout_y0+front_frame_t;
acrylic_slot_y1 = acrylic_slot_y0 + acrylic_entry_gap;
acrylic_inner_y1 = acrylic_slot_y0 + acrylic_gap;
front_channel_y = acrylic_inner_y1;
buildout_x0=0;
buildout_z0=0;
buildout_z1=shell_inner_top_z;

rear_perimeter_inner_x0=side_panel_t;
rear_perimeter_inner_x1=wall_w-side_panel_t;

rear_guard_gap_below_roof=26.0;
perimeter_wall_top_z=top_cross_z0-rear_guard_gap_below_roof;

acrylic_top_feed_x0=acrylic_channel_x0;
acrylic_top_feed_x1=acrylic_channel_x1;
acrylic_top_feed_z0=buildout_z1-top_cross_t-eps;
acrylic_top_feed_z1=buildout_z1+eps;

paper_gate_outset_x=1;
paper_gate_left_x0=paper_slot_x0-paper_gate_hole_w-paper_gate_outset_x;
paper_gate_right_x0=paper_slot_x1+paper_gate_outset_x;

lower_front_fill_gap_below_view=1.0;
lower_front_fill_z1=view_z0-lower_front_fill_gap_below_view;

rear_guard_border_x=17.0;
rear_guard_x0=paper_gate_left_x0 - 1.2-1.5-5;
rear_guard_x1=paper_gate_right_x0 + paper_gate_hole_w + 1.2+1.5+5;
rear_guard_z0 = view_z0 - 7.0;
photo_hang_drop = 1.0;
rear_guard_z1=perimeter_wall_top_z;
rear_guard_center_strip_w=12.0;
rear_guard_center_x=(rear_guard_x0+rear_guard_x1)/2;

true_full_y0=front_buildout_y0-sacrificial_y;
true_full_y1=bottom_d+sacrificial_y;
true_full_y_len=true_full_y1-true_full_y0;

// Neutral branding: shallow negative-space lettering across the bottom front.
// It sits below the clock opening, where the assembled stand can conceal it.
// A local interior backing pad keeps the deboss from weakening the 1.2 mm
// front skin. Wider tracking and a bold face keep the URL readable in print.
website_label_left = "DoubleTakeFrames";
website_label_right = "com";
website_text_size = 7.5;
website_text_spacing = 1.18;
website_font = "Arial:style=Bold";
website_stroke_boost = 0.10;
website_deboss_depth = 0.55;

// Battery-isolator pull-hole knobs. These defaults preserve the position of
// the period in the original centered "DoubleTakeFrames.com" lettering.
// Adjust X/Z here; the complete lettering block follows automatically.
battery_pull_hole_x = cutout_x + 13.6306;
battery_pull_hole_z = clock_body_z0 + 7.1334;
battery_pull_hole_d = 1.8;

// Measured Arial Bold offsets from the original text block center to the
// period center. Keeping these explicit makes tiny placement changes simple.
website_dot_offset_x = 42.3786;
website_dot_offset_z = -2.8666;
website_front_x = battery_pull_hole_x - website_dot_offset_x;
website_front_z = battery_pull_hole_z - website_dot_offset_z;
// A shared baseline prevents the separately rendered "com" from riding high.
// This offset preserves the original full-label vertical placement.
website_text_baseline_z = website_front_z - 3.5813;

// Split-text anchors preserve the original spacing around the period. The
// physical pull hole itself supplies the visible dot.
website_left_anchor_from_dot_x = -1.4622;
website_right_anchor_from_dot_x = 1.8731;
website_backing_w = 150.0;
website_backing_h = 14.0;
website_backing_extra_t = 1.8;

rear_leg_w=3.2;
tenon_h=10.0;
tenon_extra_w=1.0;
tenon_w=rear_leg_w+2*tenon_extra_w;
socket_side_wall=1.4;
socket_drop=6;
socket_embed_top=0.8;
socket_wall_ear_x=2.0;
socket_fang_clear_x=-1.0;
socket_inset_x = 20.0;
left_socket_drop  = 3.0;
right_socket_drop = 6.0;
left_back_socket_x=
    left_glide_x
    - socket_fang_clear_x
    - tenon_w
    - socket_side_wall
    - socket_wall_ear_x
    + socket_inset_x;

right_back_socket_x=
    right_glide_x
    + right_fang_w
    + socket_fang_clear_x
    + socket_side_wall
    + socket_wall_ear_x
    - socket_inset_x;

back_board_slot_t=1.6;
back_socket_front_y=bottom_d+back_board_slot_t;
left_back_socket_z0 =
    shell_inner_top_z-(left_socket_drop+socket_embed_top);

right_back_socket_z0 =
    shell_inner_top_z-(right_socket_drop+socket_embed_top);
back_socket_bridge_z=1.0;
back_socket_bridge_h=back_socket_bridge_z;

retainer_pad_d=1.8;

// Economy backing-board fit. Keep the cassette envelope unchanged and tune
// only the four side hooks plus the shallow ramps beneath the top bridges.
backing_board_nominal_t_y = 1.30;
backing_board_side_interference_y = 0.10;
backing_board_side_pocket_y =
    backing_board_nominal_t_y - backing_board_side_interference_y;
backing_board_hook_h_z = 18.0;
upper_board_hook_z0 =
    shell_inner_top_z - top_insert_open_h - backing_board_hook_h_z - 57;

// The backing board is also undersized in X. Add a true side-contact pad at
// each lower hook; the translated upper-hook pair inherits the same pads.
// 0.50mm per side removes 1.00mm total lateral play without changing Y fit.
// The hook returns add this same amount to their original inward overlap so
// the shifted board edge remains fully seated in a true snap pocket.
backing_board_side_pad_x = 0.50;

// Two top pockets reproduce the side-hook cross-section beneath the existing
// top bridges. The return begins at the same 1.20 mm board pocket and descends
// far enough to capture the undersized board's top edge as a real socket.
top_board_snap_w_x = 6.0;
top_board_snap_return_t_y = side_panel_t;
top_board_snap_lip_overlap_z = 5.0;

// Two inward-side stops descend 1.5 mm below the +Y returns. That stagger gives
// the board a first-contact lead-in before it enters the full 1.20 mm Y pocket,
// while still preventing its top edge from tipping inward.
top_board_inward_fang_w_x = 5.0;
top_board_inward_fang_d_y = 2.2;
top_board_inward_fang_h_z = 6.5;

mask_center_extra_y = 0;
mask_core_w         = 25.4;
mask_total_w        = 50.0;
mask_slices         = 100;
shelf_edge_z        = rear_guard_z0 - photo_hang_drop;
// Shift the original 1 mm acrylic/paper shelves upward. This intentionally
// shortens the channel while leaving the lower wall and acrylic nubs unchanged.
// This is the main small-adjustment knob for vertical sheet placement.
acrylic_shelf_shift_z = 4.0;
acrylic_shelf_t = 1.0;
acrylic_shelf_z0 = shelf_edge_z + acrylic_shelf_shift_z;
acrylic_shelf_top_z = acrylic_shelf_z0 + acrylic_shelf_t;
channel_back_clear = 1;
channel_outer_x_clear = 1.4;
rear_guard_wall_t = 1.8;
big_end_fit_clear = 0.25;  // light friction / snug slip fit
// =========================================================
// CONVENTIONAL FRAME
// x: right is +  y: away from viewer is +  z: up is +
// =========================================================

module triangular_prism_y(points_xz,y0,y1){polyhedron(points=[[points_xz[0][0],y0,points_xz[0][1]],[points_xz[1][0],y0,points_xz[1][1]],[points_xz[2][0],y0,points_xz[2][1]],[points_xz[0][0],y1,points_xz[0][1]],[points_xz[1][0],y1,points_xz[1][1]],[points_xz[2][0],y1,points_xz[2][1]]],faces=[[0,1,2],[5,4,3],[0,3,4,1],[1,4,5,2],[2,5,3,0]]);}
module triangular_prism_x(points_yz,x0,x1){polyhedron(points=[[x0,points_yz[0][0],points_yz[0][1]],[x0,points_yz[1][0],points_yz[1][1]],[x0,points_yz[2][0],points_yz[2][1]],[x1,points_yz[0][0],points_yz[0][1]],[x1,points_yz[1][0],points_yz[1][1]],[x1,points_yz[2][0],points_yz[2][1]]],faces=[[0,1,2],[5,4,3],[0,3,4,1],[1,4,5,2],[2,5,3,0]]);}

module bottom_panel(){difference(){translate([0,true_full_y0,0])cube([bottom_w,true_full_y_len,bottom_t]);translate([side_panel_t,true_full_y0,bottom_t_thin])cube([bottom_w-2*side_panel_t,bottom_d-true_full_y0+eps,(bottom_t-bottom_t_thin)+eps]);}}

module clock_movement_retainers(){
    tab_x0 = cutout_x + cutout_w - clock_tab_w - 8;
    tab_y0 = clock_stop_y0;
    tab_y1 = clock_stop_y0 + clock_top_stop_y_outer;
    tab_z0 = clock_top_tab_z0;
    brace_y = 3.0;
    brace_z = clock_tab_h;
    brace_y0 = tab_y1 - brace_y;
    brace_x0 = 0;
    brace_x1 = wall_w;
    center_x = wall_w/2;
    midbar_raise = 20.0;
    midbar_z0 = tab_z0 + midbar_raise;
    diag_wall_z = midbar_z0 + 60;
    post_w = 1.2;
    post_x_frac = 0.30;
    left_post_x  = wall_w * post_x_frac;
    right_post_x = wall_w * (1 - post_x_frac);
    left_post_z1  = midbar_z0 + (diag_wall_z - midbar_z0) * (1 - left_post_x / center_x);
    right_post_z1 = midbar_z0 + (diag_wall_z - midbar_z0) * ((right_post_x - center_x) / center_x);
    // DRY-ONLY: actual clock movement top retaining tab.
    // The crossbar/tie hulls below are removable print-support scaffolding.
    if(dry)
        translate([tab_x0, tab_y0, tab_z0])
            cube([clock_tab_w, clock_top_stop_y_outer - 7.0, clock_tab_h]);

    module tie_diagonal_landing(
        xc,
        landing_w_x,
        landing_y0,
        landing_z0,
        landing_d_y,
        landing_h_z
    ){
        translate([
            xc - landing_w_x/2,
            landing_y0,
            landing_z0
        ])
            cube([
                landing_w_x,
                landing_d_y,
                landing_h_z
            ]);
    }

    module tie_breakaway_neck(
        xc,
        neck_w_x,
        neck_y0,
        neck_z0,
        neck_d_y,
        neck_h_z
    ){
        translate([
            xc - neck_w_x/2,
            neck_y0,
            neck_z0
        ])
            cube([
                neck_w_x,
                neck_d_y,
                neck_h_z
            ]);
    }

    if(print_supports) {
        // PRINT SUPPORTS: removable horizontal post/scaffolding, despite legacy clock-related naming.
    translate([brace_x0, brace_y0, midbar_z0])
        cube([brace_x1 - brace_x0, brace_y, brace_z]);
    lower_drop = 45.0;
    tie_t = 2;
    tie_anchor_pad_z = 3;
    tie_lip_pad_z    = 2.4;
    left_tie_x   = view_x0 / .68;
    right_tie_x  = wall_w - view_x0 / .68;
    left_askew_x  = 40.0;
    right_askew_x = wall_w - 40.0;
    tie_anchor_y0 = brace_y0;
    tie_anchor_y1 = brace_y0 + brace_y;
    tie_anchor_z  = midbar_z0 + 2;
    tie_lip_y0 = front_buildout_y0 - eps;
    tie_lip_y1 = front_channel_y + front_frame_t + eps;
    tie_lip_z  = view_z0 - tie_lip_pad_z/2 + eps;
    center_tie_x = wall_w / 2;

    // Five right-angle breakaway contacts at the finished viewing-window lip.
    // The diagonal bodies stop above the lip; narrow vertical necks make the
    // removal cut perpendicular and keep the finished-edge scar very small.
    tie_breakaway_clear_z = 3.0;
    tie_breakaway_w_x = 1.2;
    tie_breakaway_d_y = 0.6;
    tie_breakaway_embed_z = 0.25;
    tie_breakaway_y0 =
        front_buildout_y0 + front_frame_t - tie_breakaway_d_y;
    tie_diagonal_end_z0 = view_z0 + tie_breakaway_clear_z;
    tie_breakaway_z0 = view_z0 - tie_breakaway_embed_z;
    tie_breakaway_h_z =
        tie_breakaway_embed_z
        + tie_breakaway_clear_z
        + tie_lip_pad_z;

    hull() {
        translate([left_tie_x - tie_t/2, tie_anchor_y0, tie_anchor_z - tie_anchor_pad_z/2])
            cube([tie_t, tie_anchor_y1 - tie_anchor_y0, tie_anchor_pad_z]);
        tie_diagonal_landing(
            left_tie_x, tie_t, tie_breakaway_y0,
            tie_diagonal_end_z0, tie_breakaway_d_y, tie_lip_pad_z
        );
    }
    tie_breakaway_neck(
        left_tie_x, tie_breakaway_w_x, tie_breakaway_y0,
        tie_breakaway_z0, tie_breakaway_d_y, tie_breakaway_h_z
    );

    center_fork_dx = 24.0;
    center_fork_frac = 0.5; // 0 = bottom contact, 1 = top anchor

    center_fork_y0 = tie_lip_y0 + (tie_anchor_y0 - tie_lip_y0) * center_fork_frac;
    center_fork_y1 = tie_lip_y1 + (tie_anchor_y1 - tie_lip_y1) * center_fork_frac;
    center_fork_z  = tie_lip_z  + (tie_anchor_z  - tie_lip_z)  * center_fork_frac;

    // original center brace
    hull() {
        translate([center_tie_x - tie_t/2, tie_anchor_y0, tie_anchor_z - tie_anchor_pad_z/2])
            cube([tie_t, tie_anchor_y1 - tie_anchor_y0, tie_anchor_pad_z]);
        tie_diagonal_landing(
            center_tie_x, tie_t, tie_breakaway_y0,
            tie_diagonal_end_z0, tie_breakaway_d_y, tie_lip_pad_z
        );
    }
    tie_breakaway_neck(
        center_tie_x, tie_breakaway_w_x, tie_breakaway_y0,
        tie_breakaway_z0, tie_breakaway_d_y, tie_breakaway_h_z
    );

    // left short branch from lower part of existing hull
    hull() {
        translate([center_tie_x - tie_t/2, center_fork_y0, center_fork_z - tie_lip_pad_z/2])
            cube([tie_t, center_fork_y1 - center_fork_y0, tie_lip_pad_z]);
        tie_diagonal_landing(
            center_tie_x - center_fork_dx, tie_t, tie_breakaway_y0,
            tie_diagonal_end_z0, tie_breakaway_d_y, tie_lip_pad_z
        );
    }
    tie_breakaway_neck(
        center_tie_x - center_fork_dx, tie_breakaway_w_x, tie_breakaway_y0,
        tie_breakaway_z0, tie_breakaway_d_y, tie_breakaway_h_z
    );

    // right short branch from lower part of existing hull
    hull() {
        translate([center_tie_x - tie_t/2, center_fork_y0, center_fork_z - tie_lip_pad_z/2])
            cube([tie_t, center_fork_y1 - center_fork_y0, tie_lip_pad_z]);
        tie_diagonal_landing(
            center_tie_x + center_fork_dx, tie_t, tie_breakaway_y0,
            tie_diagonal_end_z0, tie_breakaway_d_y, tie_lip_pad_z
        );
    }
    tie_breakaway_neck(
        center_tie_x + center_fork_dx, tie_breakaway_w_x, tie_breakaway_y0,
        tie_breakaway_z0, tie_breakaway_d_y, tie_breakaway_h_z
    );

    hull() {
        translate([right_tie_x - tie_t/2, tie_anchor_y0, tie_anchor_z - tie_anchor_pad_z/2])
            cube([tie_t, tie_anchor_y1 - tie_anchor_y0, tie_anchor_pad_z]);
        tie_diagonal_landing(
            right_tie_x, tie_t, tie_breakaway_y0,
            tie_diagonal_end_z0, tie_breakaway_d_y, tie_lip_pad_z
        );
    }
    tie_breakaway_neck(
        right_tie_x, tie_breakaway_w_x, tie_breakaway_y0,
        tie_breakaway_z0, tie_breakaway_d_y, tie_breakaway_h_z
    );
    }
}

// =========================================================
// KEYED END-SHOE RECEIVER V6 — V4 FIT + V5 X REACH
// =========================================================
//
// Matching roller concept:
//   [keyed shoe] [shortened semicircle glide] [keyed shoe]
//
// Settled receiver: V4 fit geometry with V5 reduced X reach; +Y entry clipped so it stays inside the cassette:
//   - no C-socket
//   - no arch
//   - no roll-down lip
//   - no spring/wiper
//   - no intentional preload by default
//   - no narrow internal ledges in the insertion path
//
// Test purpose:
//   First prove that the keyed shoe can slide straight +Y -> -Y into a
//   clean, clearanced tray and pull back out without drama. Add anti-rattle
//   preload only after this loose version seats cleanly.
//
// Print/orientation note:
//   The cassette prints upside down. Features that are final-part "ceiling"
//   features print like floor features, but this version keeps the loose ceiling pads restored. Support the slot-defining
//   roof edges for test prints.
// =========================================================

roller_receiver_lip_x = 7.0;        // V4 fit geometry with V5 reduced X reach; still covers the 8mm shoe with small margin

// Old roller datums retained for placement.
roller_receiver_cy = nipple_cy;
roller_receiver_cz = tube_cz;       // seated bottom Z of the keyed end shoe
roller_receiver_r  = tube_r;        // retained for old references/comments only

// Must match the keyed roller end-shoe concept.
roller_end_shoe_x_len = 8.0;
roller_end_shoe_y0 = -tube_r * 0.78;
roller_end_shoe_y1 =  tube_r * 0.78;
roller_end_shoe_z_low = 1.2;
roller_end_shoe_z = 5.0;
roller_end_shoe_ramp_y = 4.5;

// Loose proof-of-concept fit knobs.
// Start loose. Tighten only after insertion/removal works cleanly.
roller_receiver_clear_y = 1.20;
roller_receiver_clear_z_top = 1.50;

roller_receiver_shelf_t_z = 1.4;
roller_receiver_backstop_t_y = 1.8;
roller_receiver_backstop_extra_z = 1.2;
roller_receiver_entry_extra_y = 2.0;   // shortened: previous 6.0 pushed +Y past the cassette/backer plane

// Low side/datum cheek: sits on the bottom shelf and cannot become a hook.
// Set to 0 for an even more open tray.
roller_receiver_side_cheek_h_z = 1.0;

// Loose final-part ceiling/roof pad. This is NOT preload yet; it only
// restores a top boundary so the keyed shoe is inside a clearanced channel.
// Keep the Z clearance generous for this test. Tighten only after it slides.
roller_receiver_use_ceiling_pad_left  = true;
roller_receiver_use_ceiling_pad_right = true;
roller_receiver_ceiling_pad_t_z = 1.2;
roller_receiver_ceiling_pad_y_extra = 0.6;

// Hard +Y guard so receiver geometry cannot poke past the cassette/backer plane.
roller_receiver_y1_limit = bottom_d - 0.35;

module roller_receiver_cube(x0, x1, y0, y1, z0, z1){
    translate([x0, y0, z0])
        cube([x1 - x0, y1 - y0, z1 - z0]);
}

module roller_receiver_open_endshoe_tray(x0, x1, use_ceiling_pad=false){
    shoe_y0 = roller_receiver_cy + roller_end_shoe_y0;
    shoe_y1 = roller_receiver_cy + roller_end_shoe_y1;
    shoe_plateau_y0 = roller_receiver_cy + roller_end_shoe_y0 + roller_end_shoe_ramp_y;

    shelf_z0 = roller_receiver_cz - roller_receiver_shelf_t_z;
    shelf_z1 = roller_receiver_cz;

    backstop_y0 = shoe_y0 - roller_receiver_clear_y - roller_receiver_backstop_t_y;
    backstop_y1 = shoe_y0 - roller_receiver_clear_y;

    // Short open entry shelf beyond +Y end of shoe, clipped inside cassette depth.
    shelf_y0 = backstop_y0;
    shelf_y1 = min(
        shoe_y1 + roller_receiver_clear_y + roller_receiver_entry_extra_y,
        roller_receiver_y1_limit
    );

    backstop_z0 = shelf_z1;
    backstop_z1 = roller_receiver_cz + roller_end_shoe_z + roller_receiver_backstop_extra_z;

    cheek_y0 = shoe_y0 - roller_receiver_clear_y;
    cheek_y1 = shoe_y1 + roller_receiver_clear_y;
    cheek_z0 = shelf_z1;
    cheek_z1 = shelf_z1 + roller_receiver_side_cheek_h_z;

    ceiling_y0 = shoe_plateau_y0 + 1.0;
    ceiling_y1 = min(
        shoe_y1 + roller_receiver_clear_y + roller_receiver_ceiling_pad_y_extra,
        roller_receiver_y1_limit
    );
    ceiling_z0 = roller_receiver_cz + roller_end_shoe_z + roller_receiver_clear_z_top;
    ceiling_z1 = ceiling_z0 + roller_receiver_ceiling_pad_t_z;

    union(){
        // Broad flat bottom tray. This is the real support surface.
        roller_receiver_cube(
            x0, x1,
            shelf_y0, shelf_y1,
            shelf_z0, shelf_z1
        );

        // -Y hard stop. The shoe should approach this from +Y and seat against it.
        roller_receiver_cube(
            x0, x1,
            backstop_y0, backstop_y1,
            backstop_z0, backstop_z1
        );

        // Low cheek only: anti-twist / side datum, not a capture lip.
        if (roller_receiver_side_cheek_h_z > 0)
            roller_receiver_cube(
                x0, x1,
                cheek_y0, cheek_y1,
                cheek_z0, cheek_z1
            );

        // Loose roof pad / top boundary. This is deliberately clearanced,
        // not a preload rib and not a hook.
        if (use_ceiling_pad)
            roller_receiver_cube(
                x0, x1,
                ceiling_y0, ceiling_y1,
                ceiling_z0, ceiling_z1
            );
    }
}

module roller_receiver_left(){
    roller_receiver_open_endshoe_tray(
        side_panel_t,
        side_panel_t + roller_receiver_lip_x,
        roller_receiver_use_ceiling_pad_left
    );
}

module roller_receiver_right(){
    roller_receiver_open_endshoe_tray(
        wall_w - side_panel_t - roller_receiver_lip_x,
        wall_w - side_panel_t,
        roller_receiver_use_ceiling_pad_right
    );
}

luer_side_y_shift = 6.0;
luer_side_hole_d = 15.2;
luer_side_slant_deg = 45;
luer_side_yc = (true_full_y0 + true_full_y1) / 2 + luer_side_y_shift;
luer_side_zc = cassette_full_z0 + cassette_full_h * 0.50;
luer_side_cut_len = side_panel_t + side_lip_overlap_x + 40;

module left_slanted_luer_void(){
    translate([side_panel_t / 2, luer_side_yc, luer_side_zc])
        rotate([0, 90 + luer_side_slant_deg, 0])
            cylinder(d = luer_side_hole_d, h = luer_side_cut_len, center = true);
}

module left_side_panel(){
    difference(){
        union(){
            translate([0,true_full_y0,cassette_full_z0])
                cube([side_panel_t,true_full_y_len,cassette_full_h]);
            translate([side_panel_t,side_lip_y0,side_lip_z0])
                cube([side_lip_overlap_x,side_lip_y_len,side_lip_h]);
            roller_receiver_left();
        }
        // LEGACY WET-ONLY: clearance for the former removable-bucket spout.
        if(wet && wet_use_legacy_bucket)
            bucket_overflow_tube_slot();
    }
}

clock_bar_trap_depth_x = 0.4;
clock_bar_trap_depth_x2 = 0.8;
clock_bar_trap_y_len   = 8.0;
clock_bar_trap_extra_neg_y = 4.0;
clock_bar_trap_h_z     = 24.0;
clock_bar_trap_y1 = 20.0;
clock_bar_trap_y0 = clock_bar_trap_y1 - clock_bar_trap_y_len - clock_bar_trap_extra_neg_y;
clock_bar_trap_z_shift = 1.0;

clock_bar_trap_z0 =
    clock_body_z0
    + clock_body_side/2
    - clock_bar_trap_h_z/2
    + clock_bar_trap_z_shift;

module right_side_panel(){
    difference(){
        union(){
            translate([wall_w-side_panel_t,true_full_y0,cassette_full_z0])
                cube([side_panel_t,true_full_y_len,cassette_full_h]);
            translate([wall_w-side_panel_t-side_lip_overlap_x,side_lip_y0,side_lip_z0])
                cube([side_lip_overlap_x,side_lip_y_len,side_lip_h]);
roller_receiver_right();
        }
        // DRY-ONLY: clock/seatbelt trap cut through the right side wall.
        if(dry)
            translate([wall_w - side_panel_t - eps, clock_bar_trap_y0, clock_bar_trap_z0])
                cube([clock_bar_trap_depth_x + eps, clock_bar_trap_y1 - clock_bar_trap_y0, clock_bar_trap_h_z]);

    }
}



module side_backing_clips(){
    // Upper backboard retention is a literal Z-translated clone of the lower hooks.
    translate([0, 0, upper_board_hook_z0 - lower_board_hook_z0])
        lower_board_hooks();
}

lower_board_hook_z0 = bottom_t + 50.0;
lower_board_hook_h  = backing_board_hook_h_z;
lower_board_hook_y0 = bottom_d;
lower_board_hook_return_t_y = side_panel_t;
lower_board_hook_y1 =
    lower_board_hook_y0
    + backing_board_side_pocket_y
    + lower_board_hook_return_t_y;
lower_board_hook_x_inset = 1.2;
lower_board_hook_capture_x_inset =
    lower_board_hook_x_inset + backing_board_side_pad_x;
lower_board_hook_roof_h = 5.0;

module left_lower_board_hook(){
    union(){
        translate([0, lower_board_hook_y0, lower_board_hook_z0])
            cube([side_panel_t, lower_board_hook_y1 - lower_board_hook_y0, lower_board_hook_h]);

        // Local X shim against the left edge of the backing board.
        translate([
            side_panel_t - eps,
            lower_board_hook_y0,
            lower_board_hook_z0
        ])
            cube([
                backing_board_side_pad_x + eps,
                backing_board_side_pocket_y,
                lower_board_hook_h
            ]);

        translate([side_panel_t - eps, lower_board_hook_y1 - lower_board_hook_return_t_y, lower_board_hook_z0])
            cube([lower_board_hook_capture_x_inset + eps, lower_board_hook_return_t_y, lower_board_hook_h]);
        difference(){
            triangular_prism_x(
                [[lower_board_hook_y0, lower_board_hook_z0 + lower_board_hook_h],
                 [lower_board_hook_y1, lower_board_hook_z0 + lower_board_hook_h],
                 [lower_board_hook_y0, lower_board_hook_z0 + lower_board_hook_h + lower_board_hook_roof_h]],
                0, side_panel_t + lower_board_hook_capture_x_inset);
            translate([side_panel_t, lower_board_hook_y0 - eps, lower_board_hook_z0 + lower_board_hook_h - eps])
                cube([lower_board_hook_capture_x_inset + eps, lower_board_hook_y1 - lower_board_hook_y0 + 2*eps, lower_board_hook_roof_h + 2*eps]);
        }
    }
}

module right_lower_board_hook(){
    union(){
        translate([wall_w - side_panel_t, lower_board_hook_y0, lower_board_hook_z0])
            cube([side_panel_t, lower_board_hook_y1 - lower_board_hook_y0, lower_board_hook_h]);

        // Matching X shim against the right edge of the backing board.
        translate([
            wall_w - side_panel_t - backing_board_side_pad_x,
            lower_board_hook_y0,
            lower_board_hook_z0
        ])
            cube([
                backing_board_side_pad_x + eps,
                backing_board_side_pocket_y,
                lower_board_hook_h
            ]);

        translate([wall_w - side_panel_t - lower_board_hook_capture_x_inset, lower_board_hook_y1 - lower_board_hook_return_t_y, lower_board_hook_z0])
            cube([lower_board_hook_capture_x_inset + eps, lower_board_hook_return_t_y, lower_board_hook_h]);
        difference(){
            triangular_prism_x(
                [[lower_board_hook_y0, lower_board_hook_z0 + lower_board_hook_h],
                 [lower_board_hook_y1, lower_board_hook_z0 + lower_board_hook_h],
                 [lower_board_hook_y0, lower_board_hook_z0 + lower_board_hook_h + lower_board_hook_roof_h]],
                wall_w - side_panel_t - lower_board_hook_capture_x_inset, wall_w);
            translate([wall_w - side_panel_t - lower_board_hook_capture_x_inset - eps, lower_board_hook_y0 - eps, lower_board_hook_z0 + lower_board_hook_h - eps])
                cube([lower_board_hook_capture_x_inset + eps, lower_board_hook_y1 - lower_board_hook_y0 + 2*eps, lower_board_hook_roof_h + 2*eps]);
        }
    }
}

module lower_board_hooks(){left_lower_board_hook();right_lower_board_hook();}
module top_cross_member(){
    translate([0,true_full_y0,top_cross_z0])
        cube([wall_w,true_full_y_len,top_cross_z_len]);
    translate([0,true_full_y0,top_cross_z0-top_cross_reinforcement_t])
        cube([wall_w,true_full_y_len,top_cross_reinforcement_t]);
}
// Backing-board top bridges with downward returns on both sides of the board.
// Together with the inward fangs, these form two loose upward-facing pockets.

back_socket_y_extension = back_board_slot_t + retainer_pad_d;

module top_board_snap_clip(x0){
    bridge_x0 = x0 - socket_side_wall - socket_wall_ear_x;
    bridge_w = tenon_w + 2*socket_side_wall + 2*socket_wall_ear_x;
    snap_x0 = bridge_x0 + (bridge_w - top_board_snap_w_x)/2;
    bridge_underside_z = shell_inner_top_z - back_socket_bridge_z;
    snap_return_y0 = bottom_d + backing_board_side_pocket_y;

    translate([
        snap_x0,
        snap_return_y0,
        bridge_underside_z - top_board_snap_lip_overlap_z
    ])
        cube([
            top_board_snap_w_x,
            top_board_snap_return_t_y,
            top_board_snap_lip_overlap_z + eps
        ]);
}

module top_board_inward_fang(x0){
    bridge_x0 = x0 - socket_side_wall - socket_wall_ear_x;
    bridge_w = tenon_w + 2*socket_side_wall + 2*socket_wall_ear_x;
    fang_x0 = bridge_x0 + (bridge_w - top_board_inward_fang_w_x)/2;
    bridge_underside_z = shell_inner_top_z - back_socket_bridge_z;

    translate([
        fang_x0,
        bottom_d - top_board_inward_fang_d_y,
        bridge_underside_z - top_board_inward_fang_h_z
    ])
        cube([
            top_board_inward_fang_w_x,
            top_board_inward_fang_d_y,
            top_board_inward_fang_h_z + eps
        ]);
}

module back_socket_bridge(x0){
    translate([
        x0 - socket_side_wall - socket_wall_ear_x,
        bottom_d,
        shell_inner_top_z - back_socket_bridge_z
    ])
        cube([
            tenon_w + 2*socket_side_wall + 2*socket_wall_ear_x,
            back_socket_y_extension,
            back_socket_bridge_h
        ]);
}

module left_back_socket_assembly(){
    back_socket_bridge(left_back_socket_x);
    top_board_snap_clip(left_back_socket_x);
    top_board_inward_fang(left_back_socket_x);
}

module right_back_socket_assembly(){
    back_socket_bridge(right_back_socket_x);
    top_board_snap_clip(right_back_socket_x);
    top_board_inward_fang(right_back_socket_x);
}

module sloped_wall_prism_x(points_yz, x0, x1){
    polyhedron(
        points=[[x0,points_yz[0][0],points_yz[0][1]],[x0,points_yz[1][0],points_yz[1][1]],[x0,points_yz[2][0],points_yz[2][1]],[x0,points_yz[3][0],points_yz[3][1]],[x1,points_yz[0][0],points_yz[0][1]],[x1,points_yz[1][0],points_yz[1][1]],[x1,points_yz[2][0],points_yz[2][1]],[x1,points_yz[3][0],points_yz[3][1]]],
        faces=[[0,1,2,3],[7,6,5,4],[0,4,5,1],[1,5,6,2],[2,6,7,3],[3,7,4,0]]);
}

channel_bottom_kill_z = 3 * inch;
bottom_front_shelf_y_span = 3.0;
bottom_front_shelf_y0 = front_buildout_y0 + front_frame_t;
bottom_front_shelf_y1     = bottom_front_shelf_y0 + bottom_front_shelf_y_span;

// Loose center registration pocket for the acrylic + two-image stack.
// It stops excess +Y travel without clamping the stack. The cassette prints
// upside down, so three thin posts borrow from the existing removable scaffold
// to support it during printing. The finished mouth stays completely open.
center_stack_pocket_w_x = rear_guard_center_strip_w;
center_stack_pocket_x0 = rear_guard_center_x - center_stack_pocket_w_x/2;
center_stack_pocket_x1 = rear_guard_center_x + center_stack_pocket_w_x/2;
center_stack_pocket_inner_y0 = bottom_front_shelf_y0;
center_stack_pocket_inner_y1 = bottom_front_shelf_y1;
center_stack_pocket_rear_wall_t_y = 1.2;
center_stack_pocket_rear_outer_y1 =
    center_stack_pocket_inner_y1 + center_stack_pocket_rear_wall_t_y;
center_stack_pocket_front_anchor_overlap_y = 0.4;
center_stack_pocket_mouth_z1 = view_z0;
center_stack_pocket_chamfer_h_z = 1.2;
center_stack_pocket_chamfer_y = 0.6;
center_stack_pocket_mouth_inner_y1 =
    center_stack_pocket_inner_y1 + center_stack_pocket_chamfer_y;
center_stack_pocket_support_post_count = 3;
center_stack_pocket_support_branch_w_x = 1.2;
center_stack_pocket_support_branch_d_y = 1.2;
center_stack_pocket_support_contact_w_x = 1.2;
center_stack_pocket_support_contact_d_y = 0.6;
center_stack_pocket_support_post_x_margin = 2.0;
// All three branches stay in this single Y plane: the center of the narrow
// chamfered rear rim marked in the user's red-line / green-contact review.
center_stack_pocket_support_post_y =
    (center_stack_pocket_mouth_inner_y1
     + center_stack_pocket_rear_outer_y1) / 2;
center_stack_pocket_support_contact_overlap_z = 0.30;
center_stack_pocket_support_contact_z0 =
    center_stack_pocket_mouth_z1
    - center_stack_pocket_support_contact_overlap_z;
center_stack_pocket_support_landing_z0 =
    center_stack_pocket_mouth_z1 + 0.60;
center_stack_pocket_support_landing_h_z = 0.80;

// Centerline of the existing center diagonal scaffold. The trident root is
// placed where that diagonal passes directly over the pocket contact row.
center_stack_pocket_support_diag_lower_y =
    center_stack_pocket_inner_y0 - 0.30;
center_stack_pocket_support_diag_lower_z =
    center_stack_pocket_mouth_z1 + 3.0 + 1.2;
center_stack_pocket_support_diag_upper_y = backer_plane_y - 1.5;
center_stack_pocket_support_diag_upper_z = clock_top_tab_z0 + 22.0;
center_stack_pocket_support_root_y = center_stack_pocket_support_post_y;
center_stack_pocket_support_root_frac =
    (center_stack_pocket_support_root_y
     - center_stack_pocket_support_diag_lower_y)
    / (center_stack_pocket_support_diag_upper_y
       - center_stack_pocket_support_diag_lower_y);
center_stack_pocket_support_root_z =
    center_stack_pocket_support_diag_lower_z
    + center_stack_pocket_support_root_frac
      * (center_stack_pocket_support_diag_upper_z
         - center_stack_pocket_support_diag_lower_z);
center_stack_pocket_support_root_w_x = 1.8;
center_stack_pocket_support_root_d_y = 0.8;
center_stack_pocket_support_root_h_z = 1.2;

assert(center_stack_pocket_inner_y1 - center_stack_pocket_inner_y0 >= 3.0,
       "center acrylic/image pocket must remain a loose 3 mm channel");
assert(center_stack_pocket_mouth_inner_y1
       < center_stack_pocket_rear_outer_y1,
       "center pocket chamfer consumes the rear stop wall");
assert(center_stack_pocket_support_root_frac > 0
       && center_stack_pocket_support_root_frac < 1,
       "pocket-support trident root misses the center scaffold diagonal");
assert(center_stack_pocket_support_post_y
           - center_stack_pocket_support_contact_d_y/2
       >= center_stack_pocket_mouth_inner_y1 - eps
       && center_stack_pocket_support_post_y
              + center_stack_pocket_support_contact_d_y/2
          <= center_stack_pocket_rear_outer_y1 + eps,
       "pocket-support contacts miss the narrow rear rim");
// The raised shelf remains the terminal lower end of this channel wall.
// Keep the upper endpoint fixed so shelf adjustment only makes a small Y-Z
// slope change instead of translating the full channel geometry.
rear_wall_slope_z0 = acrylic_shelf_z0;
rear_wall_slope_z1 = rear_guard_z0 - photo_hang_drop + channel_bottom_kill_z;

module rear_wall_column_with_lower_slope(x0, x1){
    x0_lower_fixed = x0;

    // lower sloped waterproofing wall may extend to side wall
    sloped_wall_prism_x(
        [[bottom_front_shelf_y1, rear_wall_slope_z0],
         [bottom_front_shelf_y1 + rear_guard_wall_t, rear_wall_slope_z0],
         [wall_offset + rear_guard_wall_t, rear_wall_slope_z1],
         [wall_offset, rear_wall_slope_z1]],
        x0_lower_fixed, x1);

    // upper vertical wall stays original width
    translate([x0, wall_offset, rear_wall_slope_z1])
        cube([x1 - x0, rear_guard_wall_t, rear_guard_z1 - rear_wall_slope_z1]);
}


module rear_buildout_perimeter(){
    rear_guard_top_border_z = 38;
    inner_x0 = rear_guard_x0 + rear_guard_border_x;
    inner_x1 = rear_guard_x1 - rear_guard_border_x;
    inner_z1 = rear_guard_z1 - rear_guard_top_border_z;
    center_x = (rear_guard_x0 + rear_guard_x1) / 2;
    left_col_x0   = rear_guard_x0;
    left_col_x1   = inner_x0;
    center_col_x0 = center_x - rear_guard_center_strip_w / 2;
    center_col_x1 = center_x + rear_guard_center_strip_w / 2;
    right_col_x0  = inner_x1;
    right_col_x1  = rear_guard_x1;
    union(){
        rear_wall_column_with_lower_slope(left_col_x0, left_col_x1);
        short_center_strip_h = 2.5 * inch;
        translate([center_col_x0, wall_offset, rear_guard_z1 - short_center_strip_h])
            cube([center_col_x1 - center_col_x0, rear_guard_wall_t, short_center_strip_h]);
        rear_wall_column_with_lower_slope(right_col_x0, right_col_x1);
        // top horizontal perimeter bar, thickened +2mm / -2mm
 top_bar_extra_z_bottom = 4.0;
top_bar_extra_z_top    = 4.0;

translate([rear_guard_x0, wall_offset, inner_z1 - top_bar_extra_z_bottom])
    cube([
        rear_guard_x1 - rear_guard_x0,
        rear_guard_wall_t,
        (rear_guard_z1 - inner_z1)
            + top_bar_extra_z_bottom
            + top_bar_extra_z_top
    ]);
    }
}

module bottom_front_shelves(){
    translate([rear_guard_x0, bottom_front_shelf_y0, acrylic_shelf_z0])
        cube([rear_guard_border_x, bottom_front_shelf_y1 - bottom_front_shelf_y0, acrylic_shelf_t]);
    // The former center shelf segment was a legacy nub directly below the
    // middle scaffold contact. It served no retention function and confused
    // removal, so only the useful left and right shelf segments remain.
    translate([rear_guard_x1 - rear_guard_border_x, bottom_front_shelf_y0, acrylic_shelf_z0])
        cube([rear_guard_border_x, bottom_front_shelf_y1 - bottom_front_shelf_y0, acrylic_shelf_t]);
}

// NEUTRAL: shared acrylic/image +Y registration stop.
// The existing lower front mask is the -Y side of this U-shaped pocket. The
// new floor and chamfered rear wall form its base and +Y stop. At the center,
// the removable membrane overlaps the scaffold contact during inverted
// printing; the permanent pocket remains attached to the front mask after
// both temporary features are cut away.
module center_stack_registration_pocket(){
    floor_y0 =
        center_stack_pocket_inner_y0
        - center_stack_pocket_front_anchor_overlap_y;
    rear_chamfer_z0 =
        center_stack_pocket_mouth_z1
        - center_stack_pocket_chamfer_h_z;
    // Horizontal seat, level with the two existing side shelves.
    translate([
        center_stack_pocket_x0,
        floor_y0,
        acrylic_shelf_z0
    ])
        cube([
            center_stack_pocket_x1 - center_stack_pocket_x0,
            center_stack_pocket_rear_outer_y1 - floor_y0,
            acrylic_shelf_t
        ]);

    // Straight lower part of the +Y stop wall.
    translate([
        center_stack_pocket_x0,
        center_stack_pocket_inner_y1,
        acrylic_shelf_top_z - eps
    ])
        cube([
            center_stack_pocket_x1 - center_stack_pocket_x0,
            center_stack_pocket_rear_wall_t_y,
            rear_chamfer_z0 - acrylic_shelf_top_z + 2*eps
        ]);

    // Simple outward flare so acrylic and paper edges enter without snagging.
    sloped_wall_prism_x(
        [[center_stack_pocket_inner_y1, rear_chamfer_z0 - eps],
         [center_stack_pocket_rear_outer_y1, rear_chamfer_z0 - eps],
         [center_stack_pocket_rear_outer_y1,
          center_stack_pocket_mouth_z1],
         [center_stack_pocket_mouth_inner_y1,
          center_stack_pocket_mouth_z1]],
        center_stack_pocket_x0,
        center_stack_pocket_x1
    );

}

// PRINT-SUPPORTS ONLY: a three-branch trident rooted directly in the underside
// of the existing center diagonal scaffold. The branches fan to the three
// narrow rear-rim contacts that are first to print; nothing new touches the
// visible viewing-window lip or the already-supported broad pocket floor.
module center_stack_pocket_sacrificial_posts(){
    post_x_span = center_stack_pocket_w_x
        - 2*center_stack_pocket_support_post_x_margin;

    for(i = [0 : center_stack_pocket_support_post_count - 1]){
        post_x = center_stack_pocket_x0
            + center_stack_pocket_support_post_x_margin
            + i * post_x_span
              / (center_stack_pocket_support_post_count - 1);

        // Each branch is a two-line-width body. The side branches remain
        // steeper than 45 degrees and the middle branch is nearly vertical.
        hull(){
            translate([
                rear_guard_center_x
                    - center_stack_pocket_support_root_w_x/2,
                center_stack_pocket_support_root_y
                    - center_stack_pocket_support_root_d_y/2,
                center_stack_pocket_support_root_z
                    - center_stack_pocket_support_root_h_z/2
            ])
                cube([
                    center_stack_pocket_support_root_w_x,
                    center_stack_pocket_support_root_d_y,
                    center_stack_pocket_support_root_h_z
                ]);
            translate([
                post_x - center_stack_pocket_support_branch_w_x/2,
                center_stack_pocket_support_post_y
                    - center_stack_pocket_support_branch_d_y/2,
                center_stack_pocket_support_landing_z0
            ])
                cube([
                    center_stack_pocket_support_branch_w_x,
                    center_stack_pocket_support_branch_d_y,
                    center_stack_pocket_support_landing_h_z
                ]);
        }

        // One shallow layer-scale foot on the narrow rim is the only removable
        // contact. This supports the first pocket layer instead of arriving
        // later on the already-printed floor.
        translate([
            post_x - center_stack_pocket_support_contact_w_x/2,
            center_stack_pocket_support_post_y
                - center_stack_pocket_support_contact_d_y/2,
            center_stack_pocket_support_contact_z0
        ])
            cube([
                center_stack_pocket_support_contact_w_x,
                center_stack_pocket_support_contact_d_y,
                center_stack_pocket_support_landing_z0
                    + eps
                    - center_stack_pocket_support_contact_z0
            ]);
    }
}

// DRY-ONLY: small floor stick tied to the clock mechanism pocket.
// Kept out of neutral/wet-only renders.
module clock_box_floor_stick(){
    stick_w = 3.0;
    stick_xc = cutout_x + clock_body_side/2;
    stick_yc = bottom_front_shelf_y0 + (bottom_front_shelf_y1 - bottom_front_shelf_y0)/2;
    stick_z0 = bottom_t-2.4;
    stick_z1 = clock_body_z0 + clock_backstop_inset_each_side;
    translate([stick_xc - stick_w/2, stick_yc - stick_w/2, stick_z0])
        cube([stick_w, stick_w, stick_z1 - stick_z0]);
}

module acrylic_top_feed_cut(){
    // Extend through the independent roof skin without moving the slot.
    reinforcement_cut_z0 = acrylic_top_feed_z0-top_cross_reinforcement_t;
    translate([acrylic_top_feed_x0,acrylic_slot_y0,reinforcement_cut_z0])
        cube([
            acrylic_top_feed_x1-acrylic_top_feed_x0,
            acrylic_slot_y1-acrylic_slot_y0,
            acrylic_top_feed_z1-reinforcement_cut_z0
        ]);
}

module right_outer_clock_tab_tip_support(){
    tab_x0 = cutout_x + cutout_w - clock_tab_w - 8;
    tip_support_y_band = 1.8;
    tip_support_y_reduce = 7.0;
    tip_support_rise_z = 8.0;
    triangular_prism_y(
        [[wall_w - side_panel_t, clock_top_tab_z0 + clock_tab_h],
         [wall_w - side_panel_t, clock_top_tab_z0 + clock_tab_h + tip_support_rise_z],
         [tab_x0, clock_top_tab_z0 + clock_tab_h]],
        clock_stop_y0 + clock_top_stop_y_outer - tip_support_y_band - tip_support_y_reduce,
        clock_stop_y0 + clock_top_stop_y_outer - tip_support_y_reduce);
}

module right_outer_clock_tab_front_tip_support(){
    tab_x0 = cutout_x + cutout_w - clock_tab_w - 8;
    tip_support_y_band = 1.8;
    tip_support_rise_z = 8.0;
    front_wall_clearance = 1.0;
    front_support_y0 = wall_offset + wall_t + front_wall_clearance;
    front_support_y1 = front_support_y0 + tip_support_y_band;
    triangular_prism_y(
        [[wall_w - side_panel_t, clock_top_tab_z0 + clock_tab_h],
         [wall_w - side_panel_t, clock_top_tab_z0 + clock_tab_h + tip_support_rise_z],
         [tab_x0, clock_top_tab_z0 + clock_tab_h]],
        front_support_y0, front_support_y1);
}

// DRY-ONLY despite legacy/generic-sounding name:
// triangle print supports for the dry clock retainer bar.
// They are intentionally gated as a group in dry_variant_additive_features().
module sacrificial_clock_retainer_supports(){right_outer_clock_tab_tip_support();right_outer_clock_tab_front_tip_support();}

module left_floor_corner_gusset(){
    ramp_x_t = .6;
    ramp_z0  = bottom_t - 1.2;
    ramp_z1  = bottom_t + 20.0;

    gusset_end_cliff_z = 2.0;

    y0 = front_buildout_y0 + front_frame_t;
    y1 = side_lip_y1 + 1;

    sloped_wall_prism_x(
        [[y0, ramp_z0],
         [y0, ramp_z1],
         [y1, ramp_z0 + gusset_end_cliff_z],
         [y1, ramp_z0]],
        0, ramp_x_t);
}

module front_mask_plane(){
    difference(){
        union(){
            translate([buildout_x0, front_buildout_y0, buildout_z0])
                cube([wall_w, front_frame_t, buildout_z1-buildout_z0]);
            x_mid        = wall_w/2;
            core_half    = mask_core_w/2;
            total_half   = mask_total_w/2;
            dx           = mask_total_w / mask_slices;
            reinforce_z1 = lower_front_fill_z1;
            for(i = [0 : mask_slices-1]){
                xa = x_mid - total_half + i*dx;
                xc = xa + dx/2;
                d  = abs(xc - x_mid);
                extra = (d <= core_half) ? mask_center_extra_y : (d <= total_half) ? mask_center_extra_y * pow(1 - (d - core_half)/(total_half - core_half), 2) : 0;
                if (extra > 0)
                    translate([xa, front_buildout_y0 + front_frame_t, buildout_z0])
                        cube([dx, extra, reinforce_z1 - buildout_z0]);
            }
        }
        translate([view_x0, front_buildout_y0-0.1, view_z0])
            cube([view_w, front_frame_t+0.2, view_h]);
        front_window_chamfer(2.0);
    }
}

acrylic_bottom_nub_x = 5.0;
acrylic_bottom_nub_y = 3.0;
acrylic_bottom_nub_z = 3.0;
acrylic_bottom_nub_z0 = shelf_edge_z + 3.0;

module acrylic_bottom_side_nubs(){
    translate([side_panel_t, acrylic_slot_y1, acrylic_bottom_nub_z0])
        cube([acrylic_bottom_nub_x, acrylic_bottom_nub_y, acrylic_bottom_nub_z]);
    triangular_prism_y(
        [[side_panel_t, acrylic_bottom_nub_z0 + acrylic_bottom_nub_z + acrylic_bottom_nub_x],
         [side_panel_t, acrylic_bottom_nub_z0 + acrylic_bottom_nub_z],
         [side_panel_t + acrylic_bottom_nub_x, acrylic_bottom_nub_z0 + acrylic_bottom_nub_z]],
        acrylic_slot_y1, acrylic_slot_y1 + acrylic_bottom_nub_y);
    translate([wall_w - side_panel_t - acrylic_bottom_nub_x, acrylic_slot_y1, acrylic_bottom_nub_z0])
        cube([acrylic_bottom_nub_x, acrylic_bottom_nub_y, acrylic_bottom_nub_z]);
    triangular_prism_y(
        [[wall_w - side_panel_t, acrylic_bottom_nub_z0 + acrylic_bottom_nub_z + acrylic_bottom_nub_x],
         [wall_w - side_panel_t, acrylic_bottom_nub_z0 + acrylic_bottom_nub_z],
         [wall_w - side_panel_t - acrylic_bottom_nub_x, acrylic_bottom_nub_z0 + acrylic_bottom_nub_z]],
        acrylic_slot_y1, acrylic_slot_y1 + acrylic_bottom_nub_y);
}

// Three paired side stops keep the narrower acrylic centered in the existing
// broad channel. They occupy only the space outside acrylic_channel_x0/x1 and
// are hidden behind the opaque side borders of the viewing window.
acrylic_side_stop_h_z = 5.0;
acrylic_side_stop_front_overlap_y = 0.60;
acrylic_side_stop_back_overlap_y = 0.60;
acrylic_side_stop_lower_z = view_z0 + 12.0;
acrylic_side_stop_middle_z = (view_z0 + view_z1)/2;
acrylic_side_stop_upper_z = view_z1 - 12.0;

module acrylic_lateral_stop_pair(z_center){
    stop_y0 = acrylic_slot_y0 - acrylic_side_stop_front_overlap_y;
    stop_y1 = max(acrylic_slot_y1, acrylic_inner_y1)
              + acrylic_side_stop_back_overlap_y;
    stop_z0 = z_center - acrylic_side_stop_h_z/2;

    assert(acrylic_channel_x0 > rear_guard_x0,
           "Left acrylic stop has no positive X width; reduce sheet width or clearance.");
    assert(acrylic_channel_x1 < rear_guard_x1,
           "Right acrylic stop has no positive X width; reduce sheet width or clearance.");

    translate([rear_guard_x0, stop_y0, stop_z0])
        cube([
            acrylic_channel_x0 - rear_guard_x0,
            stop_y1 - stop_y0,
            acrylic_side_stop_h_z
        ]);

    translate([acrylic_channel_x1, stop_y0, stop_z0])
        cube([
            rear_guard_x1 - acrylic_channel_x1,
            stop_y1 - stop_y0,
            acrylic_side_stop_h_z
        ]);
}

module acrylic_lateral_stops(){
    acrylic_lateral_stop_pair(acrylic_side_stop_lower_z);
    acrylic_lateral_stop_pair(acrylic_side_stop_middle_z);
    acrylic_lateral_stop_pair(acrylic_side_stop_upper_z);
}

module paper_load_top_slot_cut(){
    paper_load_slot_w_y = 1.2;

    // Slight +Y bias from roller/nub centerline.
    // Keeps a substantial web from acrylic/front slot, but not so far back
    // that loading requires sharply bending the paper forward.
    paper_load_slot_offset_y = -10.0;

    // Extra X forgiveness beyond actual paper slot, not full roller width.
    paper_load_slot_x_extra = 8.0;

    paper_load_slot_x0 = paper_slot_x0 - paper_load_slot_x_extra;
    paper_load_slot_x1 = paper_slot_x1 + paper_load_slot_x_extra;

    paper_load_slot_y0 = nipple_cy + paper_load_slot_offset_y;
    paper_load_slot_y1 = paper_load_slot_y0 + paper_load_slot_w_y;

    translate([
        paper_load_slot_x0,
        paper_load_slot_y0,
        top_cross_z0 - top_cross_reinforcement_t - eps
    ])
        cube([
            paper_load_slot_x1 - paper_load_slot_x0,
            paper_load_slot_y1 - paper_load_slot_y0,
            top_cross_z_len + top_cross_reinforcement_t + 2*eps
        ]);
}
module front_buildout_parts(){
    front_mask_plane();
    left_channel_flat_panel();
    right_channel_flat_panel();
    left_side_channel_block_top();
    right_side_channel_block_top();
    left_side_channel_block_top_support();
    right_side_channel_block_top_support();
    bottom_front_shelves();
    center_stack_registration_pocket();
    acrylic_lateral_stops();
    side_channel_terminal_side_braces();
    acrylic_bottom_side_nubs();
    
}

module front_window_chamfer(bevel=2.0){
    translate([0, front_buildout_y0 - 0.1, 0])
        rotate([-90,0,0])
            linear_extrude(height = front_frame_t + 0.2, scale = [(view_w + 2*bevel) / view_w, (view_h + 2*bevel) / view_h])
                translate([view_x0 + view_w/2, view_z0 + view_h/2])
                    translate([-view_w/2, -view_h/2])
                        square([view_w, view_h]);
}

// VARIANT-SPECIFIC CALLS, SHARED MODULE DEFINITION:
// Native placement is the dry/right clock-side thread hook.
// wet_variant_additive_features() reuses this same shape by translating
// and mirroring it to the water-tank side. Do not gate the definition itself.
module right_thread_hook(){
    translate([wall_w, bottom_d - 22.0, fang_main_z0 - 6.0])
        rotate([90,0,180])
        difference() {
            polyhedron(
                points = [[0,0,0],[0,10,0],[7,0,0],[0,0,7],[0,10,7],[7,0,7]],
                faces  = [[0,1,2],[5,4,3],[0,3,4,1],[1,4,5,2],[2,5,3,0]]);
            translate([3.5, 8, 3.5])
                rotate([90,0,0])
                    cylinder(h=14, d=3.5, $fn=32);
        }
}
spring_coil_hook_outer_d = 7.0;
spring_coil_hook_inner_d = 3.2;
spring_coil_hook_t_x     = 2.2;
spring_coil_hook_slit_w  = 1.0;

module left_spring_coil_hook(){
    hook_x = 4;
    hook_y = bottom_d - 22.0;
    hook_z = fang_main_z0 - 6.0;

    translate([hook_x, hook_y, hook_z])
        rotate([90,20,0])
            difference(){
                cylinder(d=spring_coil_hook_outer_d, h=spring_coil_hook_t_x, center=false);

                translate([0,0,-eps])
                    cylinder(d=spring_coil_hook_inner_d, h=spring_coil_hook_t_x + 2*eps, center=false);

                // slit through lower-left of the Y/Z ring profile
                translate([
                    -spring_coil_hook_slit_w/2,
                    -spring_coil_hook_outer_d/2 - eps,
                    -eps
                ])
                    cube([
                        spring_coil_hook_slit_w,
                        spring_coil_hook_outer_d/2 + eps,
                        spring_coil_hook_t_x + 2*eps
                    ]);
            
            }
}
guide_y_back  = wall_offset;
guide_y_front = acrylic_inner_y1;
guide_y0 = min(guide_y_back, guide_y_front);
guide_y1 = max(guide_y_back, guide_y_front);
left_guide_x0  = rear_guard_x0;
left_guide_x1  = rear_guard_x0 + rear_guard_border_x;
right_guide_x0 = rear_guard_x1 - rear_guard_border_x;
right_guide_x1 = rear_guard_x1;
guide_seg_z0 = view_z0 + view_h/2 - 4;
guide_seg_z1 = guide_seg_z0 + 8;
half_oval_steps = 48;

module left_half_oval_xy(x0, x1, y0, y1, steps=half_oval_steps){
    w=x1-x0; h=y1-y0; cy=(y0+y1)/2; ry=h/2;
    pts=concat([[x1,y0],[x1,y1]],[for(i=[0:steps])let(t=90+180*i/steps,xr=cos(t),yr=sin(t))[x0+w*(1+xr),cy+ry*yr]]);
    polygon(points=pts);
}

module right_half_oval_xy(x0, x1, y0, y1, steps=half_oval_steps){
    w=x1-x0; h=y1-y0; cy=(y0+y1)/2; ry=h/2;
    pts=concat([[x0,y1],[x0,y0]],[for(i=[0:steps])let(t=-90+180*i/steps,xr=cos(t),yr=sin(t))[x1-w*(1-xr),cy+ry*yr]]);
    polygon(points=pts);
}

module left_side_channel_block(z0=guide_seg_z0, z1=guide_seg_z1){
    difference(){
        translate([left_guide_x0, guide_y0, z0])
            cube([left_guide_x1-left_guide_x0, guide_y1-guide_y0, z1-z0]);
        translate([0, 0, z0-eps])
            linear_extrude(height=(z1-z0)+2*eps)
                left_half_oval_xy(left_guide_x0+channel_outer_x_clear, left_guide_x1+eps, guide_y0+channel_back_clear, guide_y1+eps);
    }
}

module right_side_channel_block(z0=guide_seg_z0, z1=guide_seg_z1){
    difference(){
        translate([right_guide_x0, guide_y0, z0])
            cube([right_guide_x1-right_guide_x0, guide_y1-guide_y0, z1-z0]);
        translate([0, 0, z0-eps])
            linear_extrude(height=(z1-z0)+2*eps)
                right_half_oval_xy(right_guide_x0-eps, right_guide_x1-channel_outer_x_clear, guide_y0+channel_back_clear, guide_y1+eps);
    }
}

module left_side_channel_block_top(){
    z0 = rear_guard_z0 - photo_hang_drop + channel_bottom_kill_z;
    z1 = perimeter_wall_top_z - 2.0;
    left_side_channel_block(z0, z1);
}

module right_side_channel_block_top(){
    z0 = rear_guard_z0 - photo_hang_drop + channel_bottom_kill_z;
    z1 = perimeter_wall_top_z - 2.0;
    right_side_channel_block(z0, z1);
}

module left_side_channel_block_top_support(){
    z1 = perimeter_wall_top_z - 2.0;
    translate([left_guide_x0, guide_y0, z1])
        cube([channel_outer_x_clear, guide_y1-guide_y0, top_cross_z0-z1]);
}

module right_side_channel_block_top_support(){
    z1 = perimeter_wall_top_z - 2.0;
    translate([right_guide_x1 - channel_outer_x_clear, guide_y0, z1])
        cube([channel_outer_x_clear, guide_y1-guide_y0, top_cross_z0-z1]);
}

right_lower_channel_brace_overlap_down_z = 8.0;

module right_lower_channel_terminal_brace(){
    brace_h_z = 3.0;

    brace_base_z0 =
        rear_guard_z0 - photo_hang_drop + channel_bottom_kill_z;

    translate([
        right_guide_x1,
        guide_y0,
        brace_base_z0 - right_lower_channel_brace_overlap_down_z
    ])
        cube([
            wall_w - right_guide_x1,
            guide_y1 - guide_y0,
            brace_h_z + right_lower_channel_brace_overlap_down_z
        ]);
}

module side_channel_terminal_side_braces(){
    brace_h_z = 3.0;

    brace_z0 =
        rear_guard_z0 - photo_hang_drop + channel_bottom_kill_z;

    brace_mid_z0 =
        brace_z0 + (shell_inner_top_z - brace_z0) / 2;

    // left lower brace unchanged
    translate([0, guide_y0, brace_z0])
        cube([left_guide_x0, guide_y1-guide_y0, brace_h_z]);

    // right lower brace isolated / extended downward
    right_lower_channel_terminal_brace();

    // upper/mid braces unchanged
    translate([0, guide_y0, brace_mid_z0])
        cube([left_guide_x0, guide_y1-guide_y0, brace_h_z]);

    translate([right_guide_x1, guide_y0, brace_mid_z0])
        cube([wall_w-right_guide_x1, guide_y1-guide_y0, brace_h_z]);
}

floor_bell_x = 0.6;
floor_bell_extra_z = 0.6;

module floor_bellbottoms(){
    translate([-floor_bell_x, true_full_y0, 0])
        cube([floor_bell_x, true_full_y_len, bottom_t + floor_bell_extra_z]);
    translate([wall_w, true_full_y0, 0])
        cube([floor_bell_x, true_full_y_len, bottom_t + floor_bell_extra_z]);
}

module left_channel_flat_panel(){
    z0 = perimeter_wall_top_z-3;
    z1 = top_cross_z0;
    y0 = acrylic_inner_y1;
    y1 = y0 + channel_back_clear;
    translate([left_guide_x0, y0, z0])
        cube([left_guide_x1-left_guide_x0, y1-y0, z1-z0]);
}

module right_channel_flat_panel(){
    z0 = perimeter_wall_top_z-3;
    z1 = top_cross_z0;
    y0 = acrylic_inner_y1;
    y1 = y0 + channel_back_clear;
    translate([right_guide_x0, y0, z0])
        cube([right_guide_x1-right_guide_x0, y1-y0, z1-z0]);
}

clock_stop_rect_h = 28.0;
clock_stop_roof_h = 23.0;

// NEUTRAL despite clock-ish name: main body is a shared structural floor/side gusset.
// Only the internal clock/seatbelt trap clearance is dry-gated below.
module right_clock_stop_floor_gusset(){
    difference(){
        union(){
            gusset_contact_overlap_z = 3;
            gusset_front_y = front_buildout_y0 + front_frame_t;
            gusset_back_clearance_y = 8.0;
            gusset_back_y = bottom_d - gusset_back_clearance_y;
            gusset_bottom_x = 6.0;
            gusset_mid_x    = 3.0;
            gusset_top_x    = 0.6;
            x1 = clock_side_gusset_x1;
            x0_bottom = x1 - gusset_bottom_x;
            x0_mid    = x1 - gusset_mid_x;
            x0_top    = x1 - gusset_top_x;
            z0 = bottom_t - gusset_contact_overlap_z;
            z1 = z0 + clock_stop_rect_h;
            z2 = z1 + clock_stop_roof_h;
            polyhedron(
                points=[[x0_bottom,gusset_front_y,z0],[x1,gusset_front_y,z0],[x1,gusset_back_y,z0],[x0_bottom,gusset_back_y,z0],[x0_mid,gusset_front_y,z1],[x1,gusset_front_y,z1],[x1,gusset_back_y,z1],[x0_mid,gusset_back_y,z1]],
                faces=[[0,1,2,3],[4,7,6,5],[0,4,5,1],[1,5,6,2],[2,6,7,3],[3,7,4,0]]);
            polyhedron(
                points=[[x0_mid,gusset_front_y,z1],[x1,gusset_front_y,z1],[x1,gusset_back_y,z1],[x0_mid,gusset_back_y,z1],[x0_top,gusset_front_y,z2],[x1,gusset_front_y,z2]],
                faces=[[0,1,2,3],[0,4,5,1],[1,5,2],[0,3,4],[3,2,5,4]]);
        }
        gusset_trap_pos_y_lip = 0;
        // DRY-ONLY: matching clock/seatbelt trap clearance through this otherwise neutral gusset.
        if(dry)
            translate([clock_side_gusset_x1 - clock_bar_trap_depth_x, clock_bar_trap_y0, clock_bar_trap_z0])
                cube([clock_bar_trap_depth_x2+eps, clock_bar_trap_y1-clock_bar_trap_y0-gusset_trap_pos_y_lip, clock_bar_trap_h_z]);
    }
}

clock_backstop_inset_each_side = 6.0;
clock_backstop_ring_w = 2.0;
clock_backstop_y_extra = 4.0;
// Local relief in the bottom rail for the battery-isolator pull string.
// Adjust this single knob if the opening needs a little more/less hand room.
clock_backstop_pull_notch_w_x = 8.0;

// NEUTRAL despite clock-ish name: shared rear/side structural gusset.
module right_clock_stop_rear_corner_gusset(){
    rear_corner_x_w    = 2.2;
    rear_corner_rise_z = 28.0;

    rear_corner_end_cliff_z = 2.0;

    y0 = bottom_front_shelf_y0;
    y1 = bottom_d+1;

    x1 = clock_side_gusset_x1;
    x0 = x1 - rear_corner_x_w;

    z0 = 1.8;
    z1 = bottom_t + rear_corner_rise_z;

    sloped_wall_prism_x(
        [[y0, z1],
         [y0, z0],
         [y1, z0],
         [y1, z0 + rear_corner_end_cliff_z]],
        x0, x1);
}

clock_backstop_top_y_ramp_drop = 2.0;

module clock_negative_y_backstop_ring(){
    outer_x0 = cutout_x + clock_backstop_inset_each_side;
    outer_x1 = cutout_x + clock_body_side - clock_backstop_inset_each_side;
    outer_z0 = clock_body_z0 + clock_backstop_inset_each_side;
    outer_z1 = clock_body_z1 - clock_backstop_inset_each_side - 1.8;
    inner_x0 = outer_x0 + clock_backstop_ring_w;
    inner_x1 = outer_x1 - clock_backstop_ring_w;
    inner_z0 = outer_z0 + clock_backstop_ring_w;
    inner_z1 = outer_z1 - clock_backstop_ring_w;
    y0 = bottom_front_shelf_y0;
    y1 = bottom_front_shelf_y1 + clock_backstop_y_extra;
    module ramped_rect(x0, x1, z0, z1){
        polyhedron(
            points=[[x0,y0,z0],[x1,y0,z0],[x1,y1,z0],[x0,y1,z0],[x0,y0,z1],[x1,y0,z1],[x1,y1,z1-clock_backstop_top_y_ramp_drop],[x0,y1,z1-clock_backstop_top_y_ramp_drop]],
            faces=[[0,1,2,3],[4,7,6,5],[0,4,5,1],[1,5,6,2],[2,6,7,3],[3,7,4,0]]);
    }
    difference(){
        ramped_rect(outer_x0, outer_x1, outer_z0, outer_z1);
        translate([inner_x0, y0-eps, inner_z0])
            cube([inner_x1-inner_x0, y1-y0+2*eps, inner_z1-inner_z0]);

        // Open only the bottom rail around the dot/pull-string path. The cut
        // spans the ring's full Y projection but preserves all other rails.
        translate([
            battery_pull_hole_x - clock_backstop_pull_notch_w_x/2,
            y0 - eps,
            outer_z0 - eps
        ])
            cube([
                clock_backstop_pull_notch_w_x,
                y1 - y0 + 2*eps,
                clock_backstop_ring_w + 2*eps
            ]);
    }
}

// Shared X/Z envelope for the clock winding finger path and optional front opening.
clock_left_access_cut_w = 26.0;   // 1 mm wider

// stop before deeper internal scaffolding
clock_left_access_cut_y1 = wall_offset + wall_t + 2.0;

// Split at the back of the front skin. A small overlap avoids coplanar slivers.
clock_front_cutout_y0 = front_buildout_y0 - eps;
clock_front_cutout_y1 = front_buildout_y0 + front_frame_t + eps;
clock_internal_access_y0 = front_buildout_y0 + front_frame_t - eps;

clock_left_access_shift_x = -2.5;  // shifted left like clock-mechanism cassette

clock_left_access_cut_x0 =
    cutout_x + clock_left_access_shift_x - eps;

clock_left_access_cut_x1 =
    cutout_x + clock_left_access_shift_x + clock_left_access_cut_w;

clock_left_access_cut_z_center =
    clock_body_z0 + clock_body_side * 0.45;

clock_left_access_cut_h_z =
    clock_body_side * 0.35 + 1.0;   // 1 mm taller

clock_left_access_cut_z0 =
    clock_left_access_cut_z_center - clock_left_access_cut_h_z/2 - eps;

clock_left_access_cut_z1 =
    clock_left_access_cut_z_center + clock_left_access_cut_h_z/2 + eps;

// DRY-ONLY permanent void: allows a finger to reach in and wind the clock.
// This is deliberately independent of front_clock_cutout.
module clock_internal_finger_access_void(){
    translate([
        clock_left_access_cut_x0,
        clock_internal_access_y0,
        clock_left_access_cut_z0
    ])
        cube([
            clock_left_access_cut_x1 - clock_left_access_cut_x0,
            clock_left_access_cut_y1 - clock_internal_access_y0,
            clock_left_access_cut_z1 - clock_left_access_cut_z0
        ]);
}

// DRY-ONLY replacement for the large front finger-access void. This narrow
// bore carries only the pull string for a removable battery isolator. It runs
// through the front skin and branding backing to the clock-side pocket.
module battery_isolator_pull_bore(){
    bore_y0 = front_buildout_y0 - eps;
    bore_y1 = clock_left_access_cut_y1;

    translate([battery_pull_hole_x, bore_y0, battery_pull_hole_z])
        rotate([-90, 0, 0])
            cylinder(
                d = battery_pull_hole_d,
                h = bore_y1 - bore_y0 + eps
            );
}

// Readable left-to-right from the finished frame's front. The 2D Y mirror
// compensates for rotating the extrusion into +Y; it is not mirror-written.
module front_website_backing(){
    translate([
        website_front_x - website_backing_w/2,
        front_buildout_y0 + front_frame_t,
        website_front_z - website_backing_h/2
    ])
        cube([
            website_backing_w,
            website_backing_extra_t,
            website_backing_h
        ]);
}

module front_website_deboss(){
    module deboss_text_piece(label, x_anchor, horizontal_alignment){
        translate([x_anchor, front_buildout_y0 - eps, website_text_baseline_z])
            rotate([-90, 0, 0])
                linear_extrude(
                    height = website_deboss_depth + 2*eps,
                    convexity = 10
                )
                    mirror([0, 1, 0])
                        offset(delta = website_stroke_boost)
                            text(
                                label,
                                size = website_text_size,
                                spacing = website_text_spacing,
                                font = website_font,
                                halign = horizontal_alignment,
                                valign = "baseline"
                            );
    }

    deboss_text_piece(
        website_label_left,
        battery_pull_hole_x + website_left_anchor_from_dot_x,
        "right"
    );
    deboss_text_piece(
        website_label_right,
        battery_pull_hole_x + website_right_anchor_from_dot_x,
        "left"
    );
}

// Optional visible opening in only the front frame skin.
// The recess receives a separately applied QR sticker; no QR geometry is printed.
module visible_front_clock_cutout(){
    translate([
        clock_left_access_cut_x0,
        clock_front_cutout_y0,
        clock_left_access_cut_z0
    ])
        cube([
            clock_left_access_cut_x1 - clock_left_access_cut_x0,
            clock_front_cutout_y1 - clock_front_cutout_y0,
            clock_left_access_cut_z1 - clock_left_access_cut_z0
        ]);
}

channel_flutter_bar_t      = 1.8;
channel_flutter_bar_drop_z = 10.0;
channel_flutter_bar_z0 = rear_guard_z0 - photo_hang_drop + channel_bottom_kill_z - 1.0;
channel_flutter_bar_z1 = channel_flutter_bar_z0 - channel_flutter_bar_drop_z;
channel_flutter_bar_y0 = guide_y1;
channel_flutter_bar_y1 = guide_y1 + channel_flutter_bar_t;

module side_channel_flutter_bars(){
    hull(){
        translate([left_guide_x1-channel_flutter_bar_t, channel_flutter_bar_y0, channel_flutter_bar_z0])
            cube([channel_flutter_bar_t, channel_flutter_bar_y1-channel_flutter_bar_y0, channel_flutter_bar_t]);
        translate([rear_guard_center_x-rear_guard_center_strip_w/2, channel_flutter_bar_y0, channel_flutter_bar_z1])
            cube([channel_flutter_bar_t, channel_flutter_bar_y1-channel_flutter_bar_y0, channel_flutter_bar_t]);
    }
    hull(){
        translate([right_guide_x0, channel_flutter_bar_y0, channel_flutter_bar_z0])
            cube([channel_flutter_bar_t, channel_flutter_bar_y1-channel_flutter_bar_y0, channel_flutter_bar_t]);
        translate([rear_guard_center_x+rear_guard_center_strip_w/2-channel_flutter_bar_t, channel_flutter_bar_y0, channel_flutter_bar_z1])
            cube([channel_flutter_bar_t, channel_flutter_bar_y1-channel_flutter_bar_y0, channel_flutter_bar_t]);
    }
}

zipper_slack_keeper_x = 5.0;
zipper_slack_keeper_y = 5.0;
zipper_slack_keeper_z = 8.0;
zipper_slack_keeper_drop_below_thread_hook = 20.0;
zipper_slack_keeper_cy = bottom_d - 19.0;
zipper_slack_keeper_cz = fang_main_z0 - 6.0 - zipper_slack_keeper_drop_below_thread_hook;

module right_zipper_slack_keeper(){
    translate([wall_w-side_panel_t-zipper_slack_keeper_x, zipper_slack_keeper_cy-zipper_slack_keeper_y/2, zipper_slack_keeper_cz-zipper_slack_keeper_z/2])
        cube([zipper_slack_keeper_x, zipper_slack_keeper_y, zipper_slack_keeper_z]);
}

seatbelt_nub_t = 3.0;
seatbelt_nub_y_overlap = 3.0;
seatbelt_upper_y_void = 3.0;
seatbelt_backstop_h = 6.0;

// LEGACY / CURRENTLY UNCALLED: older seatbelt nub definition.
// The active dry seatbelt behavior is currently represented by the gated
// clock_bar_trap cuts in right_side_panel() and right_clock_stop_floor_gusset().
module right_seatbelt_under_nub(){
    x0 = wall_w - side_panel_t - side_lip_overlap_x;
    x1 = wall_w;
    y0 = clock_bar_trap_y1 - seatbelt_nub_y_overlap;
    y1 = bottom_d;
    z0 = clock_bar_trap_z0 - seatbelt_nub_t;
    union(){
        translate([x0, y0, z0])
            cube([x1-x0, y1-y0, seatbelt_nub_t]);
        translate([x0, y0+seatbelt_upper_y_void, z0+seatbelt_nub_t])
            cube([x1-x0, y1-(y0+seatbelt_upper_y_void), seatbelt_backstop_h]);
    }
}

// =========================================================
// LEFT WATER RESERVOIR — FULL-WIDTH SLOPED ROOF
// Hollow reservoir with bottom drain and configurable side fill bore.
// Outer and inner roofs share one continuous slope; no separate flat roof.
// =========================================================
spring_loop_catch_x = 14.15;
spring_loop_catch_y = 0.0;
spring_loop_catch_z = 196.6;

// ---------- sloped reservoir geometry knobs ----------
// water_tank_h fixes the tank bottom relative to water_tank_top_z.
// At triangle_base_drop_z = 0, it is also the rectangular portion height.
// Increasing triangle_base_drop_z lowers the rectangle/triangle boundary,
// steepens and enlarges the triangular roof, and leaves both the tank bottom
// and the roof's highest point unchanged.
water_tank_raise_z = 80;
water_tank_h       = 60;

// NEW KNOB: lower the rectangle-to-triangle transition by this many mm.
// 0 preserves the previous geometry. Example: 5 creates 5 mm more roof rise
// while reducing the rectangular portion's height by 5 mm.
water_tank_triangle_base_drop_z = 18;

water_tank_x0 = side_panel_t;
water_tank_x1 =
    water_tank_x0
    + ((2.25 * inch - 1) - water_tank_x0) *.75;

water_tank_y0 = wall_offset;
water_tank_y1 = bottom_d - 8.0;

water_tank_top_z = bottom_t + 4 * inch + water_tank_raise_z;
water_tank_z0 = water_tank_top_z - water_tank_h;  // tank bottom remains fixed
water_tank_z1 = water_tank_top_z - water_tank_triangle_base_drop_z;
                                                // low roof end / top of rectangle

// Roof shape.
// true  = high end at water_tank_y0 (wall/front side), descending toward +Y.
// false = high end at water_tank_y1, descending toward -Y.
water_tank_slope_high_at_y0 = true;
water_tank_slope_rise_z     = 4.2;         // roof rise when base-drop knob is 0

// Compensates for the lowered triangle base so the highest roof point does
// not move when water_tank_triangle_base_drop_z is increased.
water_tank_effective_slope_rise_z =
    water_tank_slope_rise_z + water_tank_triangle_base_drop_z;

assert(water_tank_triangle_base_drop_z >= 0,
       "water_tank_triangle_base_drop_z must be nonnegative");

// Shell thickness knobs. Roof thickness is measured vertically.
water_tank_wall_t_x = wall_t;
water_tank_wall_t_y = wall_t;
water_tank_floor_t  = wall_t;
water_tank_roof_t_z = wall_t;

assert(water_tank_triangle_base_drop_z < water_tank_h - water_tank_floor_t,
       "triangle base drop leaves no usable rectangular tank height");

water_tank_outer_roof_z_y0 =
    water_tank_z1 + (water_tank_slope_high_at_y0 ? water_tank_effective_slope_rise_z : 0);
water_tank_outer_roof_z_y1 =
    water_tank_z1 + (water_tank_slope_high_at_y0 ? 0 : water_tank_effective_slope_rise_z);

function water_tank_outer_roof_z_at_y(y) =
    water_tank_outer_roof_z_y0
    + (water_tank_outer_roof_z_y1 - water_tank_outer_roof_z_y0)
      * ((y - water_tank_y0) / (water_tank_y1 - water_tank_y0));

water_tank_inner_x0 = water_tank_x0 + water_tank_wall_t_x;
water_tank_inner_x1 = water_tank_x1 - water_tank_wall_t_x;
water_tank_inner_y0 = water_tank_y0 + water_tank_wall_t_y;
water_tank_inner_y1 = water_tank_y1 - water_tank_wall_t_y;
water_tank_inner_z0 = water_tank_z0 + water_tank_floor_t;

// Evaluate the outer slope at the inset Y positions, then move the cavity
// roof downward. This keeps the selected vertical roof thickness consistent.
water_tank_inner_roof_z_y0 =
    water_tank_outer_roof_z_at_y(water_tank_inner_y0) - water_tank_roof_t_z;
water_tank_inner_roof_z_y1 =
    water_tank_outer_roof_z_at_y(water_tank_inner_y1) - water_tank_roof_t_z;

// Upper reservoir outlet + top vent. The integrated cassette uses a broad,
// direct drop instead of relying on the former delicate needle aperture.
// The smaller aperture remains available only with the legacy bucket switch.
reservoir_needle_hole_d = 2.8;
reservoir_drop_hole_d =
    wet_use_integrated_pva_receiver ? 8.0 : reservoir_needle_hole_d;
reservoir_drop_boss_w =
    wet_use_integrated_pva_receiver ? 12.0 : 5.0;
reservoir_vent_hole_d   = 2.2;   // slightly larger so the top perforation reliably prints

reservoir_port_edge_clear_x = 10.0;

reservoir_port_x = water_tank_x0 + reservoir_port_edge_clear_x + reservoir_needle_hole_d/2;
reservoir_port_y = (water_tank_y0 + water_tank_y1) / 2+3;

reservoir_port_z = water_tank_z0;
reservoir_vent_z = max(water_tank_outer_roof_z_y0, water_tank_outer_roof_z_y1);

// ---------- side fill hole knobs ----------
reservoir_side_fill_hole_d = 3.2;   // large-ish blunt needle bore; increase only if your needle needs it
reservoir_side_fill_hole_r = reservoir_side_fill_hole_d / 2;

// Minimum solid/cavity clearance around the circular opening.
// Reduce cautiously to move the hole even closer to the high -Y roof corner.
reservoir_side_fill_front_clear_y = 0.8;
reservoir_side_fill_roof_clear_z  = 0.8;

// Move the hole toward -Y while keeping the entire circular opening inside
// the tank cavity rather than clipping the inner front wall.
reservoir_side_fill_y =
    water_tank_inner_y0
    + reservoir_side_fill_hole_r
    + reservoir_side_fill_front_clear_y;

// Evaluate the sloped inner roof directly above the hole, then raise the hole
// until the circle's top nearly reaches that roof. Because this is the high
// end of the reservoir, the hole's bottom edge nearly maximizes fill level.
reservoir_side_fill_local_inner_roof_z =
    water_tank_outer_roof_z_at_y(reservoir_side_fill_y)
    - water_tank_roof_t_z;

reservoir_side_fill_z =
    reservoir_side_fill_local_inner_roof_z
    - reservoir_side_fill_hole_r
    - reservoir_side_fill_roof_clear_z;

reservoir_side_fill_cut_len_x = side_panel_t + wall_t + side_lip_overlap_x + 8.0;

assert(reservoir_side_fill_y - reservoir_side_fill_hole_r >= water_tank_inner_y0,
       "side fill hole clips the inner -Y wall");
assert(reservoir_side_fill_z + reservoir_side_fill_hole_r <= reservoir_side_fill_local_inner_roof_z,
       "side fill hole clips the sloped inner roof");

module reservoir_drop_bore_2d(){
    circle(d = reservoir_drop_hole_d);
}

/*
module reservoir_vent_bore_2d(){
    circle(d = reservoir_vent_hole_d);
}*/

// WET-ONLY subtractive feature: side fill bore through cassette/tank wall.
module reservoir_side_fill_bore(){
    translate([water_tank_x0 + wall_t/2, reservoir_side_fill_y, reservoir_side_fill_z])
        rotate([0, 90, 0])
            cylinder(d = reservoir_side_fill_hole_d,
                     h = reservoir_side_fill_cut_len_x,
                     center = true);
}

// WET-ONLY additive feature: sloped-roof reservoir, hollow, drop boss, and outlet.
// The outer body is a rectangle plus a full-width right-triangular roof.
// The inner void follows the same slope, so there is no horizontal internal roof.
module water_tank_outer_solid(){
    sloped_wall_prism_x(
        [
            [water_tank_y0, water_tank_z0],
            [water_tank_y1, water_tank_z0],
            [water_tank_y1, water_tank_outer_roof_z_y1],
            [water_tank_y0, water_tank_outer_roof_z_y0]
        ],
        water_tank_x0,
        water_tank_x1
    );
}

module water_tank_inner_void(){
    sloped_wall_prism_x(
        [
            [water_tank_inner_y0, water_tank_inner_z0],
            [water_tank_inner_y1, water_tank_inner_z0],
            [water_tank_inner_y1, water_tank_inner_roof_z_y1],
            [water_tank_inner_y0, water_tank_inner_roof_z_y0]
        ],
        water_tank_inner_x0,
        water_tank_inner_x1
    );
}

module left_water_tank(){
    difference(){
        union(){
            water_tank_outer_solid();

            // Reinforced drop boss centered on the direct outlet.
            translate([reservoir_port_x - reservoir_drop_boss_w/2,
                       reservoir_port_y - reservoir_drop_boss_w/2,
                       reservoir_port_z - 3.0])
                cube([reservoir_drop_boss_w, reservoir_drop_boss_w, 3.0]);
        }

        // Full sloped interior cavity. This replaces the former rectangular
        // hollow that left a separate horizontal roof at water_tank_z1.
        water_tank_inner_void();

        // Direct drop outlet extended through the three-millimeter boss.
        translate([reservoir_port_x, reservoir_port_y, reservoir_port_z - 3.0 - eps])
            linear_extrude(height = water_tank_floor_t + 3.0 + 2*eps)
                reservoir_drop_bore_2d();

   /*     // optional top vent hole; placement must follow the selected slope
        // before this is re-enabled.
                */

    }
}


thread_tube_inner_x = 3.0;
thread_tube_inner_y = 4.0;
thread_tube_wall_t  = 1.2;
thread_tube_yc = bottom_d - 22.0;
thread_tube_top_clearance_z = 1.0;
thread_tube_z1 = fang_main_z0 - 6.0 - thread_tube_top_clearance_z;
thread_tube_z0 = water_tank_z0;

// WET-EXPERIMENTAL / CURRENTLY INACTIVE:
// Definitions retained for possible future string-tube revival; call sites remain commented.
module left_thread_string_tube(){
    x0 = side_panel_t;
    x1 = side_panel_t + thread_tube_inner_x;
    x2 = x1 + thread_tube_wall_t;
    y0 = thread_tube_yc - thread_tube_inner_y/2;
    y1 = thread_tube_yc + thread_tube_inner_y/2;
    z0 = thread_tube_z0;
    z1 = thread_tube_z1-3;
    h = z1 - z0;
    translate([x1, y0 - thread_tube_wall_t, z0])
        cube([thread_tube_wall_t, thread_tube_inner_y + 2*thread_tube_wall_t, h]);
    translate([x0, y0 - thread_tube_wall_t, z0])
        cube([thread_tube_inner_x + thread_tube_wall_t, thread_tube_wall_t, h]);
    translate([x0, y1, z0])
        cube([thread_tube_inner_x + thread_tube_wall_t, thread_tube_wall_t, h]);
}

// Matching void for inactive left_thread_string_tube().
module left_thread_string_tube_void(){
    x0 = side_panel_t - eps;
    x1 = side_panel_t + thread_tube_inner_x + eps;
    y0 = thread_tube_yc - thread_tube_inner_y/2 - eps;
    y1 = thread_tube_yc + thread_tube_inner_y/2 + eps;
    z0 = thread_tube_z0 - eps;
    z1 = thread_tube_z1 - 3 + eps;
    translate([x0, y0, z0])
        cube([x1-x0, y1-y0, z1-z0]);
}

// =========================================================
// INTEGRATED PVA WATER RECEIVER
// Replaces the removable bucket without changing the upper drip reservoir.
//
// The falling stream enters a narrow vertical water column and accumulates in
// the wider reservoir boot at the bottom. A rigid side chamber branches from
// the column near the top, out of the falling stream. Water reaches that
// chamber only when the level rises to its branch inlet. The consumable PVA
// STRING crosses the short X width of the chamber through two small opposing
// holes; the chamber itself is permanent cassette structure. After leaving
// the chamber toward -X, a folded string loop can be secured around the bridge
// between the two holes in the cassette side wall.
// =========================================================

wet_print_nozzle_d = 0.6;
integrated_receiver_wall_t = 3.0;
integrated_receiver_floor_t = 3.0;

// Wide low boot plus narrow riser. This retains a generous catch target while
// keeping the volume below the PVA elevation small enough for the upper tank.
integrated_receiver_x0 = side_panel_t;
integrated_receiver_x1 = water_tank_x1;
integrated_receiver_y0 = water_tank_y0;
integrated_receiver_y1 = water_tank_y1;
integrated_receiver_z0 = bottom_t_thin;
integrated_receiver_boss_overlap_z = 0.5;
integrated_receiver_z1 =
    water_tank_z0 - 3.0 + integrated_receiver_boss_overlap_z;

integrated_receiver_boot_top_z = bottom_t + 23.0;
integrated_receiver_tower_w_x = 16.0;
integrated_receiver_tower_x0 =
    reservoir_port_x - integrated_receiver_tower_w_x/2;
integrated_receiver_tower_x1 =
    reservoir_port_x + integrated_receiver_tower_w_x/2;
integrated_receiver_tower_z0 =
    integrated_receiver_boot_top_z - integrated_receiver_wall_t;

integrated_receiver_boot_inner_x0 =
    integrated_receiver_x0 + integrated_receiver_wall_t;
integrated_receiver_boot_inner_x1 =
    integrated_receiver_x1 - integrated_receiver_wall_t;
integrated_receiver_tower_inner_x0 =
    integrated_receiver_tower_x0 + integrated_receiver_wall_t;
integrated_receiver_tower_inner_x1 =
    integrated_receiver_tower_x1 - integrated_receiver_wall_t;
integrated_receiver_inner_y0 =
    integrated_receiver_y0 + integrated_receiver_wall_t;
integrated_receiver_inner_y1 =
    integrated_receiver_y1 - integrated_receiver_wall_t;
integrated_receiver_inner_z0 =
    integrated_receiver_z0 + integrated_receiver_floor_t;
integrated_receiver_boot_inner_z1 =
    integrated_receiver_boot_top_z - integrated_receiver_wall_t;
integrated_receiver_tower_inner_z0 =
    integrated_receiver_boot_inner_z1 - integrated_receiver_wall_t;

// High, rear string-wetting chamber. It is a rigid closed-roof branch of the
// water column, sheltered from falling water. Its two small string bores also
// vent displaced air while it fills. Keep this deliberately tiny so the PVA
// string only has to cross a short, easily threaded tunnel.
// Four nominal 0.6mm extrusion lines on the compact chamber shell. Preserve
// the two-millimeter internal crossing while thickening its wet walls.
pva_chamber_side_wall_x = 2.4;
pva_chamber_floor_roof_t = 2.4;
pva_chamber_inner_w_x = 2.0;
pva_chamber_outer_w_x =
    pva_chamber_inner_w_x + 2*pva_chamber_side_wall_x;
pva_chamber_column_edge_inset_x = 1.0;
pva_chamber_outer_x1 =
    integrated_receiver_tower_x1 - pva_chamber_column_edge_inset_x;
pva_chamber_outer_x0 = pva_chamber_outer_x1 - pva_chamber_outer_w_x;
pva_chamber_outer_y0 = integrated_receiver_y1 - 2.4;
pva_chamber_outer_y1 = bottom_d;
pva_chamber_outer_z0 = 92.0;
pva_chamber_outer_z1 = 104.0;

pva_chamber_inner_x0 =
    pva_chamber_outer_x0 + pva_chamber_side_wall_x;
pva_chamber_inner_x1 =
    pva_chamber_outer_x1 - pva_chamber_side_wall_x;
pva_chamber_inner_y0 =
    pva_chamber_outer_y0 + integrated_receiver_wall_t;
pva_chamber_inner_y1 =
    pva_chamber_outer_y1 - integrated_receiver_wall_t;
pva_chamber_inner_z0 =
    pva_chamber_outer_z0 + pva_chamber_floor_roof_t;
pva_chamber_inner_z1 =
    pva_chamber_outer_z1 - pva_chamber_floor_roof_t;

// High branch inlet: this is the bottom leg of the elbow-like side chamber.
// It sits below the string but far above the reservoir boot, so water cannot
// reach the string until the whole column has risen to the trigger height.
pva_equalizer_d = 4.0;
pva_equalizer_x =
    (pva_chamber_inner_x0 + pva_chamber_inner_x1) / 2;
pva_equalizer_z = pva_chamber_inner_z0 + pva_equalizer_d/2 + 0.4;
pva_equalizer_y0 = integrated_receiver_inner_y1 - eps;
pva_equalizer_y1 = pva_chamber_inner_y0 + eps;

// PVA pass-through. A 1.2mm straight throat is two nominal 0.6mm nozzle
// widths: small enough to limit seepage, but still realistic to slice open.
// No enlarged face funnels: the compact X span makes direct threading easy.
pva_string_hole_d = 2*wet_print_nozzle_d;
pva_string_y = (pva_chamber_inner_y0 + pva_chamber_inner_y1) / 2;
pva_string_z = 99.0;
pva_string_bore_x0 = pva_chamber_outer_x0 - 1.0;
pva_string_bore_x1 = pva_chamber_outer_x1 + 1.0;

// Two button-sized side-wall holes form a stout vertical bridge that can
// receive a luggage-tag / girth hitch. They sit behind the wet receiver in a
// locally reinforced dry wall region, centered around the string elevation.
pva_hitch_hole_d = 4.0;
pva_hitch_hole_y = (integrated_receiver_y1 + bottom_d) / 2;
pva_hitch_hole_z0 = pva_string_z - 4.0;
pva_hitch_hole_z1 = pva_string_z + 4.0;
pva_hitch_pad_x0 = 0.0;
pva_hitch_pad_x1 = side_panel_t + 3.0;
pva_hitch_pad_y0 = integrated_receiver_y1 - 0.15;
pva_hitch_pad_y1 = bottom_d - 0.10;
pva_hitch_pad_z0 = pva_hitch_hole_z0 - pva_hitch_hole_d/2 - 1.5;
pva_hitch_pad_z1 = pva_hitch_hole_z1 + pva_hitch_hole_d/2 + 1.5;

// Bottom drain sized for the uxcell snap-lock silicone plug sold for 5-5.5 mm
// holes (5.2 mm pole, 2.0 mm locking slot, 9.8 mm head, 7.0 mm overall height).
// The outside recess leaves a 2.0 mm web for the plug's locking slot, so the
// inner flange positively retains the plug against water pressure.
integrated_drain_x = reservoir_port_x;
integrated_drain_y = reservoir_port_y;
integrated_drain_bore_d = 5.2;
integrated_drain_commercial_plug_head_d = 9.8;
integrated_drain_seat_radial_clearance = 0.3;
integrated_drain_seat_d =
    integrated_drain_commercial_plug_head_d
    + 2*integrated_drain_seat_radial_clearance;
integrated_drain_locking_web_t = 2.0;
integrated_drain_seat_h =
    integrated_receiver_inner_z0 - integrated_drain_locking_web_t;

assert(integrated_receiver_tower_x0 >= integrated_receiver_x0,
       "integrated receiver tower exceeds the boot at -X");
assert(integrated_drain_seat_h > 0,
       "commercial drain-plug seat has no depth");
assert(integrated_drain_locking_web_t >= 3*wet_print_nozzle_d,
       "commercial drain plug leaves too little locking wall");
assert(integrated_receiver_wall_t >= 5*wet_print_nozzle_d,
       "main wet walls provide fewer than five nominal nozzle lines");
assert(water_tank_wall_t_x >= 5*wet_print_nozzle_d
       && water_tank_wall_t_y >= 5*wet_print_nozzle_d
       && water_tank_floor_t >= 5*wet_print_nozzle_d,
       "upper tank wet walls provide fewer than five nominal nozzle lines");
assert(water_tank_roof_t_z >= 5*wet_print_nozzle_d,
       "upper tank roof provides fewer than five nominal nozzle lines");
assert(pva_chamber_side_wall_x >= 4*wet_print_nozzle_d
       && pva_chamber_floor_roof_t >= 4*wet_print_nozzle_d,
       "compact chamber wet walls provide fewer than four nominal nozzle lines");
assert(integrated_receiver_tower_x1 <= integrated_receiver_x1,
       "integrated receiver tower exceeds the boot width");
assert(integrated_receiver_z1 < water_tank_z0,
       "water column must stop inside the upper reservoir's drop boss");
assert(pva_chamber_inner_x1 > pva_chamber_inner_x0,
       "string-wetting chamber has no internal X width");
assert(pva_chamber_outer_x0 - side_panel_t >= 10.0,
       "string-wetting chamber leaves too little side-wall finger space");
assert(pva_chamber_inner_y1 > pva_chamber_inner_y0,
       "string-wetting chamber has no internal Y depth");
assert(pva_string_z < pva_chamber_inner_z1 - pva_string_hole_d/2,
       "PVA bore is too close to the chamber roof");
assert(pva_hitch_hole_z0 + pva_hitch_hole_d/2
       < pva_hitch_hole_z1 - pva_hitch_hole_d/2,
       "PVA hitch holes leave no solid bridge");
assert(pva_hitch_hole_y - pva_hitch_hole_d/2
       > integrated_receiver_y1,
       "PVA hitch holes clip the wet receiver");
assert(pva_hitch_hole_y + pva_hitch_hole_d/2
       < pva_hitch_pad_y1,
       "PVA hitch holes clip the cassette back edge");
assert(pva_hitch_hole_z0 - pva_hitch_hole_d/2 > pva_hitch_pad_z0
       && pva_hitch_hole_z1 + pva_hitch_hole_d/2 < pva_hitch_pad_z1,
       "PVA hitch holes clip the reinforced pad in Z");

module integrated_pva_receiver_solid(){
    union(){
        // Wide, low catch boot.
        translate([
            integrated_receiver_x0,
            integrated_receiver_y0,
            integrated_receiver_z0
        ])
            cube([
                integrated_receiver_x1 - integrated_receiver_x0,
                integrated_receiver_y1 - integrated_receiver_y0,
                integrated_receiver_boot_top_z - integrated_receiver_z0
            ]);

        // Narrow vertical riser directly below the upper drip reservoir.
        translate([
            integrated_receiver_tower_x0,
            integrated_receiver_y0,
            integrated_receiver_tower_z0
        ])
            cube([
                integrated_receiver_tower_x1 - integrated_receiver_tower_x0,
                integrated_receiver_y1 - integrated_receiver_y0,
                integrated_receiver_z1 - integrated_receiver_tower_z0
            ]);

        // Rear, string-bore-vented wetting side chamber.
        translate([
            pva_chamber_outer_x0,
            pva_chamber_outer_y0,
            pva_chamber_outer_z0
        ])
            cube([
                pva_chamber_outer_x1 - pva_chamber_outer_x0,
                pva_chamber_outer_y1 - pva_chamber_outer_y0,
                pva_chamber_outer_z1 - pva_chamber_outer_z0
            ]);
    }
}

module integrated_pva_receiver_water_voids(){
    union(){
        // Lower boot cavity.
        translate([
            integrated_receiver_boot_inner_x0,
            integrated_receiver_inner_y0,
            integrated_receiver_inner_z0
        ])
            cube([
                integrated_receiver_boot_inner_x1 - integrated_receiver_boot_inner_x0,
                integrated_receiver_inner_y1 - integrated_receiver_inner_y0,
                integrated_receiver_boot_inner_z1 - integrated_receiver_inner_z0
            ]);

        // Open-top riser cavity; overlap joins it to the lower boot cavity.
        translate([
            integrated_receiver_tower_inner_x0,
            integrated_receiver_inner_y0,
            integrated_receiver_tower_inner_z0
        ])
            cube([
                integrated_receiver_tower_inner_x1 - integrated_receiver_tower_inner_x0,
                integrated_receiver_inner_y1 - integrated_receiver_inner_y0,
                integrated_receiver_z1
                    - integrated_receiver_tower_inner_z0 + eps
            ]);

        // Sheltered string-wetting chamber cavity; retain a solid roof so the
        // last water from the upper tank cannot overflow out of this branch.
        translate([
            pva_chamber_inner_x0,
            pva_chamber_inner_y0,
            pva_chamber_inner_z0
        ])
            cube([
                pva_chamber_inner_x1 - pva_chamber_inner_x0,
                pva_chamber_inner_y1 - pva_chamber_inner_y0,
                pva_chamber_inner_z1 - pva_chamber_inner_z0
            ]);

        // Short high branch from the main column into the sheltered chamber.
        translate([pva_equalizer_x, pva_equalizer_y0, pva_equalizer_z])
            rotate([-90,0,0])
                cylinder(
                    d = pva_equalizer_d,
                    h = pva_equalizer_y1 - pva_equalizer_y0
                );
    }
}

module integrated_pva_string_bore(){
    translate([pva_string_bore_x0, pva_string_y, pva_string_z])
        rotate([0,90,0])
            cylinder(
                d = pva_string_hole_d,
                h = pva_string_bore_x1 - pva_string_bore_x0
            );
}

module integrated_pva_hitch_holes(){
    for(z = [pva_hitch_hole_z0, pva_hitch_hole_z1])
        translate([-eps, pva_hitch_hole_y, z])
            rotate([0,90,0])
                cylinder(
                    d = pva_hitch_hole_d,
                    h = pva_hitch_pad_x1 + 2*eps
                );
}

module integrated_pva_hitch_pad(){
    translate([pva_hitch_pad_x0, pva_hitch_pad_y0, pva_hitch_pad_z0])
        cube([
            pva_hitch_pad_x1 - pva_hitch_pad_x0,
            pva_hitch_pad_y1 - pva_hitch_pad_y0,
            pva_hitch_pad_z1 - pva_hitch_pad_z0
        ]);
}

module integrated_receiver_bottom_drain(){
    // Straight wet bore through the receiver floor and cassette bottom.
    translate([integrated_drain_x, integrated_drain_y, -eps])
        cylinder(
            d = integrated_drain_bore_d,
            h = integrated_receiver_inner_z0 + 2*eps
        );

    // Outside counterbore for the commercial plug head. Its depth leaves the
    // specified 2 mm locking web immediately below the wet cavity.
    translate([integrated_drain_x, integrated_drain_y, -eps])
        cylinder(
            d = integrated_drain_seat_d,
            h = integrated_drain_seat_h + eps
        );
}

module integrated_pva_receiver_voids(){
    integrated_pva_receiver_water_voids();
    integrated_pva_string_bore();
    integrated_pva_hitch_holes();
    integrated_receiver_bottom_drain();
}

module integrated_pva_receiver_finished(){
    difference(){
        integrated_pva_receiver_solid();
        integrated_pva_receiver_water_voids();
        integrated_pva_string_bore();
        integrated_receiver_bottom_drain();
    }
}

// Isolated review of every water-system feature that is fused into the
// cassette. This is a diagnostic scene, not a separate printable part.
module integrated_water_system_review(){
    difference(){
        union(){
            left_water_tank();
            integrated_pva_receiver_solid();
            integrated_pva_hitch_pad();
        }
        reservoir_side_fill_bore();
        integrated_pva_receiver_water_voids();
        integrated_pva_string_bore();
        integrated_pva_hitch_holes();
        integrated_receiver_bottom_drain();
    }
}

// Minimal structure needed to print and handle the water mechanism without
// the cassette frame. The base reproduces the original cassette floor under
// the drain. The narrow rear spine holds the two hitch holes at their real
// offset while leaving the threading/finger gap open.
standalone_test_base_x0 = 0.0;
standalone_test_base_x1 = integrated_receiver_x1;
standalone_test_base_y0 = integrated_receiver_y0;
standalone_test_base_y1 = bottom_d;
standalone_test_base_z0 = 0.0;
standalone_test_base_z1 = bottom_t;

standalone_test_spine_x0 = 0.0;
standalone_test_spine_x1 = side_panel_t + 1.8;
standalone_test_spine_y0 = integrated_receiver_y1 - 3.0;
standalone_test_spine_y1 = bottom_d - 0.10;
standalone_test_spine_z0 = standalone_test_base_z0;
standalone_test_spine_z1 = pva_hitch_pad_z1;

assert(standalone_test_base_x1 > integrated_receiver_x0,
       "standalone base does not overlap the receiver");
assert(standalone_test_spine_x1 > integrated_receiver_x0
       && standalone_test_spine_y0 < integrated_receiver_y1,
       "standalone hitch spine does not overlap the water-system base");
assert(pva_chamber_outer_x0 - pva_hitch_pad_x1 >= 8.0,
       "standalone tester leaves too little threading access");

module standalone_hydraulic_test_structure(){
    union(){
        translate([
            standalone_test_base_x0,
            standalone_test_base_y0,
            standalone_test_base_z0
        ])
            cube([
                standalone_test_base_x1 - standalone_test_base_x0,
                standalone_test_base_y1 - standalone_test_base_y0,
                standalone_test_base_z1 - standalone_test_base_z0
            ]);

        translate([
            standalone_test_spine_x0,
            standalone_test_spine_y0,
            standalone_test_spine_z0
        ])
            cube([
                standalone_test_spine_x1 - standalone_test_spine_x0,
                standalone_test_spine_y1 - standalone_test_spine_y0,
                standalone_test_spine_z1 - standalone_test_spine_z0
            ]);
    }
}

module standalone_hydraulic_string_tester(){
    difference(){
        union(){
            left_water_tank();
            integrated_pva_receiver_solid();
            integrated_pva_hitch_pad();
            standalone_hydraulic_test_structure();
        }
        reservoir_side_fill_bore();
        integrated_pva_receiver_water_voids();
        integrated_pva_string_bore();
        integrated_pva_hitch_holes();
        integrated_receiver_bottom_drain();
    }
}

// Minimum scaffolding that belongs to the upside-down test print:
// - a flat plate above the reservoir becomes the build-plate base after flip;
// - a four-line-thick side wall ties that plate to the lower test base;
// - a tiny bridge at the hitch-pad top closes the red-circled gap to the riser.
standalone_print_skin_t = 4*wet_print_nozzle_d;

standalone_print_plate_x0 = standalone_test_base_x0;
standalone_print_plate_x1 = standalone_test_base_x1;
standalone_print_plate_y0 = standalone_test_base_y0;
standalone_print_plate_y1 = standalone_test_base_y1;
standalone_print_plate_z0 = reservoir_vent_z;
standalone_print_plate_z1 =
    standalone_print_plate_z0 + standalone_print_skin_t;

standalone_print_wall_x0 =
    standalone_test_base_x1 - standalone_print_skin_t;
standalone_print_wall_x1 = standalone_test_base_x1;
standalone_print_wall_y0 = standalone_test_base_y0;
standalone_print_wall_y1 = standalone_test_base_y1;
standalone_print_wall_z0 = standalone_test_base_z0;
standalone_print_wall_z1 = standalone_print_plate_z1;

standalone_hitch_bridge_x0 = pva_hitch_pad_x1 - 0.4;
standalone_hitch_bridge_x1 = integrated_receiver_tower_x0 + 0.4;
standalone_hitch_bridge_y0 = integrated_receiver_y1 - 2.4;
standalone_hitch_bridge_y1 = pva_hitch_pad_y0 + 2.4;
standalone_hitch_bridge_z0 = pva_hitch_pad_z1 - standalone_print_skin_t;
standalone_hitch_bridge_z1 = pva_hitch_pad_z1;

assert(standalone_hitch_bridge_x0 < pva_hitch_pad_x1
       && standalone_hitch_bridge_x1 > integrated_receiver_tower_x0,
       "standalone hitch bridge misses the pad or water column");
assert(standalone_print_skin_t >= 4*wet_print_nozzle_d,
       "standalone print plate/wall provides fewer than four nozzle lines");

module standalone_inverted_print_structure(){
    union(){
        // Green horizontal marker: flat build plate after inversion.
        translate([
            standalone_print_plate_x0,
            standalone_print_plate_y0,
            standalone_print_plate_z0
        ])
            cube([
                standalone_print_plate_x1 - standalone_print_plate_x0,
                standalone_print_plate_y1 - standalone_print_plate_y0,
                standalone_print_plate_z1 - standalone_print_plate_z0
            ]);

        // Green vertical marker: minimum full-height connecting wall.
        translate([
            standalone_print_wall_x0,
            standalone_print_wall_y0,
            standalone_print_wall_z0
        ])
            cube([
                standalone_print_wall_x1 - standalone_print_wall_x0,
                standalone_print_wall_y1 - standalone_print_wall_y0,
                standalone_print_wall_z1 - standalone_print_wall_z0
            ]);

        // Red circle: short pad-to-riser connector.
        translate([
            standalone_hitch_bridge_x0,
            standalone_hitch_bridge_y0,
            standalone_hitch_bridge_z0
        ])
            cube([
                standalone_hitch_bridge_x1 - standalone_hitch_bridge_x0,
                standalone_hitch_bridge_y1 - standalone_hitch_bridge_y0,
                standalone_hitch_bridge_z1 - standalone_hitch_bridge_z0
            ]);
    }
}

module standalone_hydraulic_string_tester_with_print_structure(){
    union(){
        standalone_hydraulic_string_tester();
        standalone_inverted_print_structure();
    }
}

module standalone_hydraulic_string_tester_inverted(){
    translate([
        0,
        standalone_test_base_y1,
        standalone_print_plate_z1
    ])
        rotate([180,0,0])
            standalone_hydraulic_string_tester_with_print_structure();
}

// Diagnostic X section through the high branch and PVA-string bore centers.
module integrated_pva_receiver_cutaway(){
    intersection(){
        integrated_pva_receiver_finished();
        translate([
            integrated_receiver_x0 - eps,
            integrated_receiver_y0 - eps,
            integrated_receiver_z0 - eps
        ])
            cube([
                pva_equalizer_x - integrated_receiver_x0 + eps,
                bottom_d - integrated_receiver_y0 + 2*eps,
                integrated_receiver_z1 - integrated_receiver_z0 + 2*eps
            ]);
    }
}

module spring_loop_catch(){
    nub_x = 3.0;
    nub_y = 5.6
    ;
    nub_z = 4.0;

    stick_len_x = 3.0;
    stick_y     = 1.2;
    stick_z     = 1.4;

    union(){
        cube([nub_x, nub_y, nub_z]);

        // stick rises from +Y face and points toward -X
        translate([-stick_len_x+1.6,
                   nub_y-.4,

                   nub_z/2 - stick_z/2])
            cube([stick_len_x, stick_y, stick_z]);
    }
}
// // =========================================================
// UNDER-TANK BUCKET TENSION LIPS
// Bucket wedges between two Y-side lips under the water tank.
// Kept inside tank Y profile to avoid paper-channel obstruction.
// Wall-backed right triangles: widest in X at bottom, tight to side wall at top.
// =========================================================

bucket_lips_on = true;

bucket_nominal_d_y = 23.0;

// smaller gap = tighter squeeze
bucket_lip_squeeze = 0.6;
bucket_lip_gap_y = bucket_nominal_d_y - bucket_lip_squeeze;

bucket_lip_yc = (water_tank_y0 + water_tank_y1) / 2;
bucket_lip_front_y = bucket_lip_yc - bucket_lip_gap_y/2;
bucket_lip_back_y  = bucket_lip_yc + bucket_lip_gap_y/2;

bucket_lip_y_t = 4.0;

// side-wall attachment / inward reach
bucket_lip_x0 = side_panel_t;
bucket_lip_x1 = side_panel_t + 22.0;

// low placement near cassette floor
bucket_lip_floor_clear_z = 2.0;

bucket_lip_z0 = bottom_t + bucket_lip_floor_clear_z;
bucket_lip_z1 = bottom_t + 40.0;

// =========================================================
// SIMPLE BUCKET RETENTION HOOK
// Source of truth is the tooth top Z.
// =========================================================

bucket_hook_on = false;

bucket_hook_y_w = 4.0;

bucket_hook_x_gap   = 3.2;  // free space before tooth
bucket_hook_x_tooth = 1.2;  // tiny retention tooth

bucket_hook_roof_h_z    = 4.0;
bucket_hook_tooth_h_z   = 1.5;

bucket_hook_roof_bottom_clear_z = 0.6;
bucket_h_z = 90.0;

// master datum (underside of roof block)
bucket_hook_tooth_top_z =
    bottom_t + bucket_h_z + bucket_hook_roof_bottom_clear_z;

bucket_hook_y0 = bucket_lip_yc - bucket_hook_y_w/2;
bucket_hook_y1 = bucket_lip_yc + bucket_hook_y_w/2;
// Coordinated with the lowered, larger, downhill standalone bucket overflow.
bucket_overflow_tube_od = 7.0;
bucket_overflow_tube_clear = 0.4;
bucket_overflow_down_angle_deg = 6.0;
bucket_overflow_port_drop_z = 6.0;
bucket_overflow_port_z =
    bucket_h_z - bucket_overflow_port_drop_z;

bucket_overflow_tube_slot_d =
    bucket_overflow_tube_od + 2*bucket_overflow_tube_clear;

bucket_overflow_tube_y =
    bucket_lip_yc + 1.5;

// The standalone bucket's -X wall sits at bucket_lip_x0. Move the slot center
// down by the small amount the downhill tube drops between that wall and the
// cassette side-panel midpoint.
bucket_overflow_tube_slot_x =
    side_panel_t/2;

bucket_overflow_tube_slot_z =
    bottom_t + bucket_overflow_port_z
    - tan(bucket_overflow_down_angle_deg)
      * (bucket_lip_x0 - bucket_overflow_tube_slot_x);

// Extend the rotated cutter beyond both wall faces so no membrane remains.
bucket_overflow_tube_slot_end_clear_x = 2.0;

bucket_overflow_tube_slot_run_x =
    side_panel_t + 2*bucket_overflow_tube_slot_end_clear_x;

bucket_overflow_tube_slot_h =
    bucket_overflow_tube_slot_run_x
    / cos(bucket_overflow_down_angle_deg);

assert(bucket_overflow_tube_slot_z + bucket_overflow_tube_slot_d/2
       < bottom_t + bucket_h_z,
       "overflow slot reaches the bucket top; increase bucket_overflow_port_drop_z");
assert(bucket_overflow_tube_slot_h
       * cos(bucket_overflow_down_angle_deg) > side_panel_t,
       "angled overflow cutter does not span the cassette wall");

// WET-ONLY subtractive feature: matching angled left-side clearance.
module bucket_overflow_tube_slot(){

    translate([
        bucket_overflow_tube_slot_x,
        bucket_overflow_tube_y,
        bucket_overflow_tube_slot_z
    ])
        rotate([0, 90 - bucket_overflow_down_angle_deg, 0])
            cylinder(
                d = bucket_overflow_tube_slot_d,
                h = bucket_overflow_tube_slot_h,
                center = true
            );
}
module bucket_retention_hook(){

    if(bucket_hook_on){

        // upper body
        translate([
            bucket_lip_x0,
            bucket_hook_y0,
            bucket_hook_tooth_top_z
        ])
            cube([
                bucket_hook_x_gap + bucket_hook_x_tooth,
                bucket_hook_y1 - bucket_hook_y0,
                bucket_hook_roof_h_z
            ]);

        // lower tooth
        translate([
            bucket_lip_x0 + bucket_hook_x_gap,
            bucket_hook_y0,
            bucket_hook_tooth_top_z - bucket_hook_tooth_h_z
        ])
            cube([
                bucket_hook_x_tooth,
                bucket_hook_y1 - bucket_hook_y0,
                bucket_hook_tooth_h_z
            ]);
            // wall-to-roof printability gusset
            bucket_hook_ramp_h_z = 2.0;
triangular_prism_y(
    [[bucket_lip_x0,
      bucket_hook_tooth_top_z + bucket_hook_roof_h_z],

     [bucket_lip_x0,
      bucket_hook_tooth_top_z + bucket_hook_roof_h_z + bucket_hook_ramp_h_z],

     [bucket_lip_x0 + bucket_hook_x_gap + bucket_hook_x_tooth,
      bucket_hook_tooth_top_z + bucket_hook_roof_h_z]],

    bucket_hook_y0,
    bucket_hook_y1
);
    }
}

module bucket_front_tension_lip(){
    triangular_prism_y(
        [[bucket_lip_x0, bucket_lip_z0],
         [bucket_lip_x1, bucket_lip_z0],
         [bucket_lip_x0, bucket_lip_z1]],
        bucket_lip_front_y - bucket_lip_y_t,
        bucket_lip_front_y
    );
}

module bucket_back_tension_lip(){
    triangular_prism_y(
        [[bucket_lip_x0, bucket_lip_z0],
         [bucket_lip_x1, bucket_lip_z0],
         [bucket_lip_x0, bucket_lip_z1]],
        bucket_lip_back_y,
        bucket_lip_back_y + bucket_lip_y_t
    );
}


// WET-ONLY additive feature: under-tank Y squeeze lips for bucket retention.
// Small diagonal anti-walkout bars on the bucket-facing sides of the Y tension lips.
// Purpose: resist diagonal +X/+Z bucket walkout under string pull.
//
// These are not snap hooks. They are shallow raised diagonal brakes on the
// inside faces of the two triangular bucket tension lips.

// WET-ONLY additive feature: under-tank Y squeeze lips for bucket retention.
// Embedded diagonal anti-walkout cleats on bucket-facing sides.
// Purpose: resist diagonal +X/+Z bucket walkout under string pull.
//
// These cleats are generated from the actual triangular lip face.
// Each endpoint straddles the face, so the cleat is fused into the lip,
// not floating near it.

bucket_lip_ribs_on = true;

bucket_lip_rib_count = 2;
bucket_lip_rib_z0 = bucket_lip_z0 + 17.0;
bucket_lip_rib_pitch_z = 8.0;

// diagonal cleat geometry
bucket_lip_diag_drop_z = 4.0;      // high end to low end
bucket_lip_rib_t_z = 0.8;          // endpoint pad thickness before hull

// X/Z face attachment
bucket_lip_rib_embed_x = 1.0;      // into triangular lip body
bucket_lip_rib_protrude_x = 0.6;   // inward past sloped face

// Y face attachment
bucket_lip_rib_embed_y = 0.45;     // into the Y lip body
bucket_lip_rib_protrude_y = 0.35;  // into bucket gap

// X position of triangular lip's sloped contact face at a given Z.
// Face runs from bottom/inward [bucket_lip_x1,bucket_lip_z0]
// to top/sidewall [bucket_lip_x0,bucket_lip_z1].
function bucket_lip_contact_x_at_z(z) =
    bucket_lip_x1
    - (bucket_lip_x1 - bucket_lip_x0)
      * ((z - bucket_lip_z0) / (bucket_lip_z1 - bucket_lip_z0));

module bucket_lip_cleat_endpoint(x_face, y0, zc){
    translate([
        x_face - bucket_lip_rib_embed_x,
        y0,
        zc - bucket_lip_rib_t_z/2
    ])
        cube([
            bucket_lip_rib_embed_x + bucket_lip_rib_protrude_x,
            bucket_lip_rib_embed_y + bucket_lip_rib_protrude_y,
            bucket_lip_rib_t_z
        ]);
}

module bucket_lip_diagonal_cleat_front(z_base){

    z_hi = z_base + bucket_lip_diag_drop_z;
    z_lo = z_base;

    x_hi = bucket_lip_contact_x_at_z(z_hi);
    x_lo = bucket_lip_contact_x_at_z(z_lo);

    // Front lip:
    // lip body is on -Y side of bucket_lip_front_y;
    // bucket gap is +Y from bucket_lip_front_y.
    hull(){
        bucket_lip_cleat_endpoint(
            x_hi,
            bucket_lip_front_y - bucket_lip_rib_embed_y,
            z_hi
        );

        bucket_lip_cleat_endpoint(
            x_lo,
            bucket_lip_front_y - bucket_lip_rib_embed_y,
            z_lo
        );
    }
}

module bucket_lip_diagonal_cleat_back(z_base){

    z_hi = z_base + bucket_lip_diag_drop_z;
    z_lo = z_base;

    x_hi = bucket_lip_contact_x_at_z(z_hi);
    x_lo = bucket_lip_contact_x_at_z(z_lo);

    // Back lip:
    // lip body is on +Y side of bucket_lip_back_y;
    // bucket gap is -Y from bucket_lip_back_y.
    hull(){
        bucket_lip_cleat_endpoint(
            x_hi,
            bucket_lip_back_y - bucket_lip_rib_protrude_y,
            z_hi
        );

        bucket_lip_cleat_endpoint(
            x_lo,
            bucket_lip_back_y - bucket_lip_rib_protrude_y,
            z_lo
        );
    }
}

module bucket_lip_anti_walkout_ribs(){
    if (bucket_lip_ribs_on){
        for(i = [0 : bucket_lip_rib_count - 1]){
            z = bucket_lip_rib_z0 + i * bucket_lip_rib_pitch_z;

            bucket_lip_diagonal_cleat_front(z);
            bucket_lip_diagonal_cleat_back(z);
        }
    }
}

module bucket_under_tank_tension_lips(){
    if (bucket_lips_on){
        bucket_front_tension_lip();
        bucket_back_tension_lip();
        bucket_lip_anti_walkout_ribs();
    }
}

// =========================================================
// TRAP RIG RECEIVER — GREY STOP / ROOT NUBS ONLY
// =========================================================

trap_receiver_on = true;

// hard-coded rig wall envelope
trap_rig_x0 = 47.6;
trap_rig_x1 = 127.7;
trap_rig_z0 = 184.0;
trap_rig_z1 = 225.0;

// explicit receiver wall datums
// must match actual rear_buildout_perimeter() top/bottom bar extents
trap_buildout_wall_z0 = rear_guard_z1 - 38.0 - 4.0;
trap_buildout_wall_z1 = rear_guard_z1 + 4.0;

// grey solid nubs

trap_bottom_stop_y0 = wall_offset;
trap_bottom_stop_depth_y = 4;
trap_bottom_stop_y1 = trap_bottom_stop_y0 + trap_bottom_stop_depth_y;

trap_right_stop_y0 = wall_offset;
trap_right_stop_depth_y = 4.8;
trap_right_stop_y1 = trap_right_stop_y0 + trap_right_stop_depth_y;

trap_stop_w_x = 6.0;
trap_right_stop_trim_left_x = 2.0;
trap_stop_clear = 0.4;

trap_bottom_stop_h_z = 2.0;
trap_right_stop_h_z  = 3.0;
trap_right_stop_extra_top_z = 0.8;

module trap_rig_receiver_grey_nubs(){
    if(trap_receiver_on){

        // visual bottom-left locator / anti-drop stop
        // backside view: visual left = cassette +X
        translate([
            trap_rig_x1 - trap_stop_w_x,
           trap_bottom_stop_y0,
            trap_buildout_wall_z0
        ])
            cube([
                trap_stop_w_x,
                trap_bottom_stop_y1 - trap_bottom_stop_y0,
                trap_bottom_stop_h_z
            ]);
    }
}

// =========================================================
// TRAP RIG RECEIVER — L CAPTURE LIPS
// backside view: visual right = cassette -X
// =========================================================

trap_lip_on = true;

// Y pocket: leaves space for rig wall, then lip sits proud of it
trap_lip_slot_y = 1.80;
trap_lip_y_t    = 1.20;

trap_lip_y0 = wall_offset + rear_guard_wall_t + trap_lip_slot_y;
trap_lip_y1 = trap_lip_y0 + trap_lip_y_t;

// X/Z capture geometry
trap_lip_root_t   = 3.0;
trap_lip_overlap  = 2.4;

trap_lip_bottom_len_x = 9.0;
trap_lip_side_len_z   = 9.0;

// lower-right corner of rig wall
trap_lip_corner_x = trap_rig_x0;
trap_lip_corner_z = trap_buildout_wall_z0 + trap_lip_root_t;


module trap_rig_receiver_lower_right_lip(){
    if(trap_receiver_on && trap_lip_on){

        // bottom root strip
        translate([
            trap_lip_corner_x,
            wall_offset,
            trap_buildout_wall_z0
        ])
            cube([
                trap_lip_bottom_len_x,
                trap_lip_y0 - wall_offset,
                trap_lip_root_t
            ]);

        // side root strip
        translate([
            trap_lip_corner_x - trap_lip_root_t,
            wall_offset,
            trap_buildout_wall_z0
        ])
            cube([
                trap_lip_root_t,
                trap_lip_y0 - wall_offset,
                trap_lip_side_len_z
            ]);

        // bottom capture leg
        translate([
            trap_lip_corner_x,
            trap_lip_y0,
            trap_lip_corner_z - trap_lip_root_t
        ])
            cube([
                trap_lip_bottom_len_x,
                trap_lip_y1 - trap_lip_y0,
                trap_lip_root_t + trap_lip_overlap
            ]);

        // side capture leg
        translate([
            trap_lip_corner_x - trap_lip_root_t,
            trap_lip_y0,
            trap_lip_corner_z
        ])
            cube([
                trap_lip_root_t + trap_lip_overlap,
                trap_lip_y1 - trap_lip_y0,
                trap_lip_side_len_z
            ]);

// thin diagonal web filling the larger open L area
trap_lip_lower_diag_web_t_y = 1.0;

triangular_prism_y(
    [
        [trap_lip_corner_x + trap_lip_overlap,
         trap_lip_corner_z + trap_lip_overlap],

        [trap_lip_corner_x + trap_lip_bottom_len_x,
         trap_lip_corner_z + trap_lip_overlap],

        [trap_lip_corner_x + trap_lip_overlap,
         trap_lip_corner_z + trap_lip_side_len_z]
    ],
    trap_lip_y1 - trap_lip_lower_diag_web_t_y,
    trap_lip_y1
);

        //trap_lip_lower_friction_bump();
    }
}

module trap_rig_receiver_upper_right_lip(){
    if(trap_receiver_on && trap_lip_on){

        // top root strip
        translate([
            trap_lip_corner_x,
            wall_offset,
            trap_buildout_wall_z1 - trap_lip_root_t
        ])
            cube([
                trap_lip_bottom_len_x,
                trap_lip_y0 - wall_offset,
                trap_lip_root_t
            ]);

        // side root strip
        translate([
            trap_lip_corner_x - trap_lip_root_t,
            wall_offset,
            trap_buildout_wall_z1 - trap_lip_side_len_z
        ])
            cube([
                trap_lip_root_t,
                trap_lip_y0 - wall_offset,
                trap_lip_side_len_z
            ]);

        // top capture leg
        translate([
            trap_lip_corner_x,
            trap_lip_y0,
            trap_buildout_wall_z1 - trap_lip_overlap - trap_lip_root_t
        ])
            cube([
                trap_lip_bottom_len_x,
                trap_lip_y1 - trap_lip_y0,
                trap_lip_root_t + trap_lip_overlap
            ]);

        // side capture leg
        translate([
            trap_lip_corner_x - trap_lip_root_t,
            trap_lip_y0,
            trap_buildout_wall_z1 - trap_lip_side_len_z
        ])
            cube([
                trap_lip_root_t + trap_lip_overlap,
                trap_lip_y1 - trap_lip_y0,
                trap_lip_side_len_z
            ]);

        //trap_lip_upper_right_friction_bump();
    }
}

// =========================================================
// TRAP RIG RECEIVER — UPPER-LEFT TOP-ONLY SLIDE-IN LIP
// backside view: visual left = cassette +X
// Rig slides in from this side toward the brown capture side.
// Therefore this is top overhang only: no side capture.
// =========================================================

module trap_rig_receiver_upper_left_top_lip(){
    if(trap_receiver_on && trap_lip_on){

        // top root strip
        translate([
            trap_rig_x1 - trap_lip_bottom_len_x,
            wall_offset,
            trap_buildout_wall_z1 - trap_lip_root_t
        ])
            cube([
                trap_lip_bottom_len_x,
                trap_lip_y0 - wall_offset,
                trap_lip_root_t
            ]);

        // top capture leg only
        translate([
            trap_rig_x1 - trap_lip_bottom_len_x,
            trap_lip_y0,
            trap_buildout_wall_z1 - trap_lip_overlap - trap_lip_root_t
        ])
            cube([
                trap_lip_bottom_len_x,
                trap_lip_y1 - trap_lip_y0,
                trap_lip_root_t + trap_lip_overlap
            ]);

        //trap_lip_upper_left_friction_bump();
    }
}
// The former thin tank_rear_wall_triangle_web() has been absorbed into
// the full-width sloped reservoir body above.

clock_void_front_x_bar_on = true;

clock_void_front_x_bar_t_y = 1.0;
clock_void_front_x_bar_h_z = 4.0;

clock_void_front_x_bar_x0 = clock_left_access_cut_x0;
clock_void_front_x_bar_x1 = clock_left_access_cut_x1;

clock_void_front_x_bar_z =
    (clock_left_access_cut_z0 + clock_left_access_cut_z1) / 2;

module clock_void_front_x_bar(){
    if(clock_void_front_x_bar_on){
        translate([
            clock_void_front_x_bar_x0,
            true_full_y0,
            clock_void_front_x_bar_z
        ])
            cube([
                clock_void_front_x_bar_x1 - clock_void_front_x_bar_x0,
                clock_void_front_x_bar_t_y,
                clock_void_front_x_bar_h_z
            ]);
    }
}
// =========================================================
// VARIANT FEATURE GROUPS
// =========================================================

module dry_variant_additive_features(){
    // DRY-ONLY: actual clock mechanism holder / release-side hardware.
    // Includes sacrificial triangle supports for the dry clock retainer bar.
    clock_box_floor_stick();
    sacrificial_clock_retainer_supports();
    clock_negative_y_backstop_ring();
    right_thread_hook();
}

module dry_variant_subtractive_features(){
    // DRY-ONLY: retain the internal side-winding passage. Besides finger
    // clearance, this removes the unneeded intersecting chunks of the gusset
    // and square clock-retainer outline. The front skin itself stays closed.
    clock_internal_finger_access_void();

    // The only through-access in the front skin is the small string bore
    // disguised as the period in the website label.
    battery_isolator_pull_bore();
}

module wet_variant_additive_features(){
    // WET-ONLY: water reveal hardware.
    left_water_tank();
    if(wet_use_legacy_bucket){
        bucket_under_tank_tension_lips();
        bucket_retention_hook();
    }
    if(wet_use_integrated_pva_receiver)
        integrated_pva_receiver_solid();
    if(wet_use_integrated_pva_receiver)
        integrated_pva_hitch_pad();
    translate([
        spring_loop_catch_x,
        spring_loop_catch_y,
        spring_loop_catch_z
    ])
        spring_loop_catch();

    // The former mirrored wet-thread hook is intentionally omitted. The PVA
    // string now terminates at the reinforced two-hole cassette-wall bridge.
}

module wet_variant_subtractive_features(){
    // WET-ONLY: reservoir side fill bore through cassette wall.
    reservoir_side_fill_bore();
    if(wet_use_integrated_pva_receiver)
        integrated_pva_receiver_voids();
}

module cassette_body(){
    union(){
        difference(){
            union(){
                // ---------- shared cassette body ----------
                bottom_panel();

                // Contains the dry clock tab plus print_supports-gated scaffold/crossbar geometry.
                clock_movement_retainers();
                if(print_supports)
                    center_stack_pocket_sacrificial_posts();

                if(dry)
                    dry_variant_additive_features();

                rear_buildout_perimeter();
                trap_rig_receiver_grey_nubs();
                translate([
                    trap_lip_corner_x - trap_stop_w_x - trap_stop_clear + trap_right_stop_trim_left_x,
                    trap_right_stop_y0,
                    trap_buildout_wall_z0 + trap_lip_side_len_z - trap_right_stop_h_z + 3
                ])
                    cube([
                        trap_stop_w_x - trap_right_stop_trim_left_x,
                        trap_right_stop_y1 - trap_right_stop_y0,
                        trap_right_stop_h_z + trap_right_stop_extra_top_z
                    ]);
                trap_rig_receiver_lower_right_lip();
                trap_rig_receiver_upper_right_lip();
                trap_rig_receiver_upper_left_top_lip();
                if(wet)
                    wet_variant_additive_features();

                left_side_panel();
                right_side_panel();
                side_backing_clips();
                lower_board_hooks();
                if(print_supports) {
                    translate([50,0,0]) left_floor_corner_gusset();
                    translate([80,0,0]) left_floor_corner_gusset();
                }

                // NEUTRAL despite legacy clock-ish names: side/floor structural gussets.
                translate([112,0,0]) right_clock_stop_floor_gusset();
                translate([112,0,0]) right_clock_stop_rear_corner_gusset();

                top_cross_member();

               /* // Left-side mirrored thread hook raised to sit just below the roller receiver/cutout.
                left_thread_hook_raise_z = (roller_receiver_cz - roller_receiver_outer_r - 3.0) - (fang_main_z0 - 6.0);
                translate([wall_w, -3, left_thread_hook_raise_z])
                    mirror([1, 0, 0])
                        right_thread_hook();*/
                        //left_spring_coil_hook();
                //left_thread_string_tube();
                left_back_socket_assembly();
                right_back_socket_assembly();
                front_buildout_parts();
                // Local rear reinforcement under the debossed URL.
                front_website_backing();
            }
            acrylic_top_feed_cut();
            paper_load_top_slot_cut();
            // NEUTRAL: shallow molded-style recess across the bottom front.
            front_website_deboss();
            if(dry)
                dry_variant_subtractive_features();
            //left_thread_string_tube_void();
            if(wet)
                wet_variant_subtractive_features();
        }

        // DRY-ONLY optional print support; intentionally remains off to preserve current render.
        // if(dry) clock_void_front_x_bar();
    }
}
body_y_max=back_socket_front_y+retainer_pad_d;

module cassette_inverted(){translate([0,body_y_max,shell_inner_top_z])rotate([180,0,0])cassette_body();}

// Isolated fit review for the four backing-board side hooks. The upper pair
// is the same translated geometry as the lower pair, so all X pads are shown.
module backing_board_side_hook_fit_review(){
    lower_board_hooks();
    side_backing_clips();
}

module backing_board_single_hook_fit_review(){
    left_lower_board_hook();
}

module top_board_snap_lip_fit_review(){
    left_back_socket_assembly();
    right_back_socket_assembly();
}

module top_board_snap_lip_single_review(){
    left_back_socket_assembly();
}

module front_scaffold_contact_review(){
    clock_movement_retainers();
    if(print_supports)
        center_stack_pocket_sacrificial_posts();
    front_buildout_parts();
}

module center_stack_pocket_review(){
    clock_movement_retainers();
    center_stack_registration_pocket();
    center_stack_pocket_sacrificial_posts();
    intersection(){
        front_mask_plane();
        translate([
            center_stack_pocket_x0 - 4.0,
            front_buildout_y0 - eps,
            acrylic_shelf_z0 - 2.0
        ])
            cube([
                center_stack_pocket_w_x + 8.0,
                front_frame_t + center_stack_pocket_front_anchor_overlap_y
                    + 2*eps,
                center_stack_pocket_mouth_z1 - acrylic_shelf_z0 + 4.0
            ]);
    }
}

module center_stack_pocket_finished_review(){
    center_stack_registration_pocket();
    intersection(){
        front_mask_plane();
        translate([
            center_stack_pocket_x0 - 4.0,
            front_buildout_y0 - eps,
            acrylic_shelf_z0 - 2.0
        ])
            cube([
                center_stack_pocket_w_x + 8.0,
                front_frame_t + center_stack_pocket_front_anchor_overlap_y
                    + 2*eps,
                center_stack_pocket_mouth_z1 - acrylic_shelf_z0 + 4.0
            ]);
    }
}

// Export selector for the cassette, isolated receiver reviews, or the complete
// water system. Normal output is the cassette. Selector 2 was the former
// printable drain plug and is deliberately retired: use the specified
// commercial silicone snap-lock plug.
// 0 = cassette, 1 = receiver, 2 = retired, 3 = receiver cutaway,
// 4 = complete integrated water-system review,
// 5 = standalone tester in functional orientation,
// 6 = standalone tester in upside-down print orientation,
// 8 = all backing-board side hooks, 9 = one side-hook close review,
// 10 = both top hanging snap lips, 11 = front scaffold contacts,
// 12 = one top hanging snap lip close review,
// 13 = center acrylic/image pocket with removable support posts,
// 14 = same pocket after the posts are removed,
// 15 = isolated pocket plus its removable support posts
render_part = 0;
selected_render_part = is_undef(water_cassette_render_part)
    ? render_part
    : water_cassette_render_part;

assert(selected_render_part != 2,
       "render part 2 was retired; use the commercial silicone drain plug");

if(selected_render_part == 1)
    integrated_pva_receiver_finished();
else if(selected_render_part == 3)
    integrated_pva_receiver_cutaway();
else if(selected_render_part == 4)
    integrated_water_system_review();
else if(selected_render_part == 5)
    standalone_hydraulic_string_tester();
else if(selected_render_part == 6)
    standalone_hydraulic_string_tester_inverted();
else if(selected_render_part == 8)
    backing_board_side_hook_fit_review();
else if(selected_render_part == 9)
    backing_board_single_hook_fit_review();
else if(selected_render_part == 10)
    top_board_snap_lip_fit_review();
else if(selected_render_part == 11)
    front_scaffold_contact_review();
else if(selected_render_part == 12)
    top_board_snap_lip_single_review();
else if(selected_render_part == 13)
    center_stack_pocket_review();
else if(selected_render_part == 14)
    center_stack_pocket_finished_review();
else if(selected_render_part == 15)
    union(){
        center_stack_registration_pocket();
        if(print_supports)
            center_stack_pocket_sacrificial_posts();
    }
else
    union(){cassette_inverted();}
