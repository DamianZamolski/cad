include <utils.scad>
wall = 1.5;
box = [ 288, 288, 66 ];
box_padding = [ 2, 2, 3 ];
characters_cards = [ 66, 91, 37 ];
cards_padding = [ 1, 1, 2 ];
cards_walls = [ 2 * wall, 2 * wall, wall ];
characters_cards_box = Sum([ characters_cards, cards_padding, cards_walls ]);

echo(characters_cards_box);
