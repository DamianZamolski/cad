include <utils.scad>

render_gap = 5;
wall = 1.5;

box = [ 286, 286, 111 ];
box_padding = [ 2, 2, 3 ];
padded_box = Sum([ box, Minus(box_padding) ]);
big_card = [ 60, 92 ];
small_card = [ 44, 66 ];
cards_box_padding = [ 1, 1, 2 ];
cards_box_walls = [ 2 * wall, 2 * wall, wall ];

function Small_Cards(z = 10) = Sum(
    [ [ small_card.x, small_card.y, z ], cards_box_padding, cards_box_walls ]);

function Big_Cards(z = 10) =
    Sum([ [ big_card.x, big_card.y, z ], cards_box_padding, cards_box_walls ]);

module Cards_Box(size) {
  Box(size = size, wall = wall, bottom_hole_diameter = 20, rounded = true);
}

empire_base_mission_cards = Big_Cards(10);
empire_battle_cards = Big_Cards(11);
empire_expansion_mission_cards = Big_Cards(10);
empire_leader_mission_cards = Big_Cards(10);
empire_project_cards = Big_Cards(10);
empire_starting_mission_cards = Big_Cards(4);
rebel_1_goal_cards = Big_Cards(8);
rebel_2_goal_cards = Big_Cards(7);
rebel_3_goal_cards = Big_Cards(6);
rebel_base_mission_cards = Big_Cards(10);
rebel_battle_cards = Big_Cards(11);
rebel_expansion_mission_cards = Big_Cards(10);
rebel_leader_mission_cards = Big_Cards(10);
rebel_starting_mission_cards = Big_Cards(4);

empire_action_cards = Small_Cards(11);
empire_starting_action_cards = Small_Cards(5);
planet_cards = Small_Cards(19);
rebel_action_cards = Small_Cards(11);
rebel_starting_action_cards = Small_Cards(6);

rebel_big_cards = [
  rebel_1_goal_cards,
  rebel_2_goal_cards,
  rebel_3_goal_cards,
  rebel_base_mission_cards,
  rebel_battle_cards,
  rebel_expansion_mission_cards,
  rebel_leader_mission_cards,
  rebel_starting_mission_cards,
];

empire_big_cards = [
  empire_base_mission_cards,
  empire_battle_cards,
  empire_expansion_mission_cards,
  empire_leader_mission_cards,
  empire_starting_mission_cards,
];

small_cards = [
  empire_action_cards,
  empire_starting_action_cards,
  planet_cards,
  rebel_action_cards,
  rebel_starting_action_cards,
];

% cube(padded_box);

for (i = [0:len(rebel_big_cards) - 1]) {
  elements = rebel_big_cards;
  element = elements[i];
  translate([
    element.y,
    0,
    i > 0 ? Sum_Numbers([for (j = [1:i]) elements[j - 1].z + render_gap]) : 0
  ]) {
    rotate([ 0, 0, 90 ]) { Cards_Box(element); }
  }
}

translate([ rebel_big_cards[0].y + render_gap, 0, 0 ]) {
  for (i = [0:len(empire_big_cards) - 1]) {
    elements = empire_big_cards;
    element = elements[i];
    translate([
      element.y,
      0,
      i > 0 ? Sum_Numbers([for (j = [1:i]) elements[j - 1].z + render_gap]) : 0
    ]) {
      rotate([ 0, 0, 90 ]) { Cards_Box(element); }
    }
  }
  translate([ rebel_big_cards[0].y + render_gap, 0, 0 ]) {
    for (i = [0:len(small_cards) - 1]) {
      elements = small_cards;
      element = elements[i];
      translate([
        element.y,
        0,
        i > 0 ? Sum_Numbers([for (j = [1:i]) elements[j - 1].z + render_gap])
              : 0
      ]) {
        rotate([ 0, 0, 90 ]) { Cards_Box(element); }
      }
    }
  }
}
