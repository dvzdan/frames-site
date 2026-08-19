include <weight-rig-common.scad>;

// Dedicated instruction scene viewed from the open back: simplified frame,
// roller, cover image, latch, and the new tied five-weight rig.
color(frame_gray) translate([0,0,-5]) rounded_box([100,100,4], 3);
color(active_blue) translate([-39,38,2]) rotate([0,90,0]) cylinder(h=78, r=5.5);
color(cover_yellow) translate([0,13,0]) rounded_box([72,57,1.2], 2);

color(receiver_yellow) translate([0,-19,3]) rounded_box([42,7,4], 1.3);
five_weight_rig([0,-10,7], steel_light);

// Tether rising from the completed rig to the punched Cover Image.
string_segment([-1.2,12,1.2], [-2,-1,10.5]);
string_segment([ 1.2,12,1.2], [ 2,-1,10.5]);

// The birch stick is positioned just beneath the roller lip.
color(birch) translate([0,12,8.4]) rounded_box([4.2,42,1.6], 0.55);
