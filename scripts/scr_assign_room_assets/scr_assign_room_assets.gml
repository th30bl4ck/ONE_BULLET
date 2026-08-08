function scr_assign_room_assets()
{
    if (!variable_global_exists("ROOMS"))
    {
        scr_rooms_init();
    }

    global.shop_room_used = false;

    var dead_ends = [];

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
                    array_push(dead_ends, { x: xx, y: yy, dist: dist, mask: d_mask });
                }
            }
        }
    }

    array_sort(dead_ends, function(a, b) {
        return b.dist - a.dist;
    });

    var boss_x = -1, boss_y = -1;
    if (array_length(dead_ends) > 0)
    {
        boss_x = dead_ends[0].x;
        boss_y = dead_ends[0].y;
    }

    var shop_x = -1, shop_y = -1;
    if (array_length(dead_ends) > 1)
    {
        var random_index = irandom_range(1, array_length(dead_ends) - 1);
        shop_x = dead_ends[random_index].x;
        shop_y = dead_ends[random_index].y;
    }
    else
    {
        show_debug_message("WARNING: Not enough dead-ends to spawn a shop!");
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

                if (xx == shop_x && yy == shop_y)
                {
                    var d_mask = global.layout[yy][xx].doors;
                    if (d_mask == global.DOOR_N) global.layout[yy][xx].room_asset = rm_shop_N;
                    if (d_mask == global.DOOR_E) global.layout[yy][xx].room_asset = rm_shop_E;
                    if (d_mask == global.DOOR_S) global.layout[yy][xx].room_asset = rm_shop_S;
                    if (d_mask == global.DOOR_W) global.layout[yy][xx].room_asset = rm_shop_W;
                    continue;
                }

                var door_mask = global.layout[yy][xx].doors;
                var picked_room = scr_pick_room_by_doors(door_mask);

                if (picked_room == -1)
                {
                    picked_room = rm_EW_v1;
                }

                global.layout[yy][xx].room_asset = picked_room;
            }
        }
    }
}