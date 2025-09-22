*hex_grid();

module hex_grid(size = [ 50, 30 ], wall = 1.5, hole_radius = 1.5) {
  hole_outer_radius = hole_radius;
  hole_inner_radius = hole_outer_radius * sqrt(3) / 2;

  hex_inner_radius = hole_inner_radius + wall / 2;
  hex_outer_radius = 2 * hex_inner_radius / sqrt(3);

  distance_between_hexes_centers = 2 * hex_inner_radius;
  x_distance = distance_between_hexes_centers * cos(30);
  y_distance = distance_between_hexes_centers * sin(30);

  x_hexes_count = ceil(size.x / (2 * x_distance));
  y_hexex_count = ceil(size.y / (4 * y_distance));

  module hex() {
    difference() {
      circle(hex_outer_radius, $fn = 6);
      circle(hole_outer_radius, $fn = 6);
    }
  }

  module column() {
    for (i = [0:y_hexex_count]) {
      translate([ 0, distance_between_hexes_centers * i ]) hex();
    }
  }

  module grid_quarter() {
    for (x = [0:x_hexes_count]) {
      translate([ x_distance * x, x % 2 == 0 ? 0 : -y_distance ]) column();
    }
  }

  module grid() {
    grid_quarter();
    mirror([ 0, 1, 0 ]) { grid_quarter(); }

    mirror([ 1, 0, 0 ]) {
      grid_quarter();
      mirror([ 0, 1, 0 ]) { grid_quarter(); }
    }
  }

  if (hole_radius > 0) {
    intersection() {
      grid();
      square(size, center = true);
    }
  } else {
    square(size, center = true);
  }
}
