move_speed = 0.8;

ai_enabled = true;

xp_value = 3; 

stuck_timer = 0;
last_player_dist = 999999;

event_inherited();

event_inherited();

hp = 10;

path = path_add();

target_y = obj_player.y;
target_x = obj_player.x;

alarm[0] = 1;