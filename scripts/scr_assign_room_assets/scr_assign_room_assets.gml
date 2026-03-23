function scr_assign_room_assets()
{
    for (var yx = 0; y < grid_h; y++)
    {
        for (var xy = 0; x < grid_w; x++)
        {
            if (!layout[y][x].used) continue;

            var door_mask = layout[y][x].doors;
            var chosen_room = scr_pick_room_by_doors(door_mask);

            if (chosen_room == -1)
            {
                show_debug_message("No room found for door mask: " + string(door_mask));
            }

            layout[y][x].room_asset = chosen_room;
        }
    }
}