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

if (!variable_global_exists("debug_room_spawn_open"))
{
    global.debug_room_spawn_open = false;
}

if (!variable_global_exists("debug_room_spawn_assets") || !variable_global_exists("debug_room_spawn_names"))
{
    global.debug_room_spawn_open = false;
}

if (keyboard_check_pressed(vk_f9))
{
    global.debug_room_spawn_open = !global.debug_room_spawn_open;
}

if (global.debug_room_spawn_open)
{
    var room_count = array_length(global.debug_room_spawn_assets);

    if (room_count > 0)
    {
        if (keyboard_check_pressed(vk_left))
        {
            global.debug_room_spawn_index = (global.debug_room_spawn_index + room_count - 1) mod room_count;
        }

        if (keyboard_check_pressed(vk_right))
        {
            global.debug_room_spawn_index = (global.debug_room_spawn_index + 1) mod room_count;
        }

        if (keyboard_check_pressed(vk_enter))
        {
            var picked_room = global.debug_room_spawn_assets[global.debug_room_spawn_index];

            global.debug_room_spawn_open = false;
            global.entry_spawn_tag = "debug_center";
            global.next_room = picked_room;
            global.do_room_change = true;

            show_debug_message("DEBUG ROOM WARP: " + global.debug_room_spawn_names[global.debug_room_spawn_index]);
        }
    }
}
