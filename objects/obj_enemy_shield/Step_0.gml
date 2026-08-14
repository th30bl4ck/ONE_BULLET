if (global.note_open || global.levelup_active) exit;

if (hp <= 0) {
    instance_destroy();
    exit;
}

if (!instance_exists(owner) && state != "abandoned") {
    state = "abandoned";
}

var target_sink = is_underground ? 1 : 0;
sink_factor = lerp(sink_factor, target_sink, 0.15);

if (sink_factor < 0.5 && place_meeting(x, y, obj_player)) {
    with (obj_player) {
        if (invuln <= 0) {
            take_damage(1);
            invuln = 60; 
            hit_flash_timer = 15;
            if (variable_global_exists("room_damage_taken")) {
                global.room_damage_taken += 1;
            }
        }
        if (hp <= 0) {
            state = "dying";
            sprite_index = spr_player_death;
            image_index = 0;
            image_speed = 1;
        }
    }
}

switch (state) {
    case "idle":
        break;

    case "chasing":
        if (instance_exists(obj_player)) {
            var dir = point_direction(x, y, obj_player.x, obj_player.y);
            x += lengthdir_x(move_speed, dir);
            y += lengthdir_y(move_speed, dir);
        }

        chase_timer--;
        popup_timer--;

        if (popup_timer <= 0) {
            is_underground = !is_underground; 
            popup_timer = 60; 
        }

        if (chase_timer <= 0) {
            is_underground = false;
            state = "returning"; 
        }
        break;

    case "returning":
        if (instance_exists(owner)) {
            var dir = point_direction(x, y, owner.x, owner.y);
            x += lengthdir_x(move_speed * 1.5, dir); 
            y += lengthdir_y(move_speed * 1.5, dir);

            if (point_distance(x, y, owner.x, owner.y) < 10) {
                state = "idle";
                owner.shield_deployed = false; 
            }
        } else {
            state = "abandoned";
        }
        break;

    case "abandoned":
        is_underground = false;
        break;
}