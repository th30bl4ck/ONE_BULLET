instance_destroy(other);

var dir = point_direction(0, 0, hsp, vsp);
var current_speed = point_distance(0, 0, hsp, vsp);

current_speed = min(current_speed + 1, max_speed);

hsp = lengthdir_x(current_speed, dir);
vsp = lengthdir_y(current_speed, dir);

is_moving = true;