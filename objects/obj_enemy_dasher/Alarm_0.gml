if (global.dasher_dist > 250){

path_delete(path);
path = path_add();

target_x = obj_player.x;
target_y = obj_player.y;

mp_grid_path(obj_set_up_path.grid, path, x, y, target_x, target_y, 1);

path_start(path, 1.25, path_action_stop, true);


}

else if (sight == noone) { 
    path_end()
    state = "chase"
}

alarm_set(0, 60);