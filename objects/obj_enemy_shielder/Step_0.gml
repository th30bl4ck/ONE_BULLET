if (global.note_open || global.levelup_active || !ai_enabled) exit;
if (!instance_exists(obj_player)) exit;

var px = obj_player.x;
var py = obj_player.y;
var dist_to_player = point_distance(x, y, px, py);

image_xscale = (px > x) ? 2 : -2;

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

var sight_blocked = (collision_line(x, y, px, py, obj_wall, false, false) != noone);

if (sight_blocked) {
    if (path_index == -1 && alarm[0] <= 0) {
        alarm[0] = 1;
    }
} else {
    if (path_index != -1) {
        path_end();
    }
    
    var dir = point_direction(x, y, px, py);
    var hspd = lengthdir_x(move_speed, dir);
    var vspd = lengthdir_y(move_speed, dir);
    
    if (!place_meeting(x + hspd, y, obj_wall)) x += hspd;
    if (!place_meeting(x, y + vspd, obj_wall)) y += vspd;
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

if (flash_red > 0) flash_red--;
    
