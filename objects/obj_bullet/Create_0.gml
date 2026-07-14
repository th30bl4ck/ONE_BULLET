state = "fired"; 
speed = 10;
if (!variable_global_exists("recall_speed")) {
    global.recall_speed = 6;
}
image_angle = direction; 
owner = other; 
solid = false; 

image_angle = direction - 90;

start_x = x;
start_y = y;
max_distance = 300;

scr_refresh_wall_tilemap();
audio_play_sound(snd_fire_bullet,1, false);
has_liquid_lead = false;
liquid_lead_pool = noone;

damage=10 

has_liquid_lead = false;
liquid_trail_timer = 0;
liquid_trail_delay = 2;