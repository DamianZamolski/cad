$fn = 360;
nucleum = [ 14, 14, 16 ];
h = 15;
d = 19;

difference() {
  cylinder(h = h, d1 = 2 * d, d2 = 1.5 * d);
  translate([ 0, 0, h / 3 ]) { cylinder(h = nucleum.z, d = d); }
}
