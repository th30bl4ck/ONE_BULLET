if (!ai_enabled) exit;


var p = obj_player;
direction = point_direction(x, y, p.x, p.y);
x += lengthdir_x(move_speed, direction);
y += lengthdir_y(move_speed, direction);

if (place_meeting(x, y, obj_player)) {
    with (obj_player) {

        // only take damage if not invulnerable
        if (invuln <= 0) {
            hp -= 1;
            invuln = 30; // half-second of safety
            hit_flash_timer = 15;

            // optional knockback
            // hspeed = (other.x - x) * 0.2;
            // vspeed = (other.y - y) * 0.2;
        }

        // if HP is zero or below → start death
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
    image_xscale = 1;    // Face right
} else {
    image_xscale = -1;   // Face left
}
