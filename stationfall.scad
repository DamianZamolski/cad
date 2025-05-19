include <utils.scad>
wall = 1.5;
box = [ 288, 288, 66 ];
box_padding = [ 2, 2, 3 ];
padded_box = Sum([ box, Minus(box_padding) ]);
cards = [ 66, 91, 37 ];
big_cards = [ 120, 80, 13 ];
cards_padding = [ 1, 1, 2 ];
cards_walls = [ 2 * wall, 2 * wall, wall ];
cards_box = Sum([ cards, cards_padding, cards_walls ]);

echo(cards_box);
