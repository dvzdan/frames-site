$fn = 96;

inch = 25.4;
eps  = 0.05;

// =========================================================
// LATCH / STICK
// =========================================================
post_d       = 5.5;
clear_radial = 0.22;
eye_inner_d  = post_d + 2 * clear_radial;

latch_t    = 3.0;          // Y thickness
bar_up     = 2.5;
bar_t      = latch_t + bar_up;

eye_outer_d = 13.0;

arm_len = 1.5 * inch;      // X length
arm_w   = 6.0;             // Z width
bottom_relief = 0.8;
bottom_y_round = 0.6;

tip_len = 2.0;
tip_w   = 6.0;

// =========================================================
// C-SHAPED KEEPER / CLIP
// =========================================================
clip_outer_d = 10.0;
clip_t       = 1.8;        // Y thickness

grip_hole_d = 4.65;
gap_w       = 2.8;         // Z opening
flat_depth  = 1.5;         // X flat cut depth

// =========================================================
// HELPERS
// =========================================================
module rect_prism(x0, x1, y0, y1, z0, z1) {
    translate([x0, y0, z0])
        cube([x1 - x0, y1 - y0, z1 - z0]);
}

module cyl_y(d, y0, h, fn = $fn) {
    r = d / 2;
    y1 = y0 + h;

    bottom = [
        for (i = [0 : fn - 1])
            [r * cos(360 * i / fn), y0, r * sin(360 * i / fn)]
    ];

    top = [
        for (i = [0 : fn - 1])
            [r * cos(360 * i / fn), y1, r * sin(360 * i / fn)]
    ];

    points = concat(bottom, top, [[0, y0, 0], [0, y1, 0]]);
    c0 = 2 * fn;
    c1 = 2 * fn + 1;

    side_faces = [
        for (i = [0 : fn - 1])
            let(n = (i + 1) % fn)
            [i, n, fn + n, fn + i]
    ];

    bottom_faces = [
        for (i = [0 : fn - 1])
            let(n = (i + 1) % fn)
            [c0, n, i]
    ];

    top_faces = [
        for (i = [0 : fn - 1])
            let(n = (i + 1) % fn)
            [c1, fn + i, fn + n]
    ];

    polyhedron(
        points = points,
        faces  = concat(side_faces, bottom_faces, top_faces),
        convexity = 10
    );
}

// =========================================================
// OBJECT 1: SWINGING LATCH / STICK
// centered around pivot at x=0, z=0
// extends left in -X
// =========================================================
module swinging_latch() {
    difference() {
        union() {
            cyl_y(eye_outer_d, 0, latch_t);

            rect_prism(
                -(eye_outer_d/2 - 0.5 + arm_len),
                -(eye_outer_d/2 - 0.5),
                 0,
                 bar_t,
                -arm_w/2,
                 arm_w/2
            );

            hull() {
                rect_prism(
                    -(eye_outer_d/2 - 0.5 + arm_len),
                    -(eye_outer_d/2 - 0.5 + arm_len - tip_len),
                     0,
                     bar_t,
                    -tip_w/2,
                     tip_w/2
                );

                rect_prism(
                    -(eye_outer_d/2 - 0.5 + arm_len - tip_len),
                    -(eye_outer_d/2 - 0.5 + arm_len - tip_len) + 0.1,
                     0,
                     bar_t,
                    -arm_w/2,
                     arm_w/2
                );
            }
        }

        cyl_y(eye_inner_d, -0.1, latch_t + 0.2);

        // underside chamfer on arm only
        translate([
            -(eye_outer_d/2 - 0.5 + arm_len) - 1,
            -0.1,
            -arm_w/2 - 0.01
        ])
        rotate([0,45,0])
        cube([
            arm_len + 4,
            bar_t + 1,
            bottom_relief * 2
        ]);

        // same chamfer mirrored onto top side
        mirror([0,0,1])
        translate([
            -(eye_outer_d/2 - 0.5 + arm_len) - 1,
            -0.1,
            -arm_w/2 - 0.01
        ])
        rotate([0,45,0])
        cube([
            arm_len + 4,
            bar_t + 1,
            bottom_relief * 2
        ]);

        // soften lower Y edges of latch bottom
        for (yy = [0, bar_t]) {
            translate([
                -(eye_outer_d/2 - 0.5 + arm_len/2),
                yy,
                -arm_w/2
            ])
            rotate([0,90,0])
            cylinder(
                h = arm_len + 2,
                r = bottom_y_round,
                center = true
            );
                    // soften upper Y edges of latch top
        for (yy = [0, bar_t]) {
            translate([
                -(eye_outer_d/2 - 0.5 + arm_len/2),
                yy,
                arm_w/2
            ])
            rotate([0,90,0])
            cylinder(
                h = arm_len + 2,
                r = bottom_y_round,
                center = true
            );
        }
        }
    }
}

// =========================================================
// OBJECT 2: C-SHAPED KEEPER / CLIP
// =========================================================
module c_keeper() {
    difference() {
        cyl_y(clip_outer_d, 0, clip_t);

        cyl_y(grip_hole_d, -0.1, clip_t + 0.2);

        rect_prism(
            0,
            clip_outer_d/2 + 0.5,
            -0.1,
            clip_t + 0.1,
           -gap_w/2,
            gap_w/2
        );

        rect_prism(
            grip_hole_d/2 - 0.2,
            grip_hole_d/2 - 0.2 + flat_depth,
            -0.1,
            clip_t + 0.1,
           -gap_w/2 - 0.4,
            gap_w/2 + 0.4
        );
    }
}

// Preview separated
translate([0, 0, 0])
    swinging_latch();

translate([20, 0, 0])
    c_keeper();