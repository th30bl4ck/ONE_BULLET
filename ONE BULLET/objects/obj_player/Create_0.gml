move_speed = 3;
can_shoot = true;
bullet_id = noone;
shoot_layer = "Instances"; // Make sure this matches your room layer

dash_speed = 12;
dash_time = 8;           // how long the dash lasts (frames)
dash_timer = 0;

dash_cooldown = 40;      // how long before you can dash again
dash_cd_timer = 0;

is_dashing = false;
dash_dir = 0;

global.player = id;

state = "alive";
death_zoom = 1; // camera zoom

min_cam_scale = 1; // this will be calculated after the first frame

input_locked = false;

death_cam_x = 0;
death_cam_y = 0;

death_cam_w = 0;
death_cam_h = 0;

death_cam_locked = false;

max_hp = 5;
hp = max_hp;

invuln = 0;

// this is the SMOOTHING value
hp_display = hp; 
