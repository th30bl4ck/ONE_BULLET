var semantic_orbit_active = variable_global_exists("semantic_orbit") && global.semantic_orbit;

if (state == "orbit") {
    var tracked_bullet = noone;

    if (instance_exists(owner) && variable_instance_exists(owner, "bullet_id")) {
        tracked_bullet = owner.bullet_id;
    } else if (instance_exists(global.player) && variable_instance_exists(global.player, "bullet_id")) {
        tracked_bullet = global.player.bullet_id;
    }

    if (instance_exists(tracked_bullet) && tracked_bullet != id) {
        instance_destroy();
        exit;
    }

    if (instance_exists(owner) && variable_instance_exists(owner, "bullet_id")) {
        var owner_bullet = owner.bullet_id;
        if (instance_exists(owner_bullet) && owner_bullet != id) {
            instance_destroy();
            exit;
        }
    }

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
        orbit_angle = (orbit_angle + orbit_speed) mod 360;

        var prev_x = x;
        var prev_y = y;

        // orbit around the actual centre of the player
        var cx = (target.bbox_left + target.bbox_right) * 0.5;
        var cy = (target.bbox_top + target.bbox_bottom) * 0.5;

        x = cx + lengthdir_x(orbit_radius, orbit_angle);
        y = cy + lengthdir_y(orbit_radius, orbit_angle);

        hspeed = x - prev_x;
        vspeed = y - prev_y;

        if (hspeed != 0 || vspeed != 0) {
            direction = point_direction(0, 0, hspeed, vspeed);
        }
    }

    with (obj_player) {
        can_shoot = true;
    }
}

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


if (state == "stuck") {
    speed = 0;
    solid = false;

    if (keyboard_check_pressed(ord("R"))) {
        state = "recall";
    }

if (place_meeting(x, y, obj_player)) {
    if (semantic_orbit_active) {
        with (obj_player) {
            can_shoot = true;
        }

        var cx = (obj_player.bbox_left + obj_player.bbox_right) * 0.5;
        var cy = (obj_player.bbox_top + obj_player.bbox_bottom) * 0.5;

        orbit_radius = 32;
        orbit_angle = point_direction(cx, cy, x, y);

        state = "orbit";
        speed = 0;
        hspeed = 0;
        vspeed = 0;
    } else {
        with (obj_player) {
            bullet_id = noone;
            can_shoot = true;
        }
        instance_destroy();
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
    if (semantic_orbit_active) {
        with (obj_player) {
            can_shoot = true;
        }

        var cx = (obj_player.bbox_left + obj_player.bbox_right) * 0.5;
        var cy = (obj_player.bbox_top + obj_player.bbox_bottom) * 0.5;

        orbit_radius = 32;
        orbit_angle = point_direction(cx, cy, x, y);

        state = "orbit";
        speed = 0;
        hspeed = 0;
        vspeed = 0;
    } else {
        with (obj_player) {
            bullet_id = noone;
            can_shoot = true;
        }
        instance_destroy();
    }
}
}
}
    
if (state != "orbit") {
    image_angle = point_direction(0, 0, hspeed, vspeed);
}

image_angle = direction - 90;
