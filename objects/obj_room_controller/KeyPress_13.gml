if (room_cleared)
{
    global.current_room_index++;

    if (global.current_room_index < ds_list_size(global.run_rooms))
    {
        room_restart();
    }
    else
    {
        show_debug_message("Run Complete");
    }
}