include <proxy_blocks.scad>

// Primitive vocabulary demo only. This does not represent the actual device.

proxy_plate(0, 0, 26, 16, proxy_base_t);
proxy_block(34, 0, 22, 14, 0, proxy_relief_h);
proxy_nub(66, 0, 10, 10, 0, proxy_relief_h);
proxy_ledge(86, 0, 24, 8, 0, 1);
proxy_fin(120, 0, 6, 22, 0, proxy_fin_h);
proxy_rail(138, 0, 36, 6, 0, 3);
proxy_detail(184, 0, 24, 12, 0, proxy_detail_h);

translate([0, 34, 0]) proxy_outer_frame(46, 28, proxy_edge_t, 0, 1);
proxy_rect_frame(62, 34, 42, 28, 2, 0, 1);
proxy_arrow_stub(122, 42, 40, "right", 0, 1);
