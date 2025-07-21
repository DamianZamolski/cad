*rounded_rectangle();

module rounded_rectangle(size = [ 50, 30 ], radius = 1e10) {
  max_radius = min(size.x, size.y) * 0.49;
  clamped_radius = min(max(0, radius), max_radius);
  base_size = [ size.x - 2 * clamped_radius, size.y - 2 * clamped_radius ];

  offset(r = clamped_radius) { square(base_size, center = true); }
}
