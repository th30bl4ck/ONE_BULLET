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
}

if (!instance_exists(obj_player) && global.entry_spawn_tag != "")
{
    var spawn_x = room_width * 0.5;
    var spawn_y = room_height * 0.5;
    var found = false;

    with (obj_room_spawn)
    {
        if (spawn_id == global.entry_spawn_tag)
        {
            other.spawn_x = x;
            other.spawn_y = y;
            other.found = true;
        }
    }

    instance_create_depth(spawn_x, spawn_y, 0, obj_player);

    global.entry_spawn_tag = "";
}