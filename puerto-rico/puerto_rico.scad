include <../lib/rounded_cube.scad>
include <../lib/rounded_rectangle.scad>
include <../lib/semi_rounded_cube.scad>

$fn = 128;

wall = 1.5;
gap = 5;

space = [ 212 - 0.5, 301 - 1, 66 - 10 ];
festival = [ 97, 138, 2 ];
small_building = [ 40.5, 23.5, 2 ];
big_building = [ 40.5, 48.5, 2 ];
plantation = [ 26, 26, 2 ];
coin = [ 20, 2 ];
point = [ 20, 2 ];
role = [ 40.5, 66.5, 2 ];
smuggler = [ 35, 35, 2 ];
book = [ 65, 49, 2 ];

ship = [ 36.5, 66.5, 2 ];

other_tokens = [ role.x, role.y, 6 + wall ];

good = [ 40, 50, 20 + wall ];
goods = [ 5 * good.x, good.y, good.z ];

building_grid_y_wall =
    (space.x - (2 * wall + 6 * small_building.y + big_building.y)) / 6;

buildings = [
  6 * small_building.x + 7 * wall,
  6 * small_building.y + big_building.y + 2 * wall + 6 * building_grid_y_wall,
  11 +
  wall
];

plantations =
    [ 3 * plantation.x + 4 * wall, 2 * plantation.y + 3 * wall, 24 + wall ];

roles = [ 3 * role.x + 4 * wall, space.x, 6.5 + wall ];

ships = [ space.x, ship.y + 2 * wall, roles.z ];

module Buildings() {

  corner_part_size = 11 * wall;

  module External_Corner() {
    size = (wall + corner_part_size) / 2;
    translate([ wall + size / 4, 0 ]) { rounded_rectangle([ size, wall ]); }
    translate([ 0, wall + size / 4 ]) { rounded_rectangle([ wall, size ]); }
  }

  module External_Corner() {
    x_size = (wall + corner_part_size) / 2;
    y_size = (wall + corner_part_size) / 2;
    translate([ wall + x_size / 4, 0 ]) { rounded_rectangle([ x_size, wall ]); }
    translate([ 0, wall + x_size / 4 ]) { rounded_rectangle([ wall, x_size ]); }
  }

  module External_Middle_Corner() {
    rounded_rectangle([ corner_part_size, wall ]);
    rounded_rectangle([ wall, corner_part_size ]);
  }

  module Internal_Corner() {
    rounded_rectangle([ corner_part_size, building_grid_y_wall ]);
    rounded_rectangle([ wall, corner_part_size ]);
  }

  module X_Hole() {
    rounded_rectangle(
        [ small_building.x - (corner_part_size - wall), corner_part_size ]);
  }

  intersection() {
    translate([ wall / 2, wall / 2 ]) {
      linear_extrude(wall) {
        difference() {
          square([ buildings.x - wall, buildings.y - wall ]);
          for (x = [0:6]) {
            translate([ x * (small_building.x + wall), 0 ]) {
              translate([ wall / 2 + small_building.x / 2, 0 ]) { X_Hole(); }
              translate([
                0,
                (wall / 2 + big_building.y + building_grid_y_wall / 2) / 2
              ]) {
                rounded_rectangle([
                  corner_part_size,
                  big_building.y - (corner_part_size - wall) / 2 -
                      (corner_part_size - building_grid_y_wall) / 2
                ]);
              }
              for (y = [0:6]) {
                translate([
                  0,
                  wall / 2 + big_building.y + building_grid_y_wall / 2 +
                      y * (small_building.y + building_grid_y_wall)
                ]) {
                  translate([ wall / 2 + small_building.x / 2, 0 ]) {
                    X_Hole();
                  }
                  if (y != 5) {
                    translate([
                      0,
                      building_grid_y_wall / 2 + small_building.y / 2
                    ]) {
                      rounded_rectangle([
                        corner_part_size,
                        small_building.y -
                            (corner_part_size - building_grid_y_wall)
                      ]);
                    }
                  } else {
                    translate([
                      0,
                      (wall / 2 + small_building.y + building_grid_y_wall / 2) /
                          2
                    ]) {
                      rounded_rectangle([
                        corner_part_size,
                        small_building.y - (corner_part_size - wall) / 2 -
                            (corner_part_size - building_grid_y_wall) / 2
                      ]);
                    }
                  }
                }
              }
            }
          }
        }
      }

      linear_extrude(buildings.z) {
        External_Corner();
        translate([ buildings.x - wall, 0 ]) {
          rotate([ 0, 0, 90 ]) { External_Corner(); }
        }
        translate([ 0, buildings.y - wall ]) {
          rotate([ 0, 0, -90 ]) { External_Corner(); }
        }
        translate([ buildings.x - wall, buildings.y - wall ]) {
          rotate([ 0, 0, 180 ]) { External_Corner(); }
        }

        for (x = [0:6]) {
          if (x > 0 && x < 6) {
            translate([ x * (small_building.x + wall), 0 ]) {
              External_Middle_Corner();
              translate([ 0, buildings.y - wall ]) { External_Middle_Corner(); }
            }
          }
          for (y = [0:5]) {
            translate([
              x * (small_building.x + wall),
              wall / 2 + big_building.y + building_grid_y_wall / 2 +
                  y * (small_building.y + building_grid_y_wall)
            ]) {
              Internal_Corner();
            }
          }
        }
      }
    }
    cube(buildings);
  }
}

module Tokens_Grid(
    size = [ 50, 30, 20 ],
    token = [ 10, 5 ],
    x_count = 3,
    y_count = 3,
    wall = 1.5, ) {

  x_wall = (size.x - x_count * token.x - 2 * wall) / (x_count - 1);
  y_wall =
      y_count > 1 ? (size.y - y_count * token.y - 2 * wall) / (y_count - 1) : 0;

  corner_size = 5 * wall;
  middle_corner =
      [ 2 * (corner_size - wall) + x_wall, 2 * (corner_size - wall) + y_wall ];

  module X_Hole() {
    rounded_rectangle(
        [ token.x + 2 * wall - 2 * corner_size, 2 * corner_size - wall ]);
  }

  module Outer_X_Holes() {
    for (x = [0:x_count - 1]) {
      translate([ wall / 2 + token.x / 2 + x * (token.x + x_wall), 0 ]) {
        X_Hole();
        translate([ 0, size.y - wall ]) { X_Hole(); }
      }
    }
  }

  module Middle_X_Holes() {
    if (x_count >= 2 && y_count >= 2) {
      translate([ wall / 2 + token.x / 2, wall / 2 + token.y + y_wall / 2 ]) {
        for (x = [0:x_count - 1]) {
          for (y = [0:y_count - 2]) {
            translate([ x * (token.x + x_wall), y * (token.y + y_wall) ])
                X_Hole();
          }
        }
      }
    }
  }

  module Y_Hole() {
    rounded_rectangle(
        [ 2 * corner_size - wall, token.y + 2 * wall - 2 * corner_size ]);
  }

  module Outer_Y_Holes() {
    for (y = [0:y_count - 1]) {
      translate([ 0, wall / 2 + token.y / 2 + y * (token.y + y_wall) ]) {
        Y_Hole();
        translate([ size.x - wall, 0 ]) { Y_Hole(); }
      }
    }
  }

  module Middle_Y_Holes() {
    if (x_count >= 2 && y_count >= 1) {
      translate([ wall / 2 + token.x + x_wall / 2, wall / 2 + token.y / 2 ]) {
        for (x = [0:x_count - 2]) {
          for (y = [0:y_count - 1]) {
            translate([ x * (token.x + x_wall), y * (token.y + y_wall) ])
                Y_Hole();
          }
        }
      }
    }
  }

  module Floor() {
    translate([ wall / 2, wall / 2 ]) {
      linear_extrude(wall) {
        difference() {
          square([ size.x - wall, size.y - wall ]);
          Outer_X_Holes();
          Middle_X_Holes();
          Outer_Y_Holes();
          Middle_Y_Holes();
        }
      }
    }
  }

  module Outer_Corner() {
    translate([ corner_size / 2, wall / 2 ]) {
      rounded_rectangle([ corner_size, wall ]);
    }
    translate([ wall / 2, corner_size / 2 ]) {
      rounded_rectangle([ wall, corner_size ]);
    }
  }

  module Outer_Corners() {
    Outer_Corner();
    translate([ size.x, 0 ]) rotate([ 0, 0, 90 ]) Outer_Corner();
    translate([ 0, size.y ]) rotate([ 0, 0, -90 ]) Outer_Corner();
    translate([ size.x, size.y ]) rotate([ 0, 0, 180 ]) Outer_Corner();
  }

  module Bottom_Middle_Corner() {
    translate([ 0, wall / 2 ]) { rounded_rectangle([ middle_corner.x, wall ]); }
    translate([ 0, corner_size / 2 ]) {
      rounded_rectangle([ x_wall, corner_size ]);
    }
  }

  module Bottom_Middle_Corners() {
    for (x = [0:x_count - 2]) {
      translate([ wall + token.x + x_wall / 2 + x * (token.x + x_wall), 0 ]) {
        Bottom_Middle_Corner();
      }
    }
  }

  module Top_Middle_Corners() {
    translate([ 0, size.y ]) {
      mirror([ 0, 1, 0 ]) { Bottom_Middle_Corners(); }
    }
  }

  module Left_Middle_Corner() {
    translate([ corner_size / 2, 0 ]) {
      rounded_rectangle([ corner_size, y_wall ]);
    }
    translate([ wall / 2, 0 ]) { rounded_rectangle([ wall, middle_corner.y ]); }
  }

  module Left_Middle_Corners() {
    if (y_count > 2) {
      for (y = [0:y_count - 2]) {
        translate([ 0, wall + token.y + y_wall / 2 + y * (token.y + y_wall) ]) {
          Left_Middle_Corner();
        }
      }
    }
  }

  module Right_Middle_Corners() {
    translate([ size.x, 0 ]) {
      mirror([ 1, 0, 0 ]) { Left_Middle_Corners(); }
    }
  }

  module Middle_Corner() {
    rounded_rectangle([ middle_corner.x, y_wall ]);
    rounded_rectangle([ x_wall, middle_corner.y ]);
  }

  module Middle_Corners() {
    if (x_count >= 2 && y_count >= 2) {
      for (x = [0:x_count - 2]) {
        for (y = [0:y_count - 2]) {
          translate([
            wall + token.x + x_wall / 2 + x * (token.x + x_wall),
            wall + token.y + y_wall / 2 + y * (token.y + y_wall)
          ]) {
            Middle_Corner();
          }
        }
      }
    }
  }

  module Corners() {
    linear_extrude(size.z) {
      Outer_Corners();
      Bottom_Middle_Corners();
      Top_Middle_Corners();
      Left_Middle_Corners();
      Right_Middle_Corners();
      Middle_Corners();
    }
  }

  Floor();
  Corners();
}

*difference() {
  semi_rounded_cube(size = goods, radius = wall, center = false);
  translate([ good.x / 2, good.y / 2, good.z ]) {
    rounded_cube([ good.x - 2 * wall, good.y - 2 * wall, 2 * (good.z - wall) ]);
  }
}

Buildings();

translate([ 0, 0, buildings.z + gap]) {
  Tokens_Grid(
      size = roles,
      token = [ role.x, role.y ],
      x_count = 3,
      y_count = 3);

  translate([ roles.x + ships.y + gap, 0, 0 ]) {

    rotate([ 0, 0, 90 ]) {
      !Tokens_Grid(
          size = ships,
          token = [ ship.x, ship.y ],
          x_count = 5,
          y_count = 1);
    }
  }

  translate([ 0, 0, roles.z + gap]) {

    Tokens_Grid(
        size = plantations,
        token = [ plantation.x, plantation.y ],
        x_count = 3,
        y_count = 2);
  }
}

% translate([ space.y, 0 ]) rotate([ 0, 0, 90 ]) cube(space);
