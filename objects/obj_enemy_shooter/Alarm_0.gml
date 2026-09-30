to_player = point_direction(x, y, px, py);

var sight_blocked = collision_line(x, y, obj_player.x, obj_player.y, obj_wall, false, false) != noone;

if (dist > enter_range || sight_blocked) 
{
    path_delete(path);
    path = path_add();

    target_x = obj_player.x;
    target_y = obj_player.y;

    if (mp_grid_path(obj_set_up_path.grid, path, x, y, target_x, target_y, 1)) 
    {
        path_start(path, move_speed, path_action_stop, true);
    } 
    else 
    {
        path_end();
    }
}
else 
{
    path_end();
    state = 0;
}

alarm_set(0, 60);