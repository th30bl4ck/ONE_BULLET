if (!room_cleared)
{
    show_debug_message("[ROOM] Enter pressed but room not cleared yet.");
    exit;
}

if (!variable_global_exists("run_rooms") || !ds_exists(global.run_rooms, ds_type_list))
{
    show_debug_message("[ROOM][ERROR] Enter pressed but global.run_rooms missing/invalid.");
    exit;
}

if (!variable_global_exists("current_room_index"))
{
    global.current_room_index = 0;
    show_debug_message("[ROOM][WARN] current_room_index missing during transition. Reset to 0.");
}

global.current_room_index += 1;
var _size = ds_list_size(global.run_rooms);

show_debug_message("[ROOM] Enter pressed. Advancing to index=" + string(global.current_room_index) + " of " + string(_size));

if (global.current_room_index < _size)
{
    room_restart();
}
else
{
    show_debug_message("[ROOM] Run complete. No more rooms.");
}