// Instruction scene: press the captive clock string guide onto the clock spindle.
// The guide is installed before either capstan, so no capstan geometry appears.

use <../../../cad/pending-canon/clock-string-guide-captive-v1.1.0-rc.1.scad>

$fn = 72;

guide_blue = [0.08, 0.35, 0.92];
guide_ghost = [0.08, 0.35, 0.92, 0.16];
clock_dark = [0.15, 0.16, 0.18];
clock_edge = [0.28, 0.29, 0.31];
rig_gray = [0.48, 0.50, 0.53, 0.42];
metal = [0.72, 0.66, 0.48];
spindle_white = [0.92, 0.90, 0.82];

module clock_body() {
    color(clock_dark)
        translate([-27, -17, -30])
            cube([54, 16, 54]);

    color(clock_edge)
        translate([-25, -0.9, -28])
            cube([50, 1.1, 50]);

    // Brass collar and white spindle extend from the clock face along +Y.
    color(metal)
        rotate([-90, 0, 0])
            cylinder(d=12, h=4);

    color(spindle_white)
        translate([0, 3.8, 0])
            rotate([-90, 0, 0])
                cylinder(d=7, h=18);

    color([0.55, 0.55, 0.55])
        translate([0, 21.6, 0])
            rotate([-90, 0, 0])
                cylinder(d=3.2, h=3.6);
}

module nearby_rig_context() {
    color(rig_gray)
        translate([-45, -22, -38])
            cube([90, 3, 70]);

    color([0.48, 0.50, 0.53, 0.22]) {
        translate([-45, -19, 24]) cube([12, 18, 8]);
        translate([33, -19, 24]) cube([12, 18, 8]);
    }
}

nearby_rig_context();
clock_body();

// Final seated position is contextual only.
color(guide_ghost)
    translate([0, 1.8, 0])
        clock_pressure_bar();

// Active guide is aligned over the spindle and offset along +Y for the press.
color(guide_blue)
    translate([0, 16, 0])
        clock_pressure_bar();
