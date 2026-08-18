// Young Town / 12888-style CANON capstan pair.
// Minute remains canon at 3.58 mm. Hour is now a candidate set.
//
//   MINUTE capstan: 3.58 mm top bore
//   HOUR candidates: 5.15 mm straight bore
//
// This file renders one minute capstan plus hour candidates.
//
// Intended stack model:
// - top smaller rotating post = minute output
// - middle larger sleeve = hour output
// - bottom collar/boss = stationary guide, avoid clamping it
//
// Both capstans use:
// - flipped-trapezoid string eyelet on +Y
// - top indicator horn / gnomon also on +Y, aligned with the string eyelet/thread hole
// - geometry tuned for 0.4 mm nozzle and fishing line

$fn = 32;
eps = 0.05;

// ---------- selected fits ----------

minute_bore_d = 3.35;          // selected minute fit
hour_bores    = [5.15];        // current hour candidate/canon

minute_lower_clearance_d = 5.92;   // clears large/snap-family hour sleeve
minute_tight_bore_h      = 2.0;    // upper grip length on minute post

// ---------- capstan geometry ----------

total_h  = 5.0;
flange_h = 0.80;

drum_d   = 7.4;
flange_d = 9.0;

// small bottom-only flare to forgive first-layer roughness
bore_mouth_extra = 0.35;
bore_mouth_h     = 0.55;

// pair layout
part_spacing_x = 14;

// ---------- string eyelet geometry ----------

string_eyelet_enabled = true;

// required clearance from top/bottom flange faces
string_eyelet_flange_gap_z = 0.60;

// width around the capstan circumference
string_eyelet_w_x = 1.8;

// overlap into drum for fusion
string_eyelet_drum_overlap_y = 0.20;

// protrusion beyond flange radius; keep small for boss-guide clearance
string_eyelet_beyond_flange_y = 1.2;

// flipped trapezoid: tall face at drum, shorter face outside
// Slightly taller than prior version to open the thread hole.
string_eyelet_inner_face_h_z = 2.35;
string_eyelet_outer_face_h_z = 1.85;

// printable walls around eyelet void
// Reduced cautiously for easier threading with fishing line.
string_eyelet_wall_z = 0.35;
string_eyelet_outer_wall_y = 0.8;

// lets void reach cleanly to drum-side of eyelet without cutting actual drum
string_eyelet_void_inset_y = 0.70;

// ---------- top indicator horn ----------

indicator_horn_enabled = true;

// Horn is now aligned with the +Y string eyelet/thread hole.
// It lives on the top rim in the same radial direction as the eyelet.
indicator_horn_inner_y = 3.05;
indicator_horn_outer_y = 4.25;
indicator_horn_w_x     = 0.90;
indicator_horn_h_z     = 1.00;
indicator_horn_taper_y = 0.30;


// ---------- helpers ----------

module cyl(d, h, z=0) {
    translate([0,0,z])
        cylinder(d=d, h=h);
}

// Prism extruded along X from a 2D Y/Z polygon.
// points_yz must be ordered around the polygon perimeter.
module prism_x(points_yz, w_x) {
    n = len(points_yz);

    polyhedron(
        points = concat(
            [for (p = points_yz) [-w_x/2, p[0], p[1]]],
            [for (p = points_yz) [ w_x/2, p[0], p[1]]]
        ),
        faces = concat(
            [[for (i = [n-1:-1:0]) i]],
            [[for (i = [0:n-1]) i + n]],
            [for (i = [0:n-1])
                [i, (i + 1) % n, ((i + 1) % n) + n, i + n]
            ]
        )
    );
}


// ---------- top indicator horn ----------

module top_indicator_horn() {
    if (indicator_horn_enabled) {
        // Thin vertical fin / gnomon on the top flange rim.
        // Aligned with the +Y string eyelet/thread hole.
        prism_x(
            [
                [indicator_horn_inner_y, total_h],
                [indicator_horn_outer_y, total_h],
                [indicator_horn_outer_y - indicator_horn_taper_y, total_h + indicator_horn_h_z],
                [indicator_horn_inner_y, total_h + indicator_horn_h_z]
            ],
            indicator_horn_w_x
        );
    }
}


// ---------- flipped trapezoid string eyelet ----------

function eyelet_channel_z0() =
    flange_h + string_eyelet_flange_gap_z;

function eyelet_channel_z1() =
    total_h - flange_h - string_eyelet_flange_gap_z;

function eyelet_mid_z() =
    total_h / 2;

function eyelet_inner_y() =
    drum_d/2 - string_eyelet_drum_overlap_y;

function eyelet_outer_y() =
    flange_d/2 + string_eyelet_beyond_flange_y;

function eyelet_inner_z0() =
    eyelet_mid_z() - string_eyelet_inner_face_h_z/2;

function eyelet_inner_z1() =
    eyelet_mid_z() + string_eyelet_inner_face_h_z/2;

function eyelet_outer_z0() =
    eyelet_mid_z() - string_eyelet_outer_face_h_z/2;

function eyelet_outer_z1() =
    eyelet_mid_z() + string_eyelet_outer_face_h_z/2;

function eyelet_void_inner_y() =
    drum_d/2 - string_eyelet_void_inset_y;

function eyelet_void_outer_y() =
    eyelet_outer_y() - string_eyelet_outer_wall_y;

function eyelet_void_inner_z0() =
    eyelet_inner_z0() + string_eyelet_wall_z;

function eyelet_void_inner_z1() =
    eyelet_inner_z1() - string_eyelet_wall_z;

function eyelet_void_outer_z0() =
    eyelet_outer_z0() + string_eyelet_wall_z;

function eyelet_void_outer_z1() =
    eyelet_outer_z1() - string_eyelet_wall_z;

module flipped_trapezoid_eyelet_solid_body() {
    intersection() {
        prism_x(
            [
                [eyelet_inner_y(), eyelet_inner_z0()],
                [eyelet_outer_y(), eyelet_outer_z0()],
                [eyelet_outer_y(), eyelet_outer_z1()],
                [eyelet_inner_y(), eyelet_inner_z1()]
            ],
            string_eyelet_w_x
        );

        // hard Z clip to keep eyelet between flange faces
        translate([0, 0, total_h/2])
            cube(
                [
                    flange_d + 2,
                    flange_d + 2,
                    eyelet_channel_z1() - eyelet_channel_z0()
                ],
                center=true
            );
    }
}

module flipped_trapezoid_eyelet_inner_polygon_void() {
    // Subtracted only from eyelet body, not from capstan/drum.
    prism_x(
        [
            [eyelet_void_inner_y(), eyelet_void_inner_z0()],
            [eyelet_void_outer_y(), eyelet_void_outer_z0()],
            [eyelet_void_outer_y(), eyelet_void_outer_z1()],
            [eyelet_void_inner_y(), eyelet_void_inner_z1()]
        ],
        string_eyelet_w_x + 2*eps
    );
}

module polygon_cut_flipped_trapezoid_eyelet() {
    difference() {
        flipped_trapezoid_eyelet_solid_body();
        flipped_trapezoid_eyelet_inner_polygon_void();
    }
}


// ---------- shared shell ----------

module capstan_shell() {
    union() {
        // center winding drum
        cyl(drum_d, total_h);

        // bottom retaining flange
        cyl(flange_d, flange_h);

        // top retaining flange
        cyl(flange_d, flange_h, total_h - flange_h);

        // string eyelet on +Y side
        if (string_eyelet_enabled)
            polygon_cut_flipped_trapezoid_eyelet();

        // top indicator horn aligned with +Y string eyelet
        top_indicator_horn();
    }
}


// ---------- final capstans ----------

module minute_capstan() {
    lower_h = total_h - minute_tight_bore_h;

    difference() {
        capstan_shell();

        // Lower clearance cavity over the hour sleeve.
        translate([0,0,-eps])
            cylinder(d=minute_lower_clearance_d, h=lower_h + eps);

        // Small bottom mouth easing.
        translate([0,0,-eps])
            cylinder(d=minute_lower_clearance_d + bore_mouth_extra, h=bore_mouth_h + eps);

        // Upper tight minute-shaft grip.
        translate([0,0,lower_h])
            cylinder(d=minute_bore_d, h=minute_tight_bore_h + eps);
    }
}

module hour_capstan(bore_d=5.15) {
    difference() {
        capstan_shell();

        // Straight hour-sleeve press-fit bore.
        translate([0,0,-eps])
            cylinder(d=bore_d, h=total_h + 2*eps);

        // Small bottom mouth easing.
        translate([0,0,-eps])
            cylinder(d=bore_d + bore_mouth_extra, h=bore_mouth_h + eps);
    }
}


// ---------- render minute + hour candidates ----------

// Leftmost: minute canon 3.58.
//translate([0, 0, 0])
    minute_capstan();

// Hour candidates.
for (i = [0:len(hour_bores)-1]) {
    translate([(i + 1) * part_spacing_x, 0, 0])
        hour_capstan(hour_bores[i]);
}
