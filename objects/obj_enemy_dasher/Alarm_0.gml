if (dasher_dist > 250 or sight == noone){

path_delete(path);
path = path_add();

target_x = obj_player.x;
target_y = obj_player.y;

mp_grid_path(obj_set_up_path.grid, path, x, y, target_x, target_y, 1);

path_start(path, move_speed, path_action_stop, true);


}

else if (sight == true) { 
    path_end()
    state = "chase"
}

alarm_set(0, 60);