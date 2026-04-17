function scr_assign_room_assets()
{
    for (var yy = 0; yy < global.grid_h; yy++)
    {
        for (var xx = 0; xx < global.grid_w; xx++)
        {
            if (global.layout[yy][xx].used)
            {
global.layout[yy][xx].room_asset = choose(
    rm_E_v1,
    rm_E_v2,
    rm_N_v1,
    rm_N_v2,
    rm_S_v1,
    rm_S_v2,
    rm_W_v1,
    rm_W_v2
);
            }
        }
    }
}