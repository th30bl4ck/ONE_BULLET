if (global.note_open) exit;

// =========================
// DEATH SEQUENCE 
// =========================
if (state == "dying") {

    input_locked = true;

    // Freeze player
    hspeed = 0;
    vspeed = 0;

    // Kill enemies
    with (obj_enemy_walker) instance_destroy();
    with (obj_XP) instance_destroy(); 
    with (obj_XP_bar) instance_destroy();
    with (obj_enemy_dasher) instance_destroy();
    with (obj_enemy_shooter) instance_destroy();
    with (obj_enemy_splitter) instance_destroy();
    with (obj_enemy_splitter_kids) instance_destroy();
	
     var cam = view_camera[0];

    if (!death_cam_locked) {
        death_cam_x = camera_get_view_x(cam);
        death_cam_y = camera_get_view_y(cam);
        death_cam_locked = true;
    }

    // Current size
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);

    // Player sprite size (zoom limit)
    var sw = sprite_get_width(sprite_index);
    var sh = sprite_get_height(sprite_index);

    var target_w = sw * 4;
    var target_h = sh * 4;

    // Smooth zoom
    if (cam_w > target_w) {
        cam_w *= 0.98;
        cam_h *= 0.98;
        camera_set_view_size(cam, cam_w, cam_h);
    }

    // New camera size (after zoom)
    cam_w = camera_get_view_width(cam);
    cam_h = camera_get_view_height(cam);

    // Smooth drift toward player using CURRENT camera size
    var target_x = x - cam_w * 0.45;
    var target_y = y - cam_h * 0.45;

    death_cam_x = lerp(death_cam_x, target_x, 0.2);
    death_cam_y = lerp(death_cam_y, target_y, 0.2);

    camera_set_view_pos(cam, death_cam_x, death_cam_y);

    // Restart when animation ends
    if (image_index >= image_number - 1) {
        if (variable_global_exists("upgrade_counts") && global.upgrade_counts != noone)
        {
            ds_map_destroy(global.upgrade_counts);
        }
        global.upgrade_counts = ds_map_create();
        global.xp_attract_range = 64 + 32;
        global.bullet_pierce = false;
        global.coins = 0;
        game_restart();
    }

    hp_display = 0;
    
    exit;
}


// ======================================================
// EVERYTHING BELOW THIS POINT ONLY RUNS IF NOT DYING
// ======================================================

if (invuln > 0) invuln -= 1;
if (hit_flash_timer > 0) hit_flash_timer -= 1;


// =========================
// LEVEL UP MENU (PAUSE)
// =========================
if (global.levelup_active)
{
    // Freeze player movement
    hspeed = 0;
    vspeed = 0;
    is_dashing = false;

    if (keyboard_check_pressed(ord("1")))
    {
        scr_apply_upgrade(global.choice_1);
        close_levelup_menu();
    }

    if (keyboard_check_pressed(ord("2")))
    {
        scr_apply_upgrade(global.choice_2);
        close_levelup_menu();
    }

    exit;
}


// ===== Movement Lock =====
if (input_locked) {
    hspeed = 0;
    vspeed = 0;
    exit;
}



// ----------------------
// Basic movement
// ----------------------
var h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var v = keyboard_check(ord("S")) - keyboard_check(ord("W"));

var move_up = keyboard_check(ord("W"));
var move_down = keyboard_check(ord("S"));
var move_left = keyboard_check(ord("A"));
var move_right = keyboard_check(ord("D"));

if (move_up && move_right) {
    sprite_index = spr_topright;
} else if (move_right && move_down) {
    sprite_index = spr_downright;
} else if (move_down && move_left) {
    sprite_index = spr_downleft;
} else if (move_left && move_up) {
    sprite_index = spr_topleft;
} else if (move_up) {
    sprite_index = spr_back;
} else if (move_right) {
    sprite_index = spr_right;
} else if (move_down) {
    sprite_index = spr_player;
} else if (move_left) {
    sprite_index = spr_left;
}

var move_x = 0;
var move_y = 0;

if (!is_dashing) {
    var dir = point_direction(0,0, h, v);
    if (h != 0 || v != 0) {
        move_x += lengthdir_x(move_speed, dir);
        move_y += lengthdir_y(move_speed, dir);
    }
}


// ----------------------
// Dash input
// ----------------------
if (keyboard_check_pressed(vk_shift) && dash_cd_timer <= 0 && !is_dashing) {

    dash_dir = point_direction(0,0, h, v);
    if (h == 0 && v == 0) dash_dir = image_angle;

    is_dashing = true;
    dash_timer = dash_time;
    dash_cd_timer = dash_cooldown;
}


// ----------------------
// Dash movement
// ----------------------
if (is_dashing) {
    move_x += lengthdir_x(dash_speed, dash_dir);
    move_y += lengthdir_y(dash_speed, dash_dir);

    dash_timer--;
    if (dash_timer <= 0) {
        is_dashing = false;
    }
}

function wall_tilemap_collision(_x, _y) {
    if (!variable_global_exists("wall_tilemap_id")) return false;
    if (global.wall_tilemap_id == noone) return false;

    var left = bbox_left + (_x - x);
    var right = bbox_right + (_x - x);
    var top = bbox_top + (_y - y);
    var bottom = bbox_bottom + (_y - y);

    return tilemap_get_at_pixel(global.wall_tilemap_id, left, top) != 0
        || tilemap_get_at_pixel(global.wall_tilemap_id, right, top) != 0
        || tilemap_get_at_pixel(global.wall_tilemap_id, left, bottom) != 0
        || tilemap_get_at_pixel(global.wall_tilemap_id, right, bottom) != 0;
}

if (move_x != 0) {
    var next_x = x + move_x;
    if (!wall_tilemap_collision(next_x, y)) {
        x = next_x;
    } else {
        var step_x = sign(move_x);
        while (step_x != 0 && !wall_tilemap_collision(x + step_x, y)) {
            x += step_x;
        }
    }
}

if (move_y != 0) {
    var next_y = y + move_y;
    if (!wall_tilemap_collision(x, next_y)) {
        y = next_y;
    } else {
        var step_y = sign(move_y);
        while (step_y != 0 && !wall_tilemap_collision(x, y + step_y)) {
            y += step_y;
        }
    }
}


// ----------------------
// Cooldown
// ----------------------
if (dash_cd_timer > 0) {
    dash_cd_timer--;
}


// ----- Shoot -----
if (can_shoot && (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space))) {

    var dir = point_direction(x, y, mouse_x, mouse_y);

    var bx = x + lengthdir_x(12, dir);
    var by = y + lengthdir_y(12, dir);

    bullet_id = instance_create_layer(bx, by, shoot_layer, obj_bullet);
    bullet_id.direction = dir;
    bullet_id.speed = global.player_bullet_speed;
    bullet_id.owner = id;

    can_shoot = false;
}

// ----- Recall -----
if (keyboard_check_pressed(ord("R"))) {
    if (instance_exists(bullet_id) && bullet_id.state == "stuck") {
        bullet_id.state = "recall";
    }
}

//combo
if (combo_timer > 0) {
    combo_timer--;
} else if (combo_count > 0) {
    combo_count = 0;
    combo_heat = 0;
}

if (combo_count == 5 || combo_count == 10) {
    camera_shake = 4;
}

if (combo_count >= 10) {
    game_speed = 0.9;
}

var count = min(max_hp, array_length(hp_segments));

for (var i = 0; i < count; i++)
{
    if (hp_segments[i] > 0 && hp_segments[i] < 8)
    {
        hp_segments[i] += 0.25;
    }

    if (hp_segments[i] >= 8)
    {
        hp_segments[i] = 8; // lock to empty frame
    }
}


//damage
function take_damage(amount)
{
    repeat (amount)
    {
        if (hp > 0)
        {
            hp--;
            hp_segments[hp] = 1;
        }
    }
}

function increase_max_hp(amount)
{
    max_hp += amount;
    hp += amount;

    var old_len = array_length(hp_segments);
    array_resize(hp_segments, max_hp);

    for (var i = old_len; i < max_hp; i++)
    {
        hp_segments[i] = 0; // FULL frame
    }
}

heal_hp = function(amount)
{
    repeat (amount)
    {
        if (hp < max_hp)
        {
            hp_segments[hp] = 0; // refill this segment
            hp += 1;
            hp_display = hp;
        }
    }
};

function approach(_cur, _tgt, _amt)
{
    if (_cur < _tgt) return min(_cur + _amt, _tgt);
    if (_cur > _tgt) return max(_cur - _amt, _tgt);
    return _cur;
}


if (array_length(hp_frames) != max_hp) {
    var old = hp_frames;
    hp_frames = array_create(max_hp, 0);
    for (var i = 0; i < min(array_length(old), max_hp); i++) hp_frames[i] = old[i];
    for (var i = array_length(old); i < max_hp; i++) hp_frames[i] = 0;
}

var frames = sprite_get_number(spr_healthbar);
var frame_full  = 0;
var frame_empty = frames - 1;

var anim_spd = 0.4; 


for (var i = 0; i < max_hp; i++) {
    var target = (i < hp) ? frame_full : frame_empty;
    hp_frames[i] = approach(hp_frames[i], target, anim_spd);
}


hp_prev = hp;
