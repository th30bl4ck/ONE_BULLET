function scr_assign_room_assets()
{
    if (!variable_global_exists("ROOMS"))
    {
        scr_rooms_init();
    }

    global.shop_room_used = false;

    var boss_x = -1;
    var boss_y = -1;
    var max_dist = -1;

    for (var yy = 0; yy < global.grid_h; yy++)
    {
        for (var xx = 0; xx < global.grid_w; xx++)
        {
            if (global.layout[yy][xx].used)
            {
                if (xx == global.start_map_x && yy == global.start_map_y) continue;

                var d_mask = global.layout[yy][xx].doors;

                var is_dead_end = (d_mask == global.DOOR_N || d_mask == global.DOOR_E || d_mask == global.DOOR_S || d_mask == global.DOOR_W);

                if (is_dead_end)
                {
                    var dist = abs(xx - global.start_map_x) + abs(yy - global.start_map_y);

                    if (dist > max_dist)
                    {
                        max_dist = dist;
                        boss_x = xx;
                        boss_y = yy;
                    }
                }
            }
        }
    }


    for (var yy = 0; yy < global.grid_h; yy++)
    {
        for (var xx = 0; xx < global.grid_w; xx++)
        {
            if (global.layout[yy][xx].used)
            {
                if (xx == global.start_map_x && yy == global.start_map_y)
                {
                    global.layout[yy][xx].room_asset = starting_room;
                    continue;
                }

                if (xx == boss_x && yy == boss_y)
                {
                    var d_mask = global.layout[yy][xx].doors;
                    if (d_mask == global.DOOR_N) global.layout[yy][xx].room_asset = rm_Boss_N;
                    if (d_mask == global.DOOR_E) global.layout[yy][xx].room_asset = rm_Boss_E;
                    if (d_mask == global.DOOR_S) global.layout[yy][xx].room_asset = rm_Boss_S;
                    if (d_mask == global.DOOR_W) global.layout[yy][xx].room_asset = rm_Boss_W;
                    continue;
                }

                var door_mask = global.layout[yy][xx].doors;
                var picked_room = scr_pick_room_by_doors(door_mask);

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