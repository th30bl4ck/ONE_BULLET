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
combo_heat = 0;        

// --- player_health system ---
function player_health_approach(_cur, _tgt, _amt)
{
    if (_cur < _tgt) return min(_cur + _amt, _tgt);
    if (_cur > _tgt) return max(_cur - _amt, _tgt);
    return _cur;
}

function player_health_sync_aliases()
{
    max_hp = player_health.max;
    hp = player_health.current;
    hp_display = player_health.current;
    hp_prev = player_health.current;

    hp_segments = player_health.segments;
    hp_frames = player_health.frames;
}

function player_health_resize_buffers(_new_max)
{
    var safe_max = max(1, floor(_new_max));

    var old_segments = player_health.segments;
    var old_frames = player_health.frames;

    player_health.max = safe_max;
    player_health.segments = array_create(safe_max, 0);
    player_health.frames = array_create(safe_max, 0);

    var keep_segments = min(array_length(old_segments), safe_max);
    for (var i = 0; i < keep_segments; i++) {
        player_health.segments[i] = old_segments[i];
    }

    var keep_frames = min(array_length(old_frames), safe_max);
    for (var j = 0; j < keep_frames; j++) {
        player_health.frames[j] = old_frames[j];
    }

    player_health.current = clamp(player_health.current, 0, safe_max);
}

function player_health_update_visuals()
{
    player_health.frame_empty = 8;

    if (array_length(player_health.frames) != player_health.max || array_length(player_health.segments) != player_health.max) {
        player_health_resize_buffers(player_health.max);
    }

    var anim_spd = 0.4;

    for (var i = 0; i < player_health.max; i++)
    {
        if (player_health.segments[i] > 0 && player_health.segments[i] < player_health.frame_empty) {
            player_health.segments[i] += 0.25;
        }

        if (player_health.segments[i] >= player_health.frame_empty) {
            player_health.segments[i] = player_health.frame_empty;
        }

        var target = player_health.frame_empty;

        if (i < player_health.current)
        {
            target = player_health.frame_full;
            player_health.segments[i] = 0;
        }
        else
        {
            target = clamp(player_health.segments[i], 0, player_health.frame_empty);
        }

        player_health.frames[i] = player_health_approach(player_health.frames[i], target, anim_spd);
    }

    player_health_sync_aliases();
}

function player_health_apply_damage(_amount)
{
    var amount = max(0, floor(_amount));
    if (amount <= 0) return 0;

    var dealt = 0;
    repeat (amount)
    {
        if (player_health.current <= 0) break;

        player_health.current -= 1;
        dealt += 1;

        if (player_health.current >= 0 && player_health.current < player_health.max) {
            player_health.segments[player_health.current] = 1;
        }
    }

    player_health.current = clamp(player_health.current, 0, player_health.max);
    player_health_sync_aliases();
    return dealt;
}

function player_health_heal(_amount)
{
    var amount = max(0, floor(_amount));
    if (amount <= 0) return 0;

    var healed = 0;
    repeat (amount)
    {
        if (player_health.current >= player_health.max) break;

        if (player_health.current >= 0 && player_health.current < player_health.max) {
            player_health.segments[player_health.current] = 0;
        }

        player_health.current += 1;
        healed += 1;
    }

    player_health.current = clamp(player_health.current, 0, player_health.max);
    player_health_sync_aliases();
    return healed;
}

function player_health_increase_max(_amount)
{
    var amount = max(0, floor(_amount));
    if (amount <= 0) return 0;

    var old_max = player_health.max;
    player_health_resize_buffers(old_max + amount);

    // Do NOT heal when max HP increases
    player_health.current = clamp(player_health.current, 0, player_health.max);

    for (var i = old_max; i < player_health.max; i++)
    {
        player_health.segments[i] = 0;
        player_health.frames[i] = player_health.frame_empty; // start as empty, not full
    }

    player_health_sync_aliases();
    return amount;
}

player_health = {
    max: 5,
    current: 5,
    frame_full: 0,
    frame_empty: 8,
    segments: array_create(5, 0),
    frames: array_create(5, 0)
};

for (var i = 0; i < player_health.max; i++) {
    player_health.frames[i] = player_health.frame_full;
}

invuln = 0;
player_health_sync_aliases();

// Backwards-compatible wrappers used by enemies/upgrades.
take_damage = function(amount)
{
    return player_health_apply_damage(amount);
};

increase_max_hp = function(amount)
{
    return player_health_increase_max(amount);
};

heal_hp = function(amount)
{
    return player_health_heal(amount);
};


// Enemy lane anchors 
global.enemy_anchor_offsets = [
    [  0, -80], // TOP
    [  0,  80], // BOTTOM
    [-80,   0], // LEFT
    [ 80,   0]  // RIGHT
];

// How many enemies are assigned to each anchor
global.enemy_anchor_counts = [0, 0, 0, 0];

