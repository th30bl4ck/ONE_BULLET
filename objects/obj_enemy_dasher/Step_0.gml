var enemy_speed = move_speed;

if (variable_instance_exists(id, "slowed") && slowed) {
    enemy_speed *= slow_multiplier;
}if (global.note_open) exit;

if (global.levelup_active) exit;

var px = obj_player.x;
var py = obj_player.y;
var dist = point_distance(x, y, px, py);

// =====================
// CHASE STATE
// =====================
if (state == "chase") {

    // Move toward player
    var dir = point_direction(x, y, px, py);
    x += lengthdir_x(enemy_speed, dir);
    y += lengthdir_y(move_speed, dir);

    // If player enters mid-range begin charge
    if (dist < mid_range) {
        state = "charge";
        charge_timer = charge_time;

        // Lock the dash target at this moment
        dash_target_x = px;
        dash_target_y = py;
    }
}



// =====================
// CHARGE STATE 
// =====================
else if (state == "charge") {

    // Flash red while charging
    image_blend = (charge_timer mod 6 < 3) ? c_red : c_white;

    charge_timer--;

    if (charge_timer <= 0) {
        // Reset colour before dashing
        image_blend = c_white;

        state = "dash";
    }
}


// =====================
// DASH STATE 
// =====================
else if (state == "dash") {

    var d = point_direction(x, y, dash_target_x, dash_target_y);
    x += lengthdir_x(dash_speed, d);
    y += lengthdir_y(dash_speed, d);

    // When he arrives close to destination → go into cooldown
    if (point_distance(x, y, dash_target_x, dash_target_y) < 8) {
        state = "cooldown";
        cooldown_timer = cooldown_time;
        image_blend = c_white;
    }
}

// =====================
// COOLDOWN STATE
// =====================
else if (state == "cooldown") {

    // Stand still
    cooldown_timer--;

    if (cooldown_timer <= 0) {
        state = "chase"; // resume normal behaviour
    }
}

// Face direction of player
if (obj_player.x > x) {
    image_xscale = 1;    // Face right
} else {
    image_xscale = -1;   // Face left
}

// Damage player on touch
if (place_meeting(x, y, obj_player)) {
    with (obj_player) {

        // only take damage if not invulnerable
        if (invuln <= 0) {
            take_damage(1);
            invuln = 30; 
            hit_flash_timer = 15;

            if (variable_global_exists("room_damage_taken")) {
                global.room_damage_taken += 1;
            }
        }

        // if HP is zero or below start death
        if (hp <= 0) {
            state = "dying";
            sprite_index = spr_player_death;
            image_index = 0;
            image_speed = 1;
        }
    }
}


// =====================
// SEPARATION FROM OTHER DASHERS
// =====================

with (obj_enemy_dasher)
{
    if (id != other.id)
    {
        var sep_dist = point_distance(x, y, other.x, other.y);

        if (sep_dist < 20 && sep_dist > 0) 
        {
            var sep_dir = point_direction(other.x, other.y, x, y);

            var sep_push =  (state == "dash" || other.state == "dash") ? 2 : 0.5;

            x += lengthdir_x(sep_push, sep_dir);
            y += lengthdir_y(sep_push, sep_dir);
        }
    }
}

// Anchor target 
if (!instance_exists(obj_player)) exit;

if (!variable_instance_exists(id, "anchor_id"))
{
    anchor_id = irandom(3);
    anchor_jitter = irandom_range(-18, 18);
    anchor_claimed = false;
}

var ox = global.enemy_anchor_offsets[anchor_id][0];
var oy = global.enemy_anchor_offsets[anchor_id][1];

var tx = obj_player.x + ox;
var ty = obj_player.y + oy;

tx += anchor_jitter;
ty += anchor_jitter * 0.5;


if (state != "charge")
{
    var dir = point_direction(x, y, tx, ty);
    x += lengthdir_x(enemy_speed, dir);
    y += lengthdir_y(move_speed, dir);
}
