*rounded_rectangle();

module rounded_rectangle(size = [ 50, 30 ], radius = 1e10, center = true) {
  max_radius = min(size.x, size.y) * 0.49;
  clamped_radius = min(max(0, radius), max_radius);
  base_size = [ size.x - 2 * clamped_radius, size.y - 2 * clamped_radius ];

  translation = center ? [ 0, 0, 0 ] : [ size.x / 2, size.y / 2, 0 ];

  translate(translation) {
    offset(r = clamped_radius) { square(base_size, center = true); }
  }
}
