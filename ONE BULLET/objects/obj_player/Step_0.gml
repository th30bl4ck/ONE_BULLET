// =========================
// DEATH SEQUENCE 
// =========================
if (state == "dying") {

    input_locked = true;

    // Freeze player
    hspeed = 0;
    vspeed = 0;

    // Kill enemies
    with (obj_enemy) instance_destroy();
    with (obj_XP) instance_destroy(); 
    with (obj_XP_bar) instance_destroy();
   
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

if (!is_dashing) {
    var dir = point_direction(0,0, h, v);
    if (h != 0 || v != 0) {
        x += lengthdir_x(move_speed, dir);
        y += lengthdir_y(move_speed, dir);
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
    x += lengthdir_x(dash_speed, dash_dir);
    y += lengthdir_y(dash_speed, dash_dir);

    dash_timer--;
    if (dash_timer <= 0) {
        is_dashing = false;
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
    bullet_id.speed = 10;
    bullet_id.owner = id;

    can_shoot = false;
}

// Smooth HP bar transition
hp_display = lerp(hp_display, hp, 0.1);

if (global.levelup_active)
{
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
}
