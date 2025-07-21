// rounded_cube();

module rounded_cube(size = [ 50, 30, 20 ], radius = 1e10) {
  max_radius = min(size) * 0.49;
  clamped_radius = min(max(0, radius), max_radius);
  curve_diameter = 2 * clamped_radius;
  cube_size = [
    size.x - curve_diameter,
    size.y - curve_diameter,
    size.z -
    curve_diameter
  ];

  minkowski() {
    cube(cube_size, center = true);
    sphere(clamped_radius);
  }
}
