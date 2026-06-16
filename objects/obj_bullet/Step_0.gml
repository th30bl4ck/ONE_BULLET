scr_refresh_wall_tilemap();

if (state == "stuck") {
    speed = 0;
    solid = false;

    if (keyboard_check_pressed(ord("R"))) {
        state = "recall";
    }

    if (collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true)) {

                with (obj_player) {
            can_shoot = false;
            bullet_id = noone;
            bullet_pickup_shoot_timer = bullet_pickup_shoot_delay;
        }
        instance_destroy();
    }
}


if (state == "stopped") {
    speed = 0;
    solid = false;

    if (keyboard_check_pressed(ord("R"))) {
        state = "recall";
    }

    if (collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true)) {
        with (obj_player) {
            can_shoot = false;
            bullet_id = noone;
            bullet_pickup_shoot_timer = bullet_pickup_shoot_delay;
        }
        instance_destroy();
    }
}


if (state == "fired") {
    // Stop after travelling too far
    var dist_travelled = point_distance(start_x, start_y, x, y);
    if (dist_travelled >= max_distance) {
        speed = 0;
        hspeed = 0;
        vspeed = 0;
        state = "stopped";
    }

    // Wall tiles + obj_wall instances (same as player movement).
    if (state == "fired") {
        if (scr_wall_overlaps_rect(bbox_left, bbox_top, bbox_right, bbox_bottom)) {
            speed = 0;
            hspeed = 0;
            vspeed = 0;
            state = "stuck";
        }
    }
}

if (state == "recall") {
    var target = noone;
    if (instance_exists(owner)) {
        target = owner;
    } else if (variable_global_exists("player") && instance_exists(global.player)) {
        target = global.player;
    }

    if (target != noone) {
        direction = point_direction(x, y, target.x, target.y);
        speed = global.recall_speed;
    }

    if (collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true)) {
        with (obj_player) {
            can_shoot = false;
            bullet_id = noone;
            bullet_pickup_shoot_timer = bullet_pickup_shoot_delay;
        }
        instance_destroy();
    }
}

if (global.the_jerk == true) {
    image_xscale = 2;
    image_yscale = 2;
}

image_angle = direction - 90;
