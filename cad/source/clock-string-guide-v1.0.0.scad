// DOUBLE TAKE FRAMES DESIGN RELEASE
// DTF_RELEASE: 1.0.0
// Released: 2026-08-30
// Versioning: Semantic Versioning 2.0.0 (https://semver.org/)
// Status: CANONICAL
// Changes in 1.0.0:
// - Initial versioned public design release.
// - Establishes the current accepted geometry as the 1.x compatibility baseline.
// Full release notes: https://doubletakeframes.com/build/#design-release
//
// =========================================================
// SEPARATE OBJECT: CLOCK +Y PRESSURE BAR TEST
// Horizontal tension-fit bar.
// Pressure is at X ends.
// Center winding-nub clearance hole.
// Integrated string-feed boss with vertical hole.
// =========================================================

$fn = 64;
eps = 0.05;

// ---------- bar knobs ----------

clock_bar_len_x = 58.5;
clock_bar_t_y   = 3.0;
clock_bar_h_z   = 21.0;

clock_bar_hole_d = 15;
clock_bar_hole_z_offset = -.06;   // negative = lower, positive = higher

// chamfered X-end corners, seen from TOP VIEW
// max useful value is just under clock_bar_t_y/2
end_chamfer_y = 1.2;


// ---------- integrated string-feed boss ----------
// Bigger boss, kept just at +Y rim of center hole

string_boss_w_x = 6.0;
string_boss_d_y = 4.0;
string_boss_h_z = 1.6;

string_hole_d = 2.5;

string_boss_xc = 0;

// front face sits at +Y rim of center hole
string_boss_y0 = clock_bar_t_y/2 - 0.2;

string_boss_z0 = clock_bar_h_z/2 - string_boss_h_z;

string_hole_xc = string_boss_xc;
string_hole_yc = string_boss_y0 + string_boss_d_y/2;

// =========================================================

module chamfered_bar_body(){

    linear_extrude(height = clock_bar_h_z, center = true)
        polygon(points = [
            // bottom / -Y edge, with chamfered insertion corners
            [-clock_bar_len_x/2 + end_chamfer_y, -clock_bar_t_y/2],
            [ clock_bar_len_x/2 - end_chamfer_y, -clock_bar_t_y/2],

            // right / +X end
            [ clock_bar_len_x/2, -clock_bar_t_y/2 + end_chamfer_y],
            [ clock_bar_len_x/2,  clock_bar_t_y/2],

            // top / +Y edge stays square
            [-clock_bar_len_x/2,  clock_bar_t_y/2],

            // left / -X end
            [-clock_bar_len_x/2, -clock_bar_t_y/2 + end_chamfer_y]
        ]);
}

module clock_pressure_bar(){

    difference(){

        union(){

            // main bar with true X-end corner chamfers
            chamfered_bar_body();

            // integrated +Y string-feed boss
            translate([
                string_boss_xc - string_boss_w_x/2,
                string_boss_y0,
                string_boss_z0
            ])
                cube([
                    string_boss_w_x,
                    string_boss_d_y,
                    string_boss_h_z
                ]);
        }

// center hole for winding nub, through Y
translate([0, 0, clock_bar_hole_z_offset])
    rotate([90,0,0])
        cylinder(
            h = clock_bar_t_y + string_boss_d_y + 2,
            d = clock_bar_hole_d,
            center = true
        );

// kill/open everything below the hole diameter
translate([
    -clock_bar_hole_d/2 - eps,
    -clock_bar_t_y/2 - string_boss_d_y - eps,
    -clock_bar_h_z/2 - eps
])
    cube([
        clock_bar_hole_d + 2*eps,
        clock_bar_t_y + string_boss_d_y + 2*eps,
        clock_bar_h_z/2 + clock_bar_hole_z_offset + eps
    ]);

        // vertical string-feed hole
        translate([
            string_hole_xc,
            string_hole_yc,
            string_boss_z0 - 0.4
        ])
            cylinder(
                h = string_boss_h_z + 0.8 + 2*eps,
                d = string_hole_d,
                center = false
            );
    }
}

clock_pressure_bar();
