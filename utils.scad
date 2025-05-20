wall = 1.5;

function Sum(elements = [ [ 1, 2, 3 ], 5 ]) =
    let(sum = function(numbers, i = 0, result = 0) i == len(numbers)
                  ? result
                  : sum(numbers, i + 1, result + numbers[i]),
        max_element_length = max([for (element = elements)
                len(element)])) max_element_length
        ? [for (i = [0:max_element_length - 1]) sum(
              [for (element = elements) is_list(element)
                      ? (element[i] ? element[i] : 0)
                      : element])]
        : sum(elements);

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

module Wall_Part(size = [ 1, 1, 1 ], rounded = false) {
  if (rounded) {
    cube_height = max([ size.z - size.x, 0 ]);
    cube([ size.x, size.y, cube_height ]);

    translate([ 0, 0, cube_height ]) {
      intersection() {
        rotate([ 90, 0, 0 ])
            cylinder(h = size.x, r1 = size.x, r2 = size.x, center = true);
        cube([ size.x, size.y, size.z ]);
      }
    }
  } else {
    cube(size);
  }
}

module Card_Box_Wall(size = [ 1, 1, 1 ], hole_diameter = 0, rounded = 0) {
  module _Wall_Part() {
    Wall_Part(
        size = [ (size.x - hole_diameter) / 2, size.y, size.z ],
        rounded = rounded);
  }
  if (hole_diameter > 0) {
    _Wall_Part();
    translate([ size.x, 0, 0 ]) mirror([ 1, 0, 0 ]) _Wall_Part();
  } else {
    cube(size);
  }
}

module Card_Box(
    size = [ 1, 1, 1 ],
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

  Card_Box_Wall(
      size = [ size.x, wall, size.z ],
      hole_diameter = bottom_hole_diameter,
      rounded = rounded);

  translate([ 0, size.y, 0 ]) {
    Card_Box_Wall(
        size = [ size.x, wall, size.z ],
        hole_diameter = top_hole_diameter,
        rounded = rounded);
  }

  translate([ wall, 0, 0 ]) {
    rotate(a = 90) {
      Card_Box_Wall(
          size = [ size.y, wall, size.z ],
          hole_diameter = left_hole_diameter,
          rounded = rounded);
    }
  }

  translate([ size.x, 0, 0 ]) {
    rotate(a = 90) {
      Card_Box_Wall(
          size = [ size.y, wall, size.z ],
          hole_diameter = right_hole_diameter,
          rounded = rounded);
    }
  }
}

module Multi_Card_Box(
    size = [ 1, 1, 1 ],
    wall = wall,
    bottom_hole_diameter = 0,
    top_hole_diameter = 0,
    left_hole_diameter = 0,
    right_hole_diameter = 0,
    rounded = false,
    x = 2,
    y = 2) {
  for (i = [0:x - 1]) {
    for (j = [0:y - 1]) {
      translate([ i * (size.x - wall), j * (size.y - wall), 0 ]) {
        Card_Box(
            size = size,
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
