// DOUBLE TAKE FRAMES DESIGN RELEASE
// DTF_RELEASE: 2.0.0
// Released: 2026-08-31
// Versioning: Semantic Versioning 2.0.0 (https://semver.org/)
// Status: CANONICAL
// Changes in 2.0.0:
// - Carried forward without geometry changes for the coordinated 2.0.0 release.
// Full release notes: https://doubletakeframes.com/build/#design-release
//
$fn = 128;

inch = 25.4;
eps = 0.05;

// =========================================================
// STANDALONE SEMICIRCLE ROLLER / GLIDE
// Concept variant: custom end shoes for +Y -> -Y insertion
// =========================================================
//
// Design intent of this variant:
// - The functional middle span remains the hollow semicircle glide.
// - The round roller is shortened at both ends.
// - Each end becomes a solid, capped, non-round keyed shoe.
// - The shoe is meant to slide +Y -> -Y into a simple clearanced receiver.
// - Receiver concept: bottom shelf + -Y stop + ceiling/side preload rib.
// - No arch, C-socket, latch, or wiper is required in this roller part.
//
// =========================================================


// ---------- cassette reference ----------

cassette_w = 6.91 * inch;
side_panel_t = 1.2;

// Total X clearance so roller is not hard wall-to-wall.
// 0.5 = about 0.25 mm per side if the roller is centered in the cassette.
roller_x_clearance_total = 0.5;

// Roller length inside cassette side panels, with clearance
roller_len_x = cassette_w - 2 * side_panel_t - roller_x_clearance_total;


// ---------- roller body ----------

tube_od = 0.84 * inch;
tube_r = tube_od / 2;

roller_shell_t = 1.2;


// ---------- raised UHMW tape lands ----------

uhmw_land_w_x = 0.5 * inch;
uhmw_land_raise = 0.4;

photo_w_nom = 5.0 * inch;

uhmw_land_centers_x = [
    roller_len_x/2 - photo_w_nom/3,
    roller_len_x/2,
    roller_len_x/2 + photo_w_nom/3
];


// ---------- new custom end shoe knobs ----------
//
// These replace the old small X-end tabs / round-end capture idea.
// The shoe is intentionally boring: a solid ramped plug with a flat bottom,
// a top lead-in ramp, a flat seated top, and a tiny top crush rib.
//
// Insertion direction is +Y -> -Y.
// The -Y edge is the leading edge that enters the receiver first.
//

end_shoe_x_len = 8.0;          // how much roller length is converted to keyed end shoe
end_cap_x_t = 1.2;             // solid cap thickness closing the functional shell near each shoe

end_shoe_y0 = -tube_r * 0.78;  // leading -Y edge of shoe
end_shoe_y1 =  tube_r * 0.78;  // trailing +Y edge of shoe

end_shoe_z_low = 1.2;          // low leading top at -Y edge
end_shoe_z = 5.0;              // seated/top plateau height
end_shoe_ramp_y = 4.5;         // Y distance over which top rises to plateau

// Tiny sacrificial/tolerance-takeup rib on the shoe top.
// Receiver ceiling can be plain/rigid; this rib wears/crushes in if needed.
end_shoe_top_rib_z = 0.00;
end_shoe_top_rib_y = 1.0;
end_shoe_top_rib_x_margin = 0.6;
end_shoe_top_rib_y_from_plus = 2.2;

// Optional low side pads at the bottom edges. These give a side receiver
// something simple to touch without trying to capture the round roller.
end_shoe_side_pad_z = 1.0;
end_shoe_side_pad_y = 0.8;


// ---------- sacrificial stacked Y-span rib knobs ----------

use_sacrificial_y_ribs = false;

sacrificial_y_rib_x_len = 1.2;
sacrificial_y_rib_t_z = 0.6;
sacrificial_y_rib_y_pad = 0.3;

// Keeps grill ribs slightly inside roller skin
sacrificial_y_rib_wall_inset = 0.20;

sacrificial_y_rib_z_levels = [0, 3.0, 6.0];

sacrificial_y_rib_positions_x = [
    roller_len_x * 0.40,
    roller_len_x * 0.60
];


// =========================================================
// BASIC GEOMETRY
// =========================================================

module half_shell(x0, x1, r) {
    intersection() {
        translate([x0, 0, 0])
            rotate([0, 90, 0])
                cylinder(
                    h = x1 - x0,
                    r = r,
                    center = false
                );

        // Keep only upper semicircle: z >= 0
        translate([
            x0 - eps,
            -r - eps,
            0
        ])
            cube([
                x1 - x0 + 2*eps,
                2*r + 2*eps,
                r + eps
            ]);
    }
}


module shell_band(x0, x1, outer_r) {
    difference() {
        half_shell(x0, x1, outer_r);

        translate([x0 - eps, 0, 0])
            rotate([0, 90, 0])
                cylinder(
                    h = x1 - x0 + 2*eps,
                    r = tube_r - roller_shell_t,
                    center = false
                );
    }
}


// Generic prism extruded along X from a Y/Z polygon.
module prism_x(x0, x1, yz_pts) {
    n = len(yz_pts);

    points = concat(
        [ for (p = yz_pts) [x0, p[0], p[1]] ],
        [ for (p = yz_pts) [x1, p[0], p[1]] ]
    );

    faces = concat(
        // x0 end face
        [[ for (i = [n-1 : -1 : 0]) i ]],

        // x1 end face
        [[ for (i = [0 : n-1]) n + i ]],

        // side faces
        [ for (i = [0 : n-1])
            [
                i,
                (i + 1) % n,
                n + ((i + 1) % n),
                n + i
            ]
        ]
    );

    polyhedron(points = points, faces = faces, convexity = 10);
}


module sacrificial_y_rib(xc, zc) {
    x0 = xc - sacrificial_y_rib_x_len/2;
    x1 = xc + sacrificial_y_rib_x_len/2;

    intersection() {
        // Oversized rectangular rib, then clipped to roller curve
        translate([
            x0,
            -tube_r - sacrificial_y_rib_y_pad,
            zc
        ])
            cube([
                x1 - x0,
                2*tube_r + 2*sacrificial_y_rib_y_pad,
                sacrificial_y_rib_t_z
            ]);

        // Clip to just inside the roller's curved outer wall
        half_shell(
            x0 - eps,
            x1 + eps,
            tube_r - sacrificial_y_rib_wall_inset
        );
    }
}


module sacrificial_y_ribs() {
    for (xc = sacrificial_y_rib_positions_x) {
        for (zc = sacrificial_y_rib_z_levels) {
            // Keep the sacrificial ribs only on the functional curved span.
            if (xc > end_shoe_x_len && xc < roller_len_x - end_shoe_x_len) {
                sacrificial_y_rib(xc, zc);
            }
        }
    }
}


// Solid half-disk cap near each shoe, closing the hollow functional shell.
module solid_half_cap(x0, x1) {
    half_shell(x0, x1, tube_r);
}


module end_shoe_prism(x0, x1) {
    yr = min(end_shoe_y0 + end_shoe_ramp_y, end_shoe_y1 - eps);

    yz = [
        [end_shoe_y0, 0],
        [end_shoe_y1, 0],
        [end_shoe_y1, end_shoe_z],
        [yr, end_shoe_z],
        [end_shoe_y0, end_shoe_z_low]
    ];

    prism_x(x0, x1, yz);
}


module end_shoe_top_crush_rib(x0, x1) {
    rib_x0 = x0 + end_shoe_top_rib_x_margin;
    rib_x1 = x1 - end_shoe_top_rib_x_margin;
    rib_y0 = end_shoe_y1 - end_shoe_top_rib_y_from_plus - end_shoe_top_rib_y;

    translate([
        rib_x0,
        rib_y0,
        end_shoe_z - eps
    ])
        cube([
            rib_x1 - rib_x0,
            end_shoe_top_rib_y,
            end_shoe_top_rib_z + eps
        ]);
}


module end_shoe_side_pads(x0, x1) {
    // Low -Y edge pad / optional receiver datum
    translate([x0, end_shoe_y0 - end_shoe_side_pad_y, 0])
        cube([
            x1 - x0,
            end_shoe_side_pad_y,
            end_shoe_side_pad_z
        ]);

    // Low +Y edge pad / optional receiver datum
    translate([x0, end_shoe_y1, 0])
        cube([
            x1 - x0,
            end_shoe_side_pad_y,
            end_shoe_side_pad_z
        ]);
}


module keyed_end_shoe(x0, x1) {
    union() {
        end_shoe_prism(x0, x1);
        end_shoe_top_crush_rib(x0, x1);
        end_shoe_side_pads(x0, x1);
    }
}


// =========================================================
// FINAL PART
// =========================================================

module roller_glide_standalone() {
    functional_x0 = end_shoe_x_len;
    functional_x1 = roller_len_x - end_shoe_x_len;

    union() {
        // Functional semicircle shell only in the middle span.
        // The old round ends are deliberately removed.
        shell_band(
            functional_x0,
            functional_x1,
            tube_r
        );

        // Solid caps closing the hollow shell at the start/end of the functional span.
        solid_half_cap(
            functional_x0,
            functional_x0 + end_cap_x_t
        );

        solid_half_cap(
            functional_x1 - end_cap_x_t,
            functional_x1
        );

        // Three normal raised tape lands, unchanged in the functional center area.
        for (xc = uhmw_land_centers_x) {
            shell_band(
                xc - uhmw_land_w_x/2,
                xc + uhmw_land_w_x/2,
                tube_r + uhmw_land_raise
            );
        }

        // Thin sacrificial ribs spanning Y, still only on the curved functional span.
        if (use_sacrificial_y_ribs) {
            sacrificial_y_ribs();
        }

        // New non-round end shoes.
        keyed_end_shoe(
            0,
            end_shoe_x_len
        );

        keyed_end_shoe(
            roller_len_x - end_shoe_x_len,
            roller_len_x
        );
    }
}


roller_glide_standalone();
