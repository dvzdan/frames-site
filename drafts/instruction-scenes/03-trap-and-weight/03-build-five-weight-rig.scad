include <weight-rig-common.scad>;

// Dedicated instruction scene: the four-weight sandwich is assembled around
// the broken end of the birch stick; the fifth weight is visibly reserved.
weight_pair([0,0,0], steel);
birch_stick([0,15,3.2], 44);
weight_pair([0,0,14], active_blue);
down_arrow([-6,0,6], 7);
down_arrow([6,0,6], 7);

// Reserved singleton, deliberately separated from the four-weight sandwich.
weight_segment([31,3,0], steel_light);
