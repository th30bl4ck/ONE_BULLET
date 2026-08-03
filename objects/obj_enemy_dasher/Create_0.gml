// Movement speeds
move_speed = 1.25;
dash_speed = 12;

// Ranges
mid_range = 250;   // starts charge when player is within this distance

// Timing
charge_time = 25;  // frames to wind-up
charge_timer = 0;

// State
state = "chase";

cooldown_time = 45;   // frames
cooldown_timer = 0;

xp_value = 5; 

image_xscale = 1.3;   
image_yscale = 1.3;

event_inherited();


hp = 20;

path = path_add();

target_y = obj_player.y;
target_x = obj_player.x;


px = obj_player.x;
py = obj_player.y;
dasher_dist = point_distance(x, y, px, py);
start = true;