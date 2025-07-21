include <rounded_cube.scad>
include <semi_rounded_cube.scad>

// rounded_open_box();

module rounded_open_box(
    size = [ 50, 30, 20 ],
    wall = 1.5,
    outside_radius = 1e10,
    inside_radius = 1e10) {

  max_inside_radius = min(size.x / 2, size.y / 2, size.z) - wall;
  clamped_inside_radius = min(max(0, inside_radius), max_inside_radius);

  max_outside_radius = min(size.x, size.y) * 0.49;
  clamped_outside_radius = min(max(clamped_inside_radius, wall), max(0, outside_radius), max_outside_radius);

  rounded_cube_size =
      [ size.x - 2 * wall, size.y - 2 * wall, 2 * (size.z - wall) ];

  difference() {
    semi_rounded_cube(size = size, radius = clamped_outside_radius);
    translate([ 0, 0, rounded_cube_size.z / 2 + wall]) {
      rounded_cube(size = rounded_cube_size, radius = clamped_inside_radius);
    }
  }
}
