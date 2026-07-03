/*
  Manual proxy block language

  This is a manual-diagram proxy language for assembly-guide illustrations.
  It intentionally avoids realistic geometry and exact simplified copies of
  the real mechanism. The goal is to give Codex a constrained set of named
  rectangular primitives for assembling consistent LEGO-like proxy diagrams.

  Future functional colors will be assigned later in the manual/design system.
  For now these modules use the default OpenSCAD material/color.

  Proxy parts must still align and fit in simplified 2.5D coordinates.
*/

proxy_eps = 0.02;
proxy_base_t = 3.0;
proxy_relief_h = 1.5;
proxy_detail_h = 0.6;
proxy_fin_h = 5.0;
proxy_edge_t = 2.0;

module proxy_plate(x, y, w, h, t=2) {
  translate([x, y, 0]) cube([w, h, t]);
}

module proxy_block(x, y, w, h, z=0, ht=2) {
  translate([x, y, z]) cube([w, h, ht]);
}

// Cutter volume for use inside difference(); this is not visible geometry.
module proxy_cutout(x, y, w, h, z=-0.05, ht=100) {
  translate([x, y, z]) cube([w, h, ht]);
}

module proxy_nub(x, y, w, h, z=0, ht=2) {
  proxy_block(x, y, w, h, z, ht);
}

module proxy_ledge(x, y, w, h, z=0, ht=1) {
  proxy_block(x, y, w, h, z, ht);
}

module proxy_fin(x, y, w, h, z=0, ht=5) {
  proxy_block(x, y, w, h, z, ht);
}

module proxy_rail(x, y, w, h, z=0, ht=3) {
  proxy_block(x, y, w, h, z, ht);
}

module proxy_detail(x, y, w, h, z=0, ht=0.6) {
  proxy_block(x, y, w, h, z, ht);
}

module proxy_outer_frame(panel_w, panel_h, edge_t=2, z=2, ht=1) {
  proxy_block(0, 0, panel_w, edge_t, z, ht);
  proxy_block(0, panel_h - edge_t, panel_w, edge_t, z, ht);
  proxy_block(0, edge_t, edge_t, panel_h - 2 * edge_t, z, ht);
  proxy_block(panel_w - edge_t, edge_t, edge_t, panel_h - 2 * edge_t, z, ht);
}

module proxy_rect_frame(x, y, w, h, t=1.5, z=2, ht=0.8) {
  proxy_block(x, y, w, t, z, ht);
  proxy_block(x, y + h - t, w, t, z, ht);
  proxy_block(x, y + t, t, h - 2 * t, z, ht);
  proxy_block(x + w - t, y + t, t, h - 2 * t, z, ht);
}

// Ghost-position placeholder. Later rendering may make this transparent/dashed.
module proxy_ghost_block(x, y, w, h, z=0, ht=1) {
  proxy_block(x, y, w, h, z, ht);
}

module proxy_arrow_stub(x, y, len, dir="right", z=0, ht=1) {
  shaft = max(len - 6, 2);
  if (dir == "right") {
    proxy_block(x, y + 2, shaft, 2, z, ht);
    proxy_block(x + shaft, y, 6, 6, z, ht);
  } else if (dir == "left") {
    proxy_block(x + 6, y + 2, shaft, 2, z, ht);
    proxy_block(x, y, 6, 6, z, ht);
  } else if (dir == "up") {
    proxy_block(x + 2, y, 2, shaft, z, ht);
    proxy_block(x, y + shaft, 6, 6, z, ht);
  } else if (dir == "down") {
    proxy_block(x + 2, y + 6, 2, shaft, z, ht);
    proxy_block(x, y, 6, 6, z, ht);
  } else {
    proxy_block(x, y + 2, shaft, 2, z, ht);
    proxy_block(x + shaft, y, 6, 6, z, ht);
  }
}
