var p = obj_player;
direction = point_direction(x, y, p.x, p.y);
x += lengthdir_x(move_speed, direction);
y += lengthdir_y(move_speed, direction);

// Kill player on touch
if (place_meeting(x, y, obj_player)) {
    // Restart for now
    game_restart();
}

