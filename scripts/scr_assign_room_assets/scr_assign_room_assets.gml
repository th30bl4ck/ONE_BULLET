function scr_assign_room_assets()
{
    if (!variable_global_exists("ROOMS"))
    {
        scr_rooms_init();
    }

    global.shop_room_used = false;

    for (var yy = 0; yy < global.grid_h; yy++)
    {
        for (var xx = 0; xx < global.grid_w; xx++)
        {
            if (global.layout[yy][xx].used)
            {
                if (variable_global_exists("start_map_x")
                 && variable_global_exists("start_map_y")
                 && xx == global.start_map_x
                 && yy == global.start_map_y)
                {
                    global.layout[yy][xx].room_asset = starting_room;
                    continue;
                }

                var door_mask = global.layout[yy][xx].doors;
                var picked_room = scr_pick_room_by_doors(door_mask);

                // Fallback keeps generation alive if a mask has no registered room.
                if (picked_room == -1)
                {
                    picked_room = rm_EW_v1;
                    show_debug_message("WARNING: No room for door mask " + string(door_mask) + ", using fallback rm_EW_v1");
                }

                global.layout[yy][xx].room_asset = picked_room;
            }
        }
    }
}
