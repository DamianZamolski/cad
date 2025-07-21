include <../lib/utils.scad>

t = 1.6;
box_padding = 2;
cards_padding = 2;
gap = 5;

box = [ 398, 267, 88 ];
card = [ 72, 123 ];

insert = [ box.x - box_padding, box.y - box_padding, box.z - box_padding ];
cards = [ card.y + cards_padding + 2 * t, insert.y, insert.z ];
units = [ insert.x - cards.x, insert.y, insert.z ];
nation = [ units.x / 2, units.y / 4, units.z ];
double_nation = [ units.x / 2, units.y / 2, units.z ];
cards_holder = [
  card.x + cards_padding + 2 * t,
  card.y + cards_padding + 2 * t,
  insert.z
];
corner_width = cards_holder.x * 0.25;
tokens = [ cards.x, insert.y - 2 * cards_holder.x + t, insert.z ];

for (i = [0:1]) {
  for (j = [0:1]) {
    translate([ i * (double_nation.x + gap), j * (double_nation.y + gap), 0 ])
        Open_Box(double_nation, x = 3, y = 2);
  }
}

translate([ 2 * (double_nation.x + gap), 0, 0 ]) {
  Open_Box(tokens);

  translate([ cards_holder.y, tokens.y + gap, 0 ]) rotate([ 0, 0, 90 ])
      Multi_Box(
          size = cards_holder,
          wall = t,
          x = 2,
          y = 1,
          bottom_hole_diameter = 30,
          rounded = false);
}
