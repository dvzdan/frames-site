// DOUBLE TAKE FRAMES DESIGN RELEASE
// DTF_RELEASE: 3.0.0
// Released: 2026-09-24
// Versioning: Semantic Versioning 2.0.0 (https://semver.org/)
// Status: CANONICAL
// Changes in 3.0.0:
// - Carried forward unchanged for the clipless keyed wall-rig and latch release.
// Changes in 2.0.4:
// - Uses the selected 5.05 mm hour-capstan bore for firmer retention.
// - Paired with the adjusted clock-string guide candidate.
// - Replaces the external eyelets with matching side-loaded flange hitches.
// - Moves the minute gripping-bore transition from 3.0 to 1.5 mm so the
//   minute sleeve engages sooner without changing the external envelope.
// - Removes the obsolete minute orientation mark and hour indicator horn.
// - Retains the successful 6.0 mm minute envelope while extending only the
//   hour capstan's upper side to 7.2 mm for a more generous shared guide gap.
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
// Both capstans use the same 16 mm flange/drum shell and matching side-loaded
// hitch geometry. Their internal bores remain specialized for their respective
// rotating clock sleeves.

$fn = 32;
eps = 0.05;

// Selected printed fits. These modeled bores deliberately
// differ from the supplied movement-member ODs: 3.17 mm inner and 5.05 mm
// middle. They are fit dimensions, not transcriptions of movement specs.
minute_bore_d = is_undef(shared_minute_capstan_bore_d)
    ? 3.40 : shared_minute_capstan_bore_d;
hour_bores = [5.05];
minute_lower_clearance_d = 5.92;
minute_lower_clearance_h = 1.5; // 4.5 mm grip; earlier than the former 3.0 mm transition.

// Main geometry.
canonical_total_h = 5.0;
minute_total_h = is_undef(shared_capstan_total_h)
    ? 6.0 : shared_capstan_total_h;
hour_total_h = is_undef(shared_hour_capstan_total_h)
    ? 7.2 : shared_hour_capstan_total_h;
flange_h = 0.80;
drum_d = 7.4; // Printed winding-drum OD; unrelated to movement sleeve specs.
flange_d = is_undef(shared_capstan_flange_d)
    ? 16.0 : shared_capstan_flange_d; // MOCKUP: canonical is 9.0
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

// Side-loaded fishing-line hitch. Both openings are loaded from the rim, so
// the user never has to feed a line end through a small hole. After one turn
// around the drum, lace the line around the solid bridge and park it in the
// tapered cleat.
guide_hole_d = 1.50;
cleat_bulb_d = 1.60;
side_slot_w = 0.90;
cleat_root_w = 0.95;
cleat_tip_w = 0.10; // CAD closure; the slicer determines the printable nip.
feature_radius = 5.70;
cleat_taper_len = 2.00; // Clearly resolved taper with a 0.4 mm nozzle.
// The bottom-flange horseshoe notch is centered at +Y. The smooth top-flange
// entry shares that angular datum. The cleat is spread 90 degrees away, while
// its short local taper points toward the guide without approaching the bore.
guide_angle = 90;
cleat_angle = 0;

// ---------- sacrificial print supports ----------

breakaway_supports_enabled = false;
breakaway_support_count = 6;
breakaway_post_radius = 7.3;
breakaway_body_d = 1.2;
breakaway_neck_d = 0.65;
breakaway_neck_h = 0.30;

module cyl(d, h, z=0) {
    translate([0, 0, z]) cylinder(d=d, h=h);
}

function vadd(a,b) = [a[0]+b[0],a[1]+b[1]];
function vsub(a,b) = [a[0]-b[0],a[1]-b[1]];
function vmul(a,s) = [a[0]*s,a[1]*s];
function vlen(a) = sqrt(a[0]*a[0]+a[1]*a[1]);
function vunit(a) = let(n=vlen(a)) [a[0]/n,a[1]/n];
function polar(r,a) = [r*cos(a),r*sin(a)];

guide_center = polar(feature_radius,guide_angle);
cleat_center = polar(feature_radius,cleat_angle);
cleat_to_guide = vunit(vsub(guide_center,cleat_center));
cleat_tip = vadd(cleat_center,vmul(cleat_to_guide,cleat_taper_len));

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

module capstan_shell(part_h) {
    difference() {
        union() {
            cyl(drum_d, part_h);
            cyl(flange_d, flange_h);
            cyl(flange_d, flange_h, part_h-flange_h);
        }
        bottom_insertion_notch();
    }
}

module rim_slot(center, slot_w=side_slot_w) {
    radial = vunit(center);
    beyond_rim = vmul(radial, flange_d/2+slot_w);
    linear_extrude(height=flange_h+2*eps)
        hull() {
            translate(center) circle(d=slot_w);
            translate(beyond_rim) circle(d=slot_w);
        }
}

module guide_opening_cut(part_h) {
    z0 = part_h-flange_h-eps;
    translate([guide_center[0],guide_center[1],z0])
        cylinder(d=guide_hole_d,h=flange_h+2*eps);
    translate([0,0,z0]) rim_slot(guide_center);
}

module tapered_segment(p0,p1,w0,w1) {
    direction = vunit(vsub(p1,p0));
    normal = [-direction[1],direction[0]];
    polygon([
        vadd(p0,vmul(normal,w0/2)),
        vsub(p0,vmul(normal,w0/2)),
        vsub(p1,vmul(normal,w1/2)),
        vadd(p1,vmul(normal,w1/2))
    ]);
}

module cleat_opening_cut(part_h) {
    z0 = part_h-flange_h-eps;
    local_tip = vsub(cleat_tip,cleat_center);
    taper_root = vmul(cleat_to_guide,cleat_bulb_d*0.25);

    translate([cleat_center[0],cleat_center[1],z0])
        linear_extrude(height=flange_h+2*eps)
            union() {
                circle(d=cleat_bulb_d);
                tapered_segment(taper_root,local_tip,
                                cleat_root_w,cleat_tip_w);
            }

    translate([0,0,z0]) rim_slot(cleat_center);
}

module top_side_load_hitch_cuts(part_h) {
    guide_opening_cut(part_h);
    cleat_opening_cut(part_h);
}

module minute_capstan() {
    difference() {
        capstan_shell(minute_total_h);
        translate([0, 0, -eps])
            cylinder(d=minute_lower_clearance_d,
                     h=minute_lower_clearance_h+2*eps);
        translate([0, 0, -eps])
            cylinder(d=minute_lower_clearance_d+bore_mouth_extra, h=bore_mouth_h+eps);
        translate([0, 0, minute_lower_clearance_h])
            cylinder(d=minute_bore_d,
                     h=minute_total_h-minute_lower_clearance_h+eps);
        top_side_load_hitch_cuts(minute_total_h);
    }
}

module hour_capstan(bore_d=5.05) {
    difference() {
        capstan_shell(hour_total_h);
        translate([0, 0, -eps])
            cylinder(d=bore_d, h=hour_total_h+2*eps);
        translate([0, 0, -eps])
            cylinder(d=bore_d+bore_mouth_extra, h=bore_mouth_h+eps);
        top_side_load_hitch_cuts(hour_total_h);
    }
}

module breakaway_post(angle, part_h) {
    post_xy = [
        breakaway_post_radius*cos(angle),
        breakaway_post_radius*sin(angle)
    ];
    lower_flange_z1 = flange_h;
    upper_flange_z0 = part_h-flange_h;
    body_z0 = lower_flange_z1+breakaway_neck_h;
    body_z1 = upper_flange_z0-breakaway_neck_h;

    // Bottom snip neck, short rigid body, and top snip neck. The body remains
    // at the accessible outer edge and clear of the functional geometry.
    translate([post_xy[0], post_xy[1], lower_flange_z1-eps])
        cylinder(d=breakaway_neck_d, h=breakaway_neck_h+eps);
    translate([post_xy[0], post_xy[1], body_z0-eps])
        cylinder(d=breakaway_body_d, h=body_z1-body_z0+2*eps);
    translate([post_xy[0], post_xy[1], body_z1])
        cylinder(d=breakaway_neck_d, h=breakaway_neck_h+eps);
}

module breakaway_post_set(part_h) {
    if (breakaway_supports_enabled)
        for (i=[0:breakaway_support_count-1])
            breakaway_post(i*360/breakaway_support_count, part_h);
}

module minute_capstan_print_layout() {
    // Print the side-load flange face on the bed so the lower cavity stays open.
    translate([0, 0, minute_total_h])
        rotate([180, 0, 0])
            minute_capstan();
    breakaway_post_set(minute_total_h);
}

module hour_capstan_print_layout(bore_d=5.05) {
    // Match the necessary minute-capstan orientation: hitch face on the bed.
    translate([0, 0, hour_total_h])
        rotate([180, 0, 0])
            hour_capstan(bore_d);
    breakaway_post_set(hour_total_h);
}

// Render minute + hour, matching the canonical file's deliverable pattern.
minute_capstan_print_layout();
for (i=[0:len(hour_bores)-1])
    translate([(i+1)*part_spacing_x, 0, 0])
        hour_capstan_print_layout(hour_bores[i]);
