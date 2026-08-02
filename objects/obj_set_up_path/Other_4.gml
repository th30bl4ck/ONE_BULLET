if (grid != -1)
{
    mp_grid_destroy(grid);
}

grid = mp_grid_create(
    0, 0,
    room_width div 16,
    room_height div 16,
    16, 16
);

mp_grid_add_instances(grid, obj_wall, false);