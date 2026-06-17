// Enemy is alive
dead = false;

// Start noise timer
alarm[0] = room_speed * 0.75;
move_speed = 0.8;

ai_enabled = true;

xp_value = 3; 

stuck_timer = 0;
last_player_dist = 999999;

event_inherited();

event_inherited();

hp = 30;