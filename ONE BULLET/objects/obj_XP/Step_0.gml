// Always stop any built-in movement
speed = 0;
hspeed = 0;
vspeed = 0;

// Make sure a player exists
if (!instance_exists(obj_player)) exit;

// Get the player instance
var p = instance_nearest(x, y, obj_player);

// Distance to player
var dist = point_distance(x, y, p.x, p.y);

// Magnet range
if (dist < attract_range)
{
    var dir = point_direction(x, y, p.x, p.y);

    // Move directly toward the player
    x += lengthdir_x(attract_speed, dir);
    y += lengthdir_y(attract_speed, dir);
}

