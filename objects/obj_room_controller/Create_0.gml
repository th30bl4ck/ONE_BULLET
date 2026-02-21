room_cleared = false;

if (!variable_global_exists("run_rooms") || !ds_exists(global.run_rooms, ds_type_list))
{
    show_debug_message("Room generation missing: global.run_rooms is not initialized.");
    instance_destroy();
    exit;
}

if (global.current_room_index < 0 || global.current_room_index >= ds_list_size(global.run_rooms))
{
    show_debug_message("Room generation index out of range: " + string(global.current_room_index));
    instance_destroy();
    exit;
}

room_data = global.run_rooms[| global.current_room_index];
spawn_room_content();