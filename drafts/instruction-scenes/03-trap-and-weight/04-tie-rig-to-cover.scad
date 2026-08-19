include <weight-rig-common.scad>;

// Dedicated instruction scene viewed from the frame's open back.
// The finished relationship matters: punched paper, short tether, five weights.
difference() {
  color(cover_yellow) translate([0,31,0]) rounded_box([74,46,1.2], 2.0);
  translate([0,13,-1]) cylinder(h=4, r=2.6);
}

five_weight_rig([0,-17,1.6], steel_light);

// Short hitch/tether with two loose strands. This is an example route only.
string_segment([-1.2,13,1.2], [-2.2,1,3.2]);
string_segment([ 1.2,13,1.2], [ 2.2,1,3.2]);
string_segment([-2.2,1,3.2], [-5,-15,8.4]);
string_segment([ 2.2,1,3.2], [ 5,-15,8.4]);
string_segment([-5,-15,8.4], [-5,-23,7.8]);
string_segment([ 5,-15,8.4], [ 5,-23,7.8]);
