include <hex_grid.scad>

*hex_grid_base();

module hex_grid_base(
    size = [ 50, 30 ],
    wall = 1.5,
    hole_radius = 1.5,
    curve_radius = 1e10) {
  min_size = min(size);
  max_curve_radius = min_size * 0.49;
  clamped_curve_radius = min(curve_radius, max_curve_radius);
  linear_extrude(wall) {
    intersection() {
      offset(r = clamped_curve_radius) {
        square(
            [
              size.x - 2 * clamped_curve_radius,
              size.y - 2 *
              clamped_curve_radius
            ],
            center = true);
      }
      hex_grid(
          size = size,
          wall = wall,
          hole_radius = hole_radius);
    }
  }
}
