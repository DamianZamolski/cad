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

module Open_Box(size = [ 1, 1, 1 ], x = 1, y = 1, t = 1.5) {
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

module Corner_Part(size) {
  cube_height = size.z - size.x;

  cube([ size.x, size.y, cube_height ]);

  translate([ 0, 0, cube_height ]) {
    intersection() {
      rotate([ 90, 0, 0 ]) cylinder(100, size.x, size.x, center = true);
      cube([ 50, size.y, 50 ]);
    }
  }
}

module Corner(size) {
  Corner_Part(size);
  translate([ size.y, 0, 0 ]) rotate([ 0, 0, 90 ]) Corner_Part(size);
}

module Holder(
    size,
    corner_width,
    thickness,
    x_finger_hole_radius,
    y_finger_hole_radius) {
  base = [ size.x, size.y, thickness ];

  difference() {
    cube(base);
    translate([ size.x / 2, 0, 0 ]) { sphere(x_finger_hole_radius); }
    translate([ size.x / 2, size.y, 0 ]) { sphere(x_finger_hole_radius); }
    translate([ 0, size.y / 2, 0 ]) { sphere(y_finger_hole_radius); }
    translate([ size.x, size.y / 2, 0 ]) { sphere(y_finger_hole_radius); }
  }

  module _Corner() { Corner([ corner_width, thickness, size.z ]); }

  _Corner();

  translate([ size.x, 0, 0 ]) {
    rotate([ 0, 0, 90 ]) { _Corner(); }
  }

  translate([ 0, size.y, 0 ]) {
    rotate([ 0, 0, -90 ]) { _Corner(); }
  }

  translate([ size.x, size.y, 0 ]) {
    rotate([ 0, 0, 180 ]) { _Corner(); }
  }
}

module Multi_Holder(
    size,
    corner_width,
    thickness,
    x_finger_hole_radius,
    y_finger_hole_radius,
    x,
    y) {
  for (i = [0:x - 1]) {
    for (j = [0:y - 1]) {
      translate([ i * (size.x - thickness), j * (size.y - thickness), 0 ]) {
        Holder(
            size = size,
            corner_width = corner_width,
            thickness = thickness,
            x_finger_hole_radius = x_finger_hole_radius,
            y_finger_hole_radius = y_finger_hole_radius);
      }
    }
  }
}
