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

module Corner_Part(size = [ 1, 1, 1 ]) {
  cube_height = max([ size.z - size.x, 0 ]);
  cube([ size.x, size.y, cube_height ]);

  translate([ 0, 0, cube_height ]) {
    intersection() {
      rotate([ 90, 0, 0 ])
          cylinder(h = size.x, r1 = size.x, r2 = size.x, center = true);
      cube([ size.x, size.y, size.z ]);
    }
  }
}

module Corner(size = [ 1, 1, 1 ], wall = wall) {
  Corner_Part([ size.x, wall, size.z ]);
  translate([ wall, 0, 0 ]) rotate([ 0, 0, 90 ])
      Corner_Part([ size.y, wall, size.z ]);
}

module Card_Box(size = [ 1, 1, 1 ], wall = wall, hole_radius = 10) {
  base = [ size.x, size.y, wall ];

  difference() {
    cube(base);
    translate([ size.x / 2, 0, 0 ]) { sphere(hole_radius); }
    translate([ size.x / 2, size.y, 0 ]) { sphere(hole_radius); }
    translate([ 0, size.y / 2, 0 ]) { sphere(hole_radius); }
    translate([ size.x, size.y / 2, 0 ]) { sphere(hole_radius); }
  }

  corner = [
    (size.x - 2 * hole_radius) / 2,
    (size.y - 2 * hole_radius) / 2,
    size.z
  ];
  module _Corner() { Corner(size = corner, wall = wall); }

  module _Corners_Pair() {
    _Corner();

    translate([ size.x, 0, 0 ]) mirror([ -1, 0, 0 ]) _Corner();
  }

  _Corners_Pair();

  translate([ 0, size.y, 0 ]) mirror([ 0, 1, 0 ]) _Corners_Pair();
}

module Multi_Card_Box(
    size = [ 1, 1, 1 ],
    wall = wall,
    hole_radius = 10,
    x = 2,
    y = 2) {
  for (i = [0:x - 1]) {
    for (j = [0:y - 1]) {
      translate([ i * (size.x - wall), j * (size.y - wall), 0 ]) {
        Card_Box(size = size, wall = wall, hole_radius = hole_radius);
      }
    }
  }
}
