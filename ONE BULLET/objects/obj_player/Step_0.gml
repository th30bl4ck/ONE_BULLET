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

