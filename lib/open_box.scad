include <hex_grid_base.scad>

*open_box();

module open_box(
    size = [ 50, 30, 20 ],
    wall = 1.5,
    hole_radius = 1.5,
    radius = 1e10) {

  max_radius = min(size.x, size.y) * 0.49;
  clamped_radius = min(radius, max_radius);

  hex_grid_base(
      size = [ size.x, size.y ],
      wall = wall,
      hole_radius = hole_radius);

  module body(radius) {
    offset(r = radius) {
      square(
          [
            size.x - 2 * clamped_radius,
            size.y - 2 *
            clamped_radius
          ],
          center = true);
    }
  }

  linear_extrude(size.z) {
    difference() {
      body(max_radius);
      body(max_radius - wall);
    }
  }
}
