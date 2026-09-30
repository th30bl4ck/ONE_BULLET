if (global.note_open || global.levelup_active) exit;
if (!instance_exists(obj_player)) exit;
    
event_inherited();

flash_red--;

var px = obj_player.x;
var py = obj_player.y;
dasher_dist = point_distance(x, y, px, py);

var wall_in_way = (collision_line(x, y, px, py, obj_wall, false, false) != noone);

var enemy_speed = move_speed;
if (variable_instance_exists(id, "slowed") && slowed) {
    enemy_speed *= slow_multiplier;
}

switch (state)
{
    case "chase":
        if (dasher_dist > mid_range || wall_in_way)
        {
            if (path_index == -1 && alarm[0] <= 0) {
                alarm[0] = 1; 
            }
        }
        else
        {
            if (path_index != -1) path_end();

            state = "charge";
            charge_timer = charge_time;
            dash_target_x = px;
            dash_target_y = py;
        }
        break;

    case "charge":
        if (path_index != -1) path_end();

        image_blend = (charge_timer mod 6 < 3) ? c_red : c_white;
        charge_timer--;

        if (charge_timer <= 0) {
            image_blend = c_white;
            state = "dash";
        }
        break;

    case "dash":
        if (path_index != -1) path_end();

        var dist_left = point_distance(x, y, dash_target_x, dash_target_y);

        if (dist_left <= dash_speed || place_meeting(x, y, obj_wall)) {
            state = "cooldown";
            cooldown_timer = cooldown_time;
            image_blend = c_white;
        } else {
            var dash_dir = point_direction(x, y, dash_target_x, dash_target_y);
            x += lengthdir_x(dash_speed, dash_dir);
            y += lengthdir_y(dash_speed, dash_dir);
        }
        break;

    case "cooldown":
        cooldown_timer--;
        if (cooldown_timer <= 0) {
            state = "chase";
        }
        break;
}

if (obj_player.x > x) {
    image_xscale = 1.3;
} else {
    image_xscale = -1.3;
}

if (place_meeting(x, y, obj_player)) {
    with (obj_player) {
        if (invuln <= 0) {
            take_damage(1);
            invuln = 60; 
            hit_flash_timer = 15;
            if (variable_global_exists("room_damage_taken")) global.room_damage_taken += 1;
        }
        if (hp <= 0) {
            state = "dying";
            sprite_index = spr_player_death;
            image_index = 0;
            image_speed = 1;
        }
    }
}