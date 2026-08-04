if (global.note_open) exit;

if (global.levelup_active) exit;

if (!ai_enabled) exit;


if (place_meeting(x, y, obj_player)) {
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


// Face direction of player
if (obj_player.x > x) {
    image_xscale = 1;
} else {
    image_xscale = -1;
}


