if (global.do_room_change)
{
    global.do_room_change = false;

    show_debug_message("CHANGING ROOM NOW");
    show_debug_message("TAG BEFORE CHANGE: " + string(global.entry_spawn_tag));

    room_goto(global.next_room);
}