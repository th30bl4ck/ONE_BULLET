if (!ai_enabled) exit;


var p = obj_player;
direction = point_direction(x, y, p.x, p.y);
x += lengthdir_x(move_speed, direction);
y += lengthdir_y(move_speed, direction);

if (place_meeting(x, y, obj_player)) {
    with (obj_player) {
        if (state != "dying") {
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
