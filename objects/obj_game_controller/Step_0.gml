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
    alarm[0] = 1;
    exit;
}

if (!variable_global_exists("mouse_last_room"))
{
    global.mouse_last_room = noone;
    global.mouse_spawn_delay = -1;
    global.mouse_room_chance = 25;
}

if (global.mouse_last_room != room)
{
    global.mouse_last_room = room;
    global.mouse_spawn_delay = -1;

    if (room != main_menu && room != settings_room && room != rm_intro && irandom(99) < global.mouse_room_chance)
    {
        global.mouse_spawn_delay = irandom_range(20, 120);
    }
}

if (global.mouse_spawn_delay > 0)
{
    global.mouse_spawn_delay--;
}
else if (global.mouse_spawn_delay == 0)
{
    global.mouse_spawn_delay = -1;

    if (!instance_exists(obj_mouse))
    {
        var mouse_margin = 64;
        var mouse_min_y = mouse_margin;
        var mouse_max_y = max(mouse_min_y, room_height - mouse_margin);
        var spawn_x = mouse_margin;
        var spawn_y = room_height * 0.5;
        var spawn_dir = 0;
        var mouse_found = false;

        for (var mouse_try = 0; mouse_try < 16; mouse_try++)
        {
            if (irandom(1) == 0)
            {
                spawn_x = mouse_margin;
                spawn_dir = 0;
            }
            else
            {
                spawn_x = room_width - mouse_margin;
                spawn_dir = 180;
            }

            spawn_y = irandom_range(mouse_min_y, mouse_max_y);

            if (collision_rectangle(spawn_x - 8, spawn_y - 8, spawn_x + 8, spawn_y + 8, obj_wall, false, true) == noone)
            {
                mouse_found = true;
                break;
            }
        }

        if (mouse_found)
        {
            var mouse_inst = instance_create_layer(spawn_x, spawn_y, "Instances", obj_mouse);
            mouse_inst.mouse_dir = spawn_dir;
            mouse_inst.image_xscale = (spawn_dir == 180) ? -1 : 1;
        }
    }
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
