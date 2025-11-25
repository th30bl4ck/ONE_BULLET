
// ----- Movement (8-way) -----
var mx = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var my = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var spd = point_distance(0,0,mx,my);
if (spd > 0) {
    var dir = point_direction(0,0,mx,my);
    x += lengthdir_x(move_speed * spd, dir);
    y += lengthdir_y(move_speed * spd, dir);
}

// ----------------------
// Basic movement
// ----------------------
var h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var v = keyboard_check(ord("S")) - keyboard_check(ord("W"));

if (!is_dashing) {
    // normal movement
    var dir = point_direction(0,0, h, v);
    var spd = move_speed;
    if (h != 0 || v != 0) {
        x += lengthdir_x(spd, dir);
        y += lengthdir_y(spd, dir);
    }
}

// ----------------------
// Dash input
// ----------------------
if (keyboard_check_pressed(vk_shift) && dash_cd_timer <= 0 && !is_dashing) {

    // dash direction = direction player is moving OR last facing direction
    dash_dir = point_direction(0,0, h, v);
    if (h == 0 && v == 0) dash_dir = image_angle; // fallback

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


// ----- Shoot (Left Mouse or Space) -----
if (can_shoot && (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space))) {
    var dir = point_direction(x, y, mouse_x, mouse_y);

    // Spawn slightly in front of player to avoid overlap
    var bx = x + lengthdir_x(12, dir);
    var by = y + lengthdir_y(12, dir);

    bullet_id = instance_create_layer(bx, by, shoot_layer, obj_bullet);
    bullet_id.direction = dir;
    bullet_id.speed = 10;
    bullet_id.owner = id;

    can_shoot = false;
}

/// PLAYER STEP EVENT

// =========================
// DEATH SEQUENCE
// =========================
if (state == "dying") {

    // Lock all controls (this stops movement even if movement is outside Step)
    input_locked = true;

    // Stop movement fully
    hspeed = 0;
    vspeed = 0;

    // Delete all enemies
    with (obj_enemy) instance_destroy();

    // Camera handling
    var cam = view_camera[0];
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);

    // Sprite size
    var sw = sprite_get_width(sprite_index);
    var sh = sprite_get_height(sprite_index);

    // How tight the zoom is (4 = medium zoom)
    var target_w = sw * 4;
    var target_h = sh * 4;

    // Zoom until player fits nicely in frame
    if (cam_w > target_w && cam_h > target_h) {

        var new_w = cam_w * 0.98; // smooth zoom
        var new_h = cam_h * 0.98;

        camera_set_view_size(cam, new_w, new_h);
        camera_set_view_pos(cam, x - new_w * 0.5, y - new_h * 0.5);
    }

    // When death animation ends → restart
    if (image_index >= image_number - 1) {
        game_restart();
    }

    // Skip ALL movement + normal gameplay logic
    exit;
}
