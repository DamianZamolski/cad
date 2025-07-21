include <../lib/utils.scad>
gap = 5;
wall = 1.5;

box = [ 286, 286, 46 ];
box_padding = 2;
padded_box = Sum([ box, Minus(box_padding) ]);

earth_tokens = [ 30, 30, 43 ];
x_tokens = [ 38, 38, 43 ];
room_tiles = [ 137, 75, 18 ];
box_walls = [ 2 * wall, 2 * wall, wall ];
cards = [ 66, 91, 37 ];
big_cards = [ 120, 80, 13 ];
cards_padding = [ 1, 1, 2 ];
finger_hole_diameter = 30;
token_types = 25;

rooms_box = Sum([ room_tiles, box_padding, box_walls ]);
cards_box = Sum([ cards, cards_padding, box_walls ]);
big_cards_box = Sum([ big_cards, cards_padding, box_walls ]);
characters_box = [
  padded_box.x - (rooms_box.x + cards_box.x) + wall,
  cards_box.y,
  padded_box.z
];
tokens_space = [ padded_box.x, padded_box.y - cards_box.y, padded_box.z ];
left_tokens_box = [ tokens_space.x * 3 / 5, tokens_space.y, tokens_space.z ];
right_tokens_box = [ tokens_space.x * 2 / 5, tokens_space.y, tokens_space.z ];

expanded_rooms_box =
    [ rooms_box.x, cards_box.y, padded_box.z - big_cards_box.z ];
expanded_cards_box = [ cards_box.x, cards_box.y, padded_box.z ];
expanded_big_cards_box = [ rooms_box.x, cards_box.y, big_cards_box.z ];

Box(size = expanded_rooms_box,
    bottom_hole_diameter = finger_hole_diameter,
    rounded = true);

translate([ expanded_rooms_box.x + gap, 0, 0 ]) {
  Box(size = expanded_cards_box,
      bottom_hole_diameter = finger_hole_diameter,
      rounded = true);
  translate([ expanded_cards_box.x - wall, 0, 0 ]) {
    Box(size = characters_box);
  }
}

translate([ 0, expanded_cards_box.y + gap, 0 ]) {
  Open_Box(size = left_tokens_box, x = 3, y = 5);
  translate([ left_tokens_box.x + gap, 0, 0 ]) {
    Open_Box(size = right_tokens_box, x = 2, y = 5);
  }
}

translate([ 0, 0, expanded_rooms_box.z + gap ]) {
  Box(size = expanded_big_cards_box,
      bottom_hole_diameter = finger_hole_diameter,
      rounded = true);
}

% cube(padded_box);
