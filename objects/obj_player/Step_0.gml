if (!variable_instance_exists(id, "state")) state = "alive";
if (!variable_instance_exists(id, "input_locked")) input_locked = false;

if (!variable_instance_exists(id, "invuln")) invuln = 0;

if (!variable_instance_exists(id, "hit_flash_timer")) hit_flash_timer = 0;

if (!variable_instance_exists(id, "is_dashing")) is_dashing = false;
if (!variable_instance_exists(id, "dash_timer")) dash_timer = 0;
if (!variable_instance_exists(id, "dash_cd_timer")) dash_cd_timer = 0;
if (!variable_instance_exists(id, "dash_dir")) dash_dir = 0;

if (!variable_instance_exists(id, "can_shoot")) can_shoot = true;
if (!variable_instance_exists(id, "bullet_id")) bullet_id = noone;


if (invuln > 0) invuln -= 1;


if (global.note_open) exit;


// =========================
// TILEMAP SETUP (FIXED)
// =========================
if (!variable_global_exists("wall_tilemap_id")) {
    global.wall_tilemap_id = noone;
    global.wall_tilemap_room = noone;
}

if (global.wall_tilemap_room != room) {
    global.wall_tilemap_room = room;

    var wall_layer_id = layer_get_id("Walls");

    if (wall_layer_id != -1) {
        global.wall_tilemap_id = layer_tilemap_get_id(wall_layer_id);
    } else {
        global.wall_tilemap_id = noone;
        show_debug_message("WARNING: No wall layer found");
    }
}


// =========================
// DEATH SEQUENCE
// =========================
if (state == "dying") {

    input_locked = true;

    hspeed = 0;
    vspeed = 0;

    with (obj_enemy_walker) instance_destroy();
    with (obj_XP) instance_destroy();
    with (obj_XP_bar) instance_destroy();
    with (obj_enemy_dasher) instance_destroy();
    with (obj_enemy_shooter) instance_destroy();
    with (obj_enemy_splitter) instance_destroy();
    for (var i = 0; i < 5; i++)
    {
        with (obj_enemy_splitter_kids) instance_destroy();
    }

    var cam = view_camera[0];

    if (!death_cam_locked) {
        death_cam_x = camera_get_view_x(cam);
        death_cam_y = camera_get_view_y(cam);
        death_cam_locked = true;
    }

    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);

    var sw = sprite_get_width(sprite_index);
    var sh = sprite_get_height(sprite_index);

    var target_w = sw * 4;
    var target_h = sh * 4;

    if (cam_w > target_w) {
        cam_w *= 0.98;
        cam_h *= 0.98;
        camera_set_view_size(cam, cam_w, cam_h);
    }

    cam_w = camera_get_view_width(cam);
    cam_h = camera_get_view_height(cam);

    var target_x = x - cam_w * 0.45;
    var target_y = y - cam_h * 0.45;

    death_cam_x = lerp(death_cam_x, target_x, 0.2);
    death_cam_y = lerp(death_cam_y, target_y, 0.2);

    camera_set_view_pos(cam, death_cam_x, death_cam_y);

    if (image_index >= image_number - 1) {
        if (variable_global_exists("upgrade_counts") && global.upgrade_counts != noone)
        {
            ds_map_destroy(global.upgrade_counts);
        }
        global.upgrade_counts = ds_map_create();
        global.xp_attract_range = 64 + 32;
        global.bullet_pierce = false;
        global.semantic_orbit = false;
        global.coins = 0;
        game_restart();
    }

    global.player_health.current = 0;
    hp_display = 0;

    exit;
}


// =========================
// NORMAL UPDATE
// =========================
if (invuln > 0) invuln -= 1;
if (hit_flash_timer > 0) hit_flash_timer -= 1;

global.player_health.current = clamp(global.player_health.current, 0, player_health.max);
player_health_sync_aliases();

if (hp <= 0 && state != "dying") {
    state = "dying";
    sprite_index = spr_player_death;
    image_index = 0;
    image_speed = 1;
    hp_display = 0;
    exit;
}


// =========================
// LEVEL UP MENU
// =========================
if (global.levelup_active)
{
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


// =========================
// MOVEMENT LOCK
// =========================
if (input_locked) {
    hspeed = 0;
    vspeed = 0;
    exit;
}


// =========================
// INPUT
// =========================
var h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var v = keyboard_check(ord("S")) - keyboard_check(ord("W"));

if (v == -1 && h == 1) sprite_index = spr_topright;
else if (v == 1 && h == 1) sprite_index = spr_downright;
else if (v == 1 && h == -1) sprite_index = spr_downleft;
else if (v == -1 && h == -1) sprite_index = spr_topleft;
else if (v == -1 && h == 0) sprite_index = spr_back;
else if (v == 0 && h == 1) sprite_index = spr_right;
else if (v == 1 && h == 0) sprite_index = spr_player;
else if (v == 0 && h == -1) sprite_index = spr_left;


// =========================
// MOVEMENT
// =========================
var move_x = 0;
var move_y = 0;

if (!is_dashing) {
    var dir = point_direction(0,0, h, v);
    if (h != 0 || v != 0) {
        move_x = lengthdir_x(move_speed, dir);
        move_y = lengthdir_y(move_speed, dir);
    }
}


// =========================
// DASH
// =========================
if (keyboard_check_pressed(vk_shift) && dash_cd_timer <= 0 && !is_dashing) {

    dash_dir = point_direction(0,0, h, v);
    if (h == 0 && v == 0) dash_dir = image_angle;

    is_dashing = true;
    dash_timer = dash_time;
    dash_cd_timer = dash_cooldown;
}

if (is_dashing) {
    move_x += lengthdir_x(dash_speed, dash_dir);
    move_y += lengthdir_y(dash_speed, dash_dir);

    dash_timer--;
    if (dash_timer <= 0) {
        is_dashing = false;
    }
}


// =========================
// COLLISION 
// =========================
function wall_tilemap_collision(_x, _y) {

    if (global.wall_tilemap_id == noone) return false;

    var left   = bbox_left   + (_x - x);
    var right  = bbox_right  + (_x - x);
    var top    = bbox_top    + (_y - y);
    var bottom = bbox_bottom + (_y - y);

    var t1 = tilemap_get_at_pixel(global.wall_tilemap_id, left, top);
    var t2 = tilemap_get_at_pixel(global.wall_tilemap_id, right, top);
    var t3 = tilemap_get_at_pixel(global.wall_tilemap_id, left, bottom);
    var t4 = tilemap_get_at_pixel(global.wall_tilemap_id, right, bottom);

    return (t1 > 0) || (t2 > 0) || (t3 > 0) || (t4 > 0);
}


// =========================
// APPLY MOVEMENT
// =========================
if (move_x != 0) {
    var next_x = x + move_x;

    if (!wall_tilemap_collision(next_x, y)) {
        x = next_x;
    } else {
        var step_x = sign(move_x);
        while (!wall_tilemap_collision(x + step_x, y)) {
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
        while (!wall_tilemap_collision(x, y + step_y)) {
            y += step_y;
        }
    }
}


// =========================
// COOLDOWNS
// =========================
if (dash_cd_timer > 0) dash_cd_timer--;


// =========================
// SHOOT / RECALL 
// =========================
var semantic_orbit_active = variable_global_exists("semantic_orbit") && global.semantic_orbit;

if (semantic_orbit_active && can_shoot && !instance_exists(bullet_id)) {
    bullet_id = instance_create_layer(x, y, shoot_layer, obj_bullet);
    bullet_id.owner = id;
    bullet_id.state = "orbit";
}

if (can_shoot && (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space))) {
    var dir = point_direction(x, y, mouse_x, mouse_y);

    var bx = x + lengthdir_x(12, dir);
    var by = y + lengthdir_y(12, dir);

    bullet_id = instance_create_layer(bx, by, shoot_layer, obj_bullet);
    bullet_id.direction = dir;
    bullet_id.speed = global.player_bullet_speed;
    bullet_id.owner = id;

    bullet_id.start_x = bullet_id.x;
    bullet_id.start_y = bullet_id.y;
    bullet_id.max_distance = global.bullet_max_distance;
    bullet_id.state = "fired";

    can_shoot = false;
}

if (keyboard_check_pressed(ord("R"))) {
    if (instance_exists(bullet_id)) {
        if (bullet_id.state != "orbit") {
            bullet_id.state = "recall";
        }
    }
}


// =========================
// COMBO / VISUALS
// =========================
if (combo_timer > 0) combo_timer--;
else if (combo_count > 0) {
    combo_count = 0;
    combo_heat = 0;
}

if (combo_count == 5 || combo_count == 10) {
    camera_shake = 4;
}

if (combo_count >= 10) {
    game_speed = 0.9;
}

player_health_update_visuals();