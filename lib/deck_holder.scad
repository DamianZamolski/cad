* deck_holder();

module
deck_holder(card_size = [ 68, 94 ], height = 100, wall = 1.5, angle = 5) {

  size = [ card_size.x + 2 * wall + 1, card_size.y + 2 * wall + 1, height ];
  d2 = size.x * size.x + size.y * size.y;
  d = sqrt(d2);
  h = tan(angle) * d;

  function top_point(x, y) = [ x, y, (x * size.x + y * size.y) / d2 * h ];

  points = [
    [ 0, 0, 0 ],
    [ size.x, 0, 0 ],
    [ size.x, size.y, 0 ],
    [ 0, size.y, 0 ],
    top_point(size.x, 0),
    top_point(size.x, size.y),
    top_point(0, size.y),
  ];

  faces = [
    [ 0, 1, 2, 3 ],
    [ 0, 4, 1 ],
    [ 1, 4, 5, 2 ],
    [ 2, 5, 6, 3 ],
    [ 0, 3, 6 ],
    [ 0, 6, 5, 4 ]
  ];

  module part() {
    cube([ size.x, size.y, wall ]);
    translate([ 0, 0, wall ]) { polyhedron(points = points, faces = faces); }
    cube([ size.x * 2 / 3, wall, size.z ]);
    cube([ wall / 2, size.y * 2 / 3, size.z ]);
  }

  part();
  mirror([ 1, 0, 0 ]) part();
}
