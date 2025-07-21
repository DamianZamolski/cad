include <../lib/utils.scad>

render_gap = 5;

box = [ 286, 286, 111 ];
box_padding = [ 2, 2, 3 ];
space = Sum([ box, Minus(box_padding) ]);

padding = [ 1, 1, 2 ];
wall = 1.5;
walls = [ 2 * wall, 2 * wall, wall ];

big_card = [ 60, 92 ];
function
    Big_Cards(z = 10) = Sum([ [ big_card.x, big_card.y, z ], padding, walls ]);

empire_base_mission_cards = Big_Cards(10);
empire_battle_cards = Big_Cards(11);
empire_expansion_mission_cards = Big_Cards(10);
empire_leader_mission_cards = Big_Cards(10);
empire_mission_cards = Big_Cards(34);
empire_project_cards = Big_Cards(10);
empire_starting_mission_cards = Big_Cards(4);
rebel_base_mission_cards = Big_Cards(10);
rebel_battle_cards = Big_Cards(11);
rebel_expansion_mission_cards = Big_Cards(10);
rebel_leader_mission_cards = Big_Cards(10);
rebel_stage_1_objective_cards = Big_Cards(8);
rebel_stage_2_objective_cards = Big_Cards(7);
rebel_stage_3_objective_cards = Big_Cards(6);
rebel_starting_mission_cards = Big_Cards(4);

small_card = [ 44, 66 ];
function Small_Cards(z = 10) =
    Sum([ [ small_card.x, small_card.y, z ], padding, walls ]);

empire_action_cards = Small_Cards(19);
probe_cards = Small_Cards(25);
rebel_action_cards = Small_Cards(11);
rebel_starting_action_cards = Small_Cards(6);

function Tokens(size = [ 1, 2, 3 ]) = Sum([ size, padding, walls ]);

planets = Tokens([ 80, 80, 7 ]);
sabotages = Tokens([ 34, 23, 19 ]);
damages = Tokens([ 54, 26, 26 ]);
double_damages = Tokens([ 48, 26, 18 ]);
rings = Tokens([ 41, 41, 21 ]);
rebel_tokens = Tokens([ 27, 28, 24 ]);
empire_tokens = Tokens([ 61, 28, 24 ]);
targets = Tokens([ 31, 26, 12 ]);
round_tokens = Tokens([ 20, 20, 5 ]);
leader = [ 20, 32, 50 ];
leaders = Tokens([ 17 * leader.x, leader.y, leader.z ]);
expanded_leaders = [ leaders.x, leaders.y, space.z / 2 ];

rebel_big_cards = [
  rebel_stage_1_objective_cards,
  rebel_stage_2_objective_cards,
  rebel_stage_3_objective_cards,
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
  probe_cards,
  rebel_action_cards,
  rebel_starting_action_cards,
];

tokens = [
  planets,
  sabotages,
  damages,
  double_damages,
  rings,
  // rebel_tokens,
  //  empire_tokens,
  // targets,
  round_tokens,
  //  leaders,
  // leaders
];

module Cards_Box(size) {
  Box(size = size,
      wall = wall,
      bottom_hole_diameter = 20,
      top_hole_diameter = 20,
      left_hole_diameter = 20,
      right_hole_diameter = 20,
      rounded = true);
}

module Tokens_Box(size) { Box(size = size, wall = wall); }

% cube(space);

! Cards_Box(empire_mission_cards);

Tokens_Box(expanded_leaders);
translate([ 0, 0, expanded_leaders.z + render_gap ])
    Tokens_Box(expanded_leaders);

translate([ leaders.x + render_gap, 0, 0 ]) {
  for (i = [0:len(rebel_big_cards) - 1]) {
    elements = rebel_big_cards;
    element = elements[i];
    translate([
      0,
      0,
      i > 0 ? Sum_Numbers([for (j = [1:i]) elements[j - 1].z + render_gap]) : 0
    ]) {
      Cards_Box(element);
    }
  }

  translate([ rebel_big_cards[0].x + render_gap, 0, 0 ]) {
    for (i = [0:len(empire_big_cards) - 1]) {
      elements = empire_big_cards;
      element = elements[i];
      translate([
        0,
        0,
        i > 0 ? Sum_Numbers([for (j = [1:i]) elements[j - 1].z + render_gap])
              : 0
      ]) {
        Cards_Box(element);
      }
    }
    translate([
      rebel_big_cards[0].x + render_gap,
      0,
      Sum([for (x = empire_big_cards) x.z])
    ]) {
      for (i = [0:len(small_cards) - 3]) {
        elements = small_cards;
        element = elements[i];
        translate([
          0,
          0,
          i > 0 ? Sum_Numbers([for (j = [1:i]) elements[j - 1].z + render_gap])
                : 0
        ]) {
          rotate([ 0, 0, 90 ]) Cards_Box(element);
        }
      }
    }
  }

  translate([ 2 * rebel_big_cards[0].x + render_gap, small_cards[0].x, 0 ]) {
    Tokens_Box(empire_tokens);
    translate([ 0, 0, empire_tokens.z + render_gap ]) {
      Tokens_Box(rebel_tokens);
      translate([ rebel_tokens.x + render_gap, 0, 0 ]) Tokens_Box(targets);
    }
  }
}

translate([ 300, 0, 0 ]) {
  for (i = [0:len(tokens) - 1]) {
    elements = tokens;
    element = elements[i];
    translate([
      i > 0 ? Sum_Numbers([for (j = [1:i]) elements[j - 1].x + render_gap]) : 0,
      0,
      0,
    ]) {
      Tokens_Box(element);
    }
  }
}

