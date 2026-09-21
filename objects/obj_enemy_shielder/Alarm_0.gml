if (!instance_exists(obj_player)) exit;

if (path_exists(path)) path_delete(path);
path = path_add();

if (mp_grid_path(obj_set_up_path.grid, path, x, y, obj_player.x, obj_player.y, 1)) {
    path_start(path, move_speed, path_action_stop, true);
}

alarm[0] = 30; 