x += lengthdir_x(spd, dir);
y += lengthdir_y(spd, dir);

life--;
if (life <= 0) instance_destroy();

// if you have walls, change obj_wall to your wall object name
if (instance_exists(obj_wall) && place_meeting(x, y, obj_wall)) {
    instance_destroy();
}


if (place_meeting(x, y, obj_player)) {
    with (obj_player) {

        // only take damage if not invulnerable
        if (invuln <= 0) {
            take_damage(1);
            invuln = 30; // half-second of safety
            hit_flash_timer = 15;

            if (variable_global_exists("room_damage_taken")) {
                global.room_damage_taken += 1;
            }

     
        }

        // if HP is zero or below → start death
        if (hp <= 0) {
            state = "dying";
            sprite_index = spr_player_death;
            image_index = 0;
            image_speed = 1;
        }
    }
    instance_destroy();
}