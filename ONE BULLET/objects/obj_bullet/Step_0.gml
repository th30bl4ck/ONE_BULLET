// PICKUP WHILE STUCK
if (state == "stuck") {
    speed = 0;
    solid = false;

    // Player pickup works reliably here
    if (place_meeting(x, y, obj_player)) {
        with (obj_player) {
            can_shoot = true;
        }
        instance_destroy();
    }
}

image_angle = point_direction(0, 0, hspeed, vspeed);

image_angle = direction - 90;
