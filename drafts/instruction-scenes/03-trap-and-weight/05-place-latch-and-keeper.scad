include <weight-rig-common.scad>;

// Dedicated instruction scene: simplified open-back receiver context.
color(frame_gray) translate([0,0,-3]) rounded_box([94,58,3], 2);
color(receiver_yellow) translate([0,3,1]) rounded_box([58,34,4], 2);

// Zipper head and latch are the active moving parts.
color([0.12,0.68,0.30]) translate([-28,-5,4]) rounded_box([24,8,4], 1.3);
color(active_blue) translate([0,-2,6]) rounded_box([50,6,4], 1.3);
color([0.92,0.19,0.16]) translate([25,-2,6]) difference() {
  cylinder(h=4, r=7);
  translate([0,0,-1]) cylinder(h=6, r=3.5);
  translate([3.5,-2,-1]) cube([8,4,6]);
}

// Ghosted new rig shows what the latch will support without implying old geometry.
weight_pair([0,18,9], ghost_blue);
weight_pair([0,18,12.4], ghost_blue);
birch_stick([0,32,10.7], 38, ghost_blue);
weight_segment([0,18,15.8], ghost_blue);
