event_inherited();

move_speed = 500;

ai_enabled = true;

xp_value = 3; 

stuck_timer = 0;

image_xscale = 1.2;   
image_yscale = 1.2;

alarm[0] = irandom_range(room_speed, room_speed * 3);

hp = 10;

path = path_add();

target_y = obj_player.y;
target_x = obj_player.x;

alarm[1] = 1;