/// @description Destroy run list safely

if (variable_global_exists("run_rooms") && ds_exists(global.run_rooms, ds_type_list))
{
    ds_list_destroy(global.run_rooms);
    show_debug_message("[RUN] global.run_rooms destroyed in obj_game_controller Clean Up.");
}
