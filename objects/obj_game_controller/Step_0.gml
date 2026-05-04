if (global.do_room_change)
{
    global.do_room_change = false;

    show_debug_message("CHANGING ROOM NOW");
    show_debug_message("TAG BEFORE CHANGE: " + string(global.entry_spawn_tag));
    with (obj_player)
    {
        instance_destroy();
    }

    room_goto(global.next_room);
    // Spawn resolution must run in the new room (after instances exist), not in the old room this step.
    alarm[0] = 1;
    exit;
}
