// PICKUP WHILE STUCK
if (state == "stuck") {
    speed = 0;
    solid = false;

    if (keyboard_check_pressed(ord("R"))) {
        state = "recall";
    }

    // Player pickup works reliably here
    if (place_meeting(x, y, obj_player)) {
        with (obj_player) {
            can_shoot = true;
        }
        instance_destroy();
    }
}

if (state == "recall") {
    var target = noone;
    if (instance_exists(owner)) {
        target = owner;
    } else if (instance_exists(global.player)) {
        target = global.player;
    }

    if (target != noone) {
        direction = point_direction(x, y, target.x, target.y);
        speed = 20;
    }

    if (place_meeting(x, y, obj_player)) {
        with (obj_player) {
            can_shoot = true;
        }
        instance_destroy();
    }
}

image_angle = point_direction(0, 0, hspeed, vspeed);

image_angle = direction - 90;
