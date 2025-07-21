function Sum_Numbers(numbers = [ 1, 2, 3 ], i = 0) =
    i == len(numbers) ? 0 : numbers[i] + Sum_Numbers(numbers, i + 1);

function Sum(elements = [ [ 1, 2, 3 ], 5 ]) =
    let(max_element_length = max(
            [for (element = elements) is_list(element) ? len(element)
                                                       : 0])) max_element_length
        ? [for (i = [0:max_element_length - 1]) Sum_Numbers(
              [for (element = elements) is_list(element)
                      ? (element[i] ? element[i] : 0)
                      : element])]
        : Sum_Numbers(elements);

function Multiply(list = [ 1, 2, 3 ], number = 3) =
    [for (element = list) element * number];

function Minus(list_or_number = [ 1, 2, 3 ]) =
    is_list(list_or_number)
        ? [for (list_element = list_or_number) Minus(list_element)]
        : -list_or_number;

module Open_Box(size = [ 1, 1, 1 ], x = 1, y = 1, t = wall) {
  cube([ size.x, size.y, t ]);
  dx = (size.x - t) / x;
  dy = (size.y - t) / y;
  for (i = [0:x]) {
    translate([ i * dx, 0, 0 ]) { cube([ t, size.y, size.z ]); }
  }
  for (i = [0:y]) {
    translate([ 0, i * dy, 0 ]) { cube([ size.x, t, size.z ]); }
  }
}

module Box_Wall_Part(size = [ 1, 1, 1 ], rounded = false) {
  if (rounded) {
    cube_height_or_width = size.z - size.x;
    cube([
      cube_height_or_width < 0 ? -cube_height_or_width : size.x,
      size.y,
      cube_height_or_width > 0 ? cube_height_or_width : size.z
    ]);

    cylinder_radius = cube_height_or_width > 0 ? size.x : size.z;

    translate([
      cube_height_or_width < 0 ? -cube_height_or_width : 0,
      0,
      cube_height_or_width > 0 ? cube_height_or_width : 0
    ]) {
      intersection() {
        rotate([ 90, 0, 0 ]) cylinder(
            h = size.x,
            r1 = cylinder_radius,
            r2 = cylinder_radius,
            center = true);
        cube([ size.x, size.y, size.z ]);
      }
    }
  } else {
    cube(size);
  }
}

module Box_Wall(size = [ 1, 1, 1 ], hole_diameter = 0, rounded = 0) {
  module _Box_Wall_Part() {
    Box_Wall_Part(
        size = [ (size.x - hole_diameter) / 2, size.y, size.z ],
        rounded = rounded);
  }
  if (hole_diameter > 0) {
    _Box_Wall_Part();
    translate([ size.x, 0, 0 ]) mirror([ 1, 0, 0 ]) _Box_Wall_Part();
  } else {
    cube(size);
  }
}

module
Box(size = [ 1, 1, 1 ],
    wall = wall,
    bottom_hole_diameter = 0,
    top_hole_diameter = 0,
    left_hole_diameter = 0,
    right_hole_diameter = 0,
    rounded = false) {
  base = [ size.x, size.y, wall ];

  difference() {
    cube(base);
    translate([ size.x / 2, 0, 0 ]) { sphere(d = bottom_hole_diameter); }
    translate([ size.x / 2, size.y, 0 ]) { sphere(d = top_hole_diameter); }
    translate([ 0, size.y / 2, 0 ]) { sphere(d = left_hole_diameter); }
    translate([ size.x, size.y / 2, 0 ]) { sphere(d = right_hole_diameter); }
  }

  Box_Wall(
      size = [ size.x, wall, size.z ],
      hole_diameter = bottom_hole_diameter,
      rounded = rounded);

  translate([ 0, size.y, 0 ]) {
    Box_Wall(
        size = [ size.x, wall, size.z ],
        hole_diameter = top_hole_diameter,
        rounded = rounded);
  }

  translate([ wall, 0, 0 ]) {
    rotate(a = 90) {
      Box_Wall(
          size = [ size.y, wall, size.z ],
          hole_diameter = left_hole_diameter,
          rounded = rounded);
    }
  }

  translate([ size.x, 0, 0 ]) {
    rotate(a = 90) {
      Box_Wall(
          size = [ size.y, wall, size.z ],
          hole_diameter = right_hole_diameter,
          rounded = rounded);
    }
  }
}

module Multi_Box(
    size = [ 1, 1, 1 ],
    wall = wall,
    bottom_hole_diameter = 0,
    top_hole_diameter = 0,
    left_hole_diameter = 0,
    right_hole_diameter = 0,
    rounded = false,
    x = 2,
    y = 1) {
  for (i = [0:x - 1]) {
    for (j = [0:y - 1]) {
      translate([ i * (size.x - wall), j * (size.y - wall), 0 ]) {
        Box(size = size,
            wall = wall,
            bottom_hole_diameter = bottom_hole_diameter,
            top_hole_diameter = top_hole_diameter,
            left_hole_diameter = left_hole_diameter,
            right_hole_diameter = right_hole_diameter,
            rounded = rounded);
      }
    }
  }
}
