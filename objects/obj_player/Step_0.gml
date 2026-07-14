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
if (!variable_instance_exists(id, "bullet_pickup_shoot_delay")) bullet_pickup_shoot_delay = 8;
if (!variable_instance_exists(id, "bullet_pickup_shoot_timer")) bullet_pickup_shoot_timer = 0;
if (!variable_instance_exists(id, "has_creep_bullet_item")) has_creep_bullet_item = false;
if (!variable_global_exists("liquid_lead")) global.liquid_lead = false;
if (invuln > 0) invuln -= 1;


if (global.note_open) exit;


// =========================
// TILEMAP SETUP 
// =========================
scr_refresh_wall_tilemap();


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
        game_restart();
    }

    global.player_health.current = 0;
    hp_display = 0;

    exit;
}



if (invuln > 0) invuln -= 1;
if (hit_flash_timer > 0) hit_flash_timer -= 1;

global.player_health.current = clamp(global.player_health.current, 0, global.player_health.max);
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
function player_wall_collision(_x, _y) {
    var left   = bbox_left   + (_x - x);
    var right  = bbox_right  + (_x - x);
    var top    = bbox_top    + (_y - y);
    var bottom = bbox_bottom + (_y - y);

    return scr_wall_overlaps_rect(left, top, right, bottom);
}

function player_try_unstuck_from_wall() {
    if (!player_wall_collision(x, y)) return false;

    for (var r = 1; r <= 32; r++) {
        for (var dx = -r; dx <= r; dx++) {
            for (var dy = -r; dy <= r; dy++) {
                if (abs(dx) != r && abs(dy) != r) continue;

                if (!player_wall_collision(x + dx, y + dy)) {
                    x += dx;
                    y += dy;
                    is_dashing = false;
                    dash_timer = 0;
                    return true;
                }
            }
        }
    }

    return false;
}


// =========================
// APPLY MOVEMENT
// =========================
player_try_unstuck_from_wall();

if (move_x != 0) {
    var next_x = x + move_x;

    if (!player_wall_collision(next_x, y)) {
        x = next_x;
    } else {
        var step_x = sign(move_x);
        while (!player_wall_collision(x + step_x, y)) {
            x += step_x;
        }
        is_dashing = false;
        dash_timer = 0;
    }
}

if (move_y != 0) {
    var next_y = y + move_y;

    if (!player_wall_collision(x, next_y)) {
        y = next_y;
    } else {
        var step_y = sign(move_y);
        while (!player_wall_collision(x, y + step_y)) {
            y += step_y;
        }
        is_dashing = false;
        dash_timer = 0;
    }
}


// =========================
// COOLDOWNS
// =========================
if (dash_cd_timer > 0) dash_cd_timer--;
if (bullet_pickup_shoot_timer > 0) {
    bullet_pickup_shoot_timer--;
    if (bullet_pickup_shoot_timer <= 0) {
        can_shoot = true;
    }
}


// =========================
// SHOOT / RECALL 
// =========================
var semantic_orbit_active = variable_global_exists("semantic_orbit") && global.semantic_orbit;

if (semantic_orbit_active && can_shoot && bullet_pickup_shoot_timer <= 0 && !instance_exists(bullet_id)) {
    bullet_id = instance_create_layer(x, y, shoot_layer, obj_bullet);
    bullet_id.owner = id;
    bullet_id.state = "orbit";
}

if (can_shoot && bullet_pickup_shoot_timer <= 0 && (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space))) {
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

// Liquid Lead item effect
bullet_id.has_liquid_lead = global.liquid_lead;

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


//=======================
//NPC/shopkeeper
//=======================
if (keyboard_check_pressed(ord("E"))) {
    var npc = instance_nearest(x, y, obj_shopkeeper);

    if (npc != noone && point_distance(x, y, npc.x, npc.y) < 48) {
        var d = instance_find(obj_dialouge_controller, 0);

        if (d != noone) {
            d.dialogue_lines = npc.dialogue;
            d.line_index = 0;
			d.text_pos = 0;
            d.active = true;
        }
    }
}