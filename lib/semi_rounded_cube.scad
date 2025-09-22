include <rounded_rectangle.scad>
*semi_rounded_cube();

module semi_rounded_cube(size = [ 50, 30, 20 ], radius = 1e10, center = false) {
  linear_extrude(size.z) {
    rounded_rectangle(size = [ size.x, size.y ], radius = radius, center = center);
  }
}
