$fn = 48;

steel = [0.34, 0.38, 0.43];
steel_light = [0.52, 0.57, 0.64];
active_blue = [0.08, 0.38, 0.92];
birch = [0.79, 0.61, 0.36];
string_blue = [0.12, 0.45, 0.92];
cover_yellow = [0.96, 0.72, 0.10, 0.72];
frame_gray = [0.38, 0.41, 0.45];
receiver_yellow = [1.00, 0.63, 0.05];
ghost_blue = [0.10, 0.42, 0.92, 0.24];

module rounded_box(size=[12, 9, 3], radius=1.1) {
  linear_extrude(height=size[2])
    offset(r=radius)
      square([size[0]-2*radius, size[1]-2*radius], center=true);
}

module weight_segment(position=[0,0,0], tint=steel) {
  color(tint)
    translate(position)
      rounded_box([12, 9, 3], 1.1);
}

module weight_pair(position=[0,0,0], tint=steel) {
  weight_segment([position[0]-6.35, position[1], position[2]], tint);
  weight_segment([position[0]+6.35, position[1], position[2]], tint);
}

module birch_stick(position=[0,0,0], height=42, tint=birch) {
  color(tint)
    translate(position)
      rounded_box([4.2, height, 1.6], 0.55);
}

module string_segment(a=[0,0,0], b=[0,10,0], radius=0.7, tint=string_blue) {
  v = b-a;
  length = norm(v);
  axis = cross([0,0,1], v);
  angle = acos(v[2]/length);
  color(tint)
    translate(a)
      rotate(a=angle, v=axis)
        cylinder(h=length, r=radius);
}

module down_arrow(position=[0,0,0], length=16) {
  color([0.16,0.17,0.19]) {
    translate([position[0],position[1],position[2]+5]) cylinder(h=length-5, r=1.1);
    translate(position) cylinder(h=5, r1=0, r2=3.2);
  }
}

module five_weight_rig(position=[0,0,0], singleton_tint=steel_light) {
  translate(position) {
    weight_pair([0,0,0], steel);
    weight_pair([0,0,3.4], steel);
    birch_stick([0,14,1.7], 38);
    weight_segment([0,0,6.8], singleton_tint);
  }
}
