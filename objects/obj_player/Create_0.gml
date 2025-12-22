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

// hit flash
hit_flash_timer = 0;

// Combo system
combo_count = 0;
combo_timer = 0;
combo_timer_max = 120; // 2 seconds at 60fps
combo_heat = 0;        // 0 → 1 (for visuals)


// --- HP SETUP ---
max_hp = 5;
hp = max_hp;

// one segment per HP
hp_segments = array_create(max_hp, 0);

// invulnerability
invuln = 0;

hp_display = hp;
