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

    var spawn_obj = noone;
    switch (global.entry_spawn_tag)
    {
        case "north": spawn_obj = obj_spawn_north; break;
        case "east":  spawn_obj = obj_spawn_east;  break;
        case "south": spawn_obj = obj_spawn_south; break;
        case "west":  spawn_obj = obj_spawn_west;  break;
    }

    if (spawn_obj != noone && instance_exists(spawn_obj))
    {
        var sp = instance_find(spawn_obj, 0);
        spawn_x = sp.x;
        spawn_y = sp.y;
        found = true;
    }
    else
    {
        with (obj_room_spawn)
        {
            if (spawn_id == global.entry_spawn_tag)
            {
                other.spawn_x = x;
                other.spawn_y = y;
                other.found = true;
            }
        }
    }
    
    if (!found)
    {
        show_debug_message("NO MATCHING SPAWN FOR TAG: " + string(global.entry_spawn_tag) + " (fallback center)");
    }    
    
    
    instance_create_depth(spawn_x, spawn_y, 0, obj_player);

    global.entry_spawn_tag = "";
}
