if (global.note_open || global.levelup_active || !ai_enabled) exit;

var px = obj_player.x;
var py = obj_player.y;
var dist_to_player = point_distance(x, y, px, py);

// Face the player
image_xscale = (px > x) ? 1 : -1;

if (instance_exists(shield)) {
    if (!shield_deployed && dist_to_player <= mid_range) {
        shield_deployed = true;
        shield.state = "chasing";
        shield.chase_timer = 20 * 60; 
        shield.popup_timer = 60;      
    }
    
    if (!shield_deployed) {
        shield.x = x;
        shield.y = y;
    }
}

var sight = collision_line(x, y, px, py, obj_wall, false, false);
if (sight == noone) {
    var dir = point_direction(x, y, px, py);
    x += lengthdir_x(move_speed, dir);
    y += lengthdir_y(move_speed, dir);
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

flash_red--;