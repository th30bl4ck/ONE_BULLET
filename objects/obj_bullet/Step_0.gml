var semantic_orbit_active = variable_global_exists("semantic_orbit") && global.semantic_orbit;

if (state == "orbit") {
    speed = 0;
    hspeed = 0;
    vspeed = 0;

    var target = noone;
    if (instance_exists(owner)) {
        target = owner;
    } else if (instance_exists(global.player)) {
        target = global.player;
    }

    if (target != noone) {
        orbit_angle += orbit_speed;

        var prev_x = x;
        var prev_y = y;

        x = target.x + lengthdir_x(orbit_radius, orbit_angle);
        y = target.y + lengthdir_y(orbit_radius, orbit_angle);

        hspeed = x - prev_x;
        vspeed = y - prev_y;
        direction = point_direction(0, 0, hspeed, vspeed);
    }

    with (obj_player) {
        can_shoot = true;
    }
}

if (state == "stuck") {
    speed = 0;
    solid = false;

    if (keyboard_check_pressed(ord("R"))) {
        state = "recall";
    }

    if (place_meeting(x, y, obj_player)) {
        with (obj_player) {
            can_shoot = true;
        }
        if (semantic_orbit_active) {
            state = "orbit";
        } else {
            instance_destroy();
        }
    }
}

if (state == "fired") {
    if (variable_global_exists("wall_tilemap_id") && global.wall_tilemap_id != noone) {
        if (tilemap_get_at_pixel(global.wall_tilemap_id, bbox_left, bbox_top) != 0
        || tilemap_get_at_pixel(global.wall_tilemap_id, bbox_right, bbox_top) != 0
        || tilemap_get_at_pixel(global.wall_tilemap_id, bbox_left, bbox_bottom) != 0
        || tilemap_get_at_pixel(global.wall_tilemap_id, bbox_right, bbox_bottom) != 0) {
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
    } else if (instance_exists(global.player)) {
        target = global.player;
    }

    if (target != noone) {
        direction = point_direction(x, y, target.x, target.y);
        speed = global.recall_speed;
    }

    if (place_meeting(x, y, obj_player)) {
        with (obj_player) {
            can_shoot = true;
        }
        if (semantic_orbit_active) {
            state = "orbit";
            speed = 0;
            hspeed = 0;
            vspeed = 0;
        } else {
            instance_destroy();
        }
    }
}

if (state != "orbit") {
    image_angle = point_direction(0, 0, hspeed, vspeed);
}

image_angle = direction - 90;
