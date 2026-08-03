// Enemy is alive
dead = false;

// Start noise timer
alarm[0] = room_speed * 0.75;
move_speed = 1.25;

ai_enabled = true;

xp_value = 3; 

stuck_timer = 0;
last_player_dist = 999999;

event_inherited();

event_inherited();

hp = 30;

path = path_add();

target_y = obj_player.y;
target_x = obj_player.x;

alarm[1] = 1;