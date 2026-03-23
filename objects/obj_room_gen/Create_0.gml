scr_rooms_init();

grid_w = 4;
grid_h = 4;
room_target_count = 10;

layout = array_create(grid_h);

for (var yy = 0; yy < grid_h; yy++)
{
    layout[yy] = array_create(grid_w);

    for (var xx = 0; xx < grid_w; xx++)
    {
        layout[yy][xx] = {
            used: false,
            doors: 0,
            room_asset: -1
        };
    }
}

start_x = 1;
start_y = 1;

scr_generate_layout(start_x, start_y, room_target_count);
scr_assign_room_assets();