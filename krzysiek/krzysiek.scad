include <slant-deck-holder.scad>

wall = 1.5;

card_size = [ 68, 94 ];
slant_deck_holder_size =
    [ card_size.x + 2 * wall + 1, card_size.y + 2 * wall + 1, 100 ];

magnet_height = 2;
magnet_diameter = 8;
hole_height = magnet_height * 1.1;
hole_diameter = magnet_diameter * 1.1;
hole_radius = hole_diameter / 2;

module hole() {
  translate([ 0, hole_radius, hole_radius ]) {
    rotate([ 0, 90, 0 ]) {
      cylinder(h = hole_height, d = hole_diameter, center = false);
    }
  }
}

difference() {
  slant_deck_holder(size = slant_deck_holder_size, wall = wall, angle = 6);

  translate([ 0, wall, wall ]) hole();
  translate([ slant_deck_holder_size.x - hole_height, wall, wall ]) hole();
}
