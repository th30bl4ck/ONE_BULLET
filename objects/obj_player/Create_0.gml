move_speed = 3;
can_shoot = true;
bullet_id = noone;
shoot_layer = "Instances"; 

image_xscale = 1.4;   
image_yscale = 1.4;

dash_speed = 12;
dash_time = 8;          
dash_timer = 0;

dash_cooldown = 40;      
dash_cd_timer = 0;

is_dashing = false;
dash_dir = 0;

global.player = id;

state = "alive";
death_zoom = 1; 

min_cam_scale = 1; 
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
hp = 5;

// one segment per HP
hp_segments = array_create(max_hp, 0);

// invulnerability
invuln = 0;

hp_display = hp;

hp_prev = hp;

hp_frames = array_create(max_hp, 0); // start all full (frame 0)


// Enemy lane anchors 
global.enemy_anchor_offsets = [
    [  0, -80], // TOP
    [  0,  80], // BOTTOM
    [-80,   0], // LEFT
    [ 80,   0]  // RIGHT
];

// How many enemies are assigned to each anchor
global.enemy_anchor_counts = [0, 0, 0, 0];

// upgrade/combat helpers
take_damage = function(amount)
{
    if (amount <= 0) return;

    repeat (amount)
    {
        if (hp > 0)
        {
            hp--;
            hp_segments[hp] = 1;
        }
    }

    hp = clamp(hp, 0, max_hp);
    hp_display = hp;
};

increase_max_hp = function(amount)
{
    if (amount <= 0) return;

    max_hp += amount;
    hp += amount;

    hp = clamp(hp, 0, max_hp);

    var old_len = array_length(hp_segments);
    array_resize(hp_segments, max_hp);

    for (var i = old_len; i < max_hp; i++)
    {
        hp_segments[i] = 0; // FULL frame
    }

    hp_display = hp;
};

heal_hp = function(amount)
{
    if (amount <= 0) return;

    repeat (amount)
    {
        if (hp < max_hp)
        {
            hp_segments[hp] = 0; // refill this segment
            hp += 1;
            hp_display = hp;
        }
    }

    hp = clamp(hp, 0, max_hp);
    hp_display = hp;
};