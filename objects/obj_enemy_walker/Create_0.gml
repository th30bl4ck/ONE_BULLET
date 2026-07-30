move_speed = 0.8;

ai_enabled = true;

xp_value = 3; 

stuck_timer = 0;
last_player_dist = 999999;

image_xscale = 1.2;   
image_yscale = 1.2;

// noise time (1-3 seconds)
alarm[0] = irandom_range(room_speed, room_speed * 3);

event_inherited();

event_inherited();

hp = 10;