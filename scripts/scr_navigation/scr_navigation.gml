function scr_nav_default_cell_size()
{
    if (!variable_global_exists("nav_cell_size")) global.nav_cell_size = 32;
    return max(8, floor(global.nav_cell_size));
}

function scr_nav_destroy_grid()
{
    if (variable_global_exists("nav_grid") && global.nav_grid != noone && global.nav_grid != -1)
    {
        mp_grid_destroy(global.nav_grid);
    }

    global.nav_grid = noone;
    global.nav_grid_room = noone;
    global.nav_grid_cell_size = scr_nav_default_cell_size();
    global.nav_grid_cols = 0;
    global.nav_grid_rows = 0;
}

function scr_nav_overlaps_blockers(_l, _t, _r, _b)
{
    if (scr_wall_overlaps_rect(_l, _t, _r, _b))
        return true;

    if (!variable_global_exists("nav_blocker_objects") || !is_array(global.nav_blocker_objects))
        return false;

    for (var i = 0; i < array_length(global.nav_blocker_objects); i++)
    {
        var blocker = global.nav_blocker_objects[i];
        if (blocker == obj_wall) continue;

        if (collision_rectangle(_l, _t, _r, _b, blocker, false, true))
            return true;
    }

    return false;
}

function scr_nav_build_for_room()
{
    scr_nav_destroy_grid();
    scr_refresh_wall_tilemap();

    var cell_size = scr_nav_default_cell_size();
    var cols = max(1, ceil(room_width / cell_size));
    var rows = max(1, ceil(room_height / cell_size));

    global.nav_grid = mp_grid_create(0, 0, cols, rows, cell_size, cell_size);
    global.nav_grid_room = room;
    global.nav_grid_cell_size = cell_size;
    global.nav_grid_cols = cols;
    global.nav_grid_rows = rows;

    for (var gy = 0; gy < rows; gy++)
    {
        for (var gx = 0; gx < cols; gx++)
        {
            var left = gx * cell_size;
            var top = gy * cell_size;
            var right = min(room_width - 1, left + cell_size - 1);
            var bottom = min(room_height - 1, top + cell_size - 1);

            if (scr_nav_overlaps_blockers(left, top, right, bottom))
            {
                mp_grid_add_cell(global.nav_grid, gx, gy);
            }
        }
    }
}

function scr_nav_ensure_ready()
{
    if (!variable_global_exists("nav_grid") || global.nav_grid == noone || global.nav_grid == -1)
    {
        scr_nav_build_for_room();
        return;
    }

    if (!variable_global_exists("nav_grid_room") || global.nav_grid_room != room)
    {
        scr_nav_build_for_room();
    }
}

function scr_nav_is_cell_walkable(_cell_x, _cell_y)
{
    scr_nav_ensure_ready();

    if (_cell_x < 0 || _cell_y < 0 || _cell_x >= global.nav_grid_cols || _cell_y >= global.nav_grid_rows)
        return false;

    return !mp_grid_get_cell(global.nav_grid, _cell_x, _cell_y);
}

function scr_nav_is_point_walkable(_x, _y)
{
    scr_nav_ensure_ready();

    if (_x < 0 || _y < 0 || _x >= room_width || _y >= room_height)
        return false;

    var cell_size = global.nav_grid_cell_size;
    var gx = floor(_x / cell_size);
    var gy = floor(_y / cell_size);

    if (!scr_nav_is_cell_walkable(gx, gy))
        return false;

    return !scr_nav_overlaps_blockers(_x - 8, _y - 8, _x + 8, _y + 8);
}

function scr_nav_get_grid()
{
    scr_nav_ensure_ready();
    return global.nav_grid;
}

function scr_nav_make_path(_path, _start_x, _start_y, _end_x, _end_y, _allow_diagonal)
{
    scr_nav_ensure_ready();
    if (global.nav_grid == noone || global.nav_grid == -1) return false;
    return mp_grid_path(global.nav_grid, _path, _start_x, _start_y, _end_x, _end_y, _allow_diagonal);
}

function scr_nav_get_enemy_spawn_position(_min_player_distance, _max_attempts)
{
    scr_nav_ensure_ready();

    var min_dist = max(0, _min_player_distance);
    var attempts = max(1, floor(_max_attempts));
    var cell_size = global.nav_grid_cell_size;
    var player_exists = instance_exists(obj_player);

    repeat (attempts)
    {
        var gx = irandom(global.nav_grid_cols - 1);
        var gy = irandom(global.nav_grid_rows - 1);

        if (!scr_nav_is_cell_walkable(gx, gy))
            continue;

        var sx = min(room_width - 1, gx * cell_size + cell_size * 0.5);
        var sy = min(room_height - 1, gy * cell_size + cell_size * 0.5);

        if (!scr_nav_is_point_walkable(sx, sy))
            continue;

        if (player_exists && point_distance(sx, sy, obj_player.x, obj_player.y) < min_dist)
            continue;

        return { x: sx, y: sy, found: true };
    }

    return { x: 0, y: 0, found: false };
}
