function scr_generate_layout(_start_x, _start_y, _target_count)
{
    var max_cells = global.grid_w * global.grid_h;
    _target_count = clamp(_target_count, 1, max_cells);

    var frontier = [];
    var placed = 1;

    global.layout[_start_y][_start_x].used = true;

    // Ensure the starting room's east door always has a valid destination.
    var start_east_x = _start_x + 1;
    var start_east_y = _start_y;
    if (start_east_x >= 0 && start_east_x < global.grid_w)
    {
        if (!global.layout[start_east_y][start_east_x].used)
        {
            global.layout[start_east_y][start_east_x].used = true;
            placed++;
            array_push(frontier, [start_east_x, start_east_y]);
        }

        global.layout[_start_y][_start_x].doors |= global.DOOR_E;
        global.layout[start_east_y][start_east_x].doors |= global.DOOR_W;
    }
    else
    {
        array_push(frontier, [_start_x, _start_y]);
    }

    while (array_length(frontier) > 0 && placed < _target_count)
    {
        var pick_index = irandom(array_length(frontier) - 1);
        var current = frontier[pick_index];
        var cx = current[0];
        var cy = current[1];

        var dirs = [
            [ 0, -1, global.DOOR_N ],
            [ 1,  0, global.DOOR_E ],
            [ 0,  1, global.DOOR_S ],
            [-1,  0, global.DOOR_W ]
        ];

        // shuffle
        for (var i = 0; i < array_length(dirs); i++)
        {
            var j = irandom(array_length(dirs) - 1);
            var temp = dirs[i];
            dirs[i] = dirs[j];
            dirs[j] = temp;
        }

        var expanded = false;

        for (var d = 0; d < array_length(dirs); d++)
        {
            var dx = dirs[d][0];
            var dy = dirs[d][1];
            var dir_flag = dirs[d][2];

            var nx = cx + dx;
            var ny = cy + dy;

            if (nx < 0 || nx >= global.grid_w || ny < 0 || ny >= global.grid_h) continue;

            if (global.layout[ny][nx].used) continue;

            // Below target, always grow when possible so we reliably hit room count on small grids.
            if (placed >= _target_count && irandom(100) > 55) continue;

            // mark used
            global.layout[ny][nx].used = true;

            global.layout[cy][cx].doors |= dir_flag;
            global.layout[ny][nx].doors |= scr_opposite_door(dir_flag);

            array_push(frontier, [nx, ny]);
            placed++;
            expanded = true;

            if (placed >= _target_count) break;
        }

        if (!expanded)
        {
            array_delete(frontier, pick_index, 1);
        }
    }

    // If the main loop stopped early, attach any unused cell that borders the dungeon.
    while (placed < _target_count)
    {
        var added = false;

        for (var fy = 0; fy < global.grid_h && !added; fy++)
        {
            for (var fx = 0; fx < global.grid_w && !added; fx++)
            {
                if (global.layout[fy][fx].used) continue;

                var nx = fx;
                var ny = fy - 1;
                if (ny >= 0 && global.layout[ny][nx].used && !(nx == _start_x && ny == _start_y))
                {
                    global.layout[fy][fx].used = true;
                    global.layout[fy][fx].doors |= global.DOOR_N;
                    global.layout[ny][nx].doors |= global.DOOR_S;
                    placed++;
                    added = true;
                    break;
                }

                nx = fx + 1;
                ny = fy;
                if (nx < global.grid_w && global.layout[ny][nx].used && !(nx == _start_x && ny == _start_y))
                {
                    global.layout[fy][fx].used = true;
                    global.layout[fy][fx].doors |= global.DOOR_E;
                    global.layout[ny][nx].doors |= global.DOOR_W;
                    placed++;
                    added = true;
                    break;
                }

                nx = fx;
                ny = fy + 1;
                if (ny < global.grid_h && global.layout[ny][nx].used && !(nx == _start_x && ny == _start_y))
                {
                    global.layout[fy][fx].used = true;
                    global.layout[fy][fx].doors |= global.DOOR_S;
                    global.layout[ny][nx].doors |= global.DOOR_N;
                    placed++;
                    added = true;
                    break;
                }

                nx = fx - 1;
                ny = fy;
                if (nx >= 0 && global.layout[ny][nx].used && !(nx == _start_x && ny == _start_y))
                {
                    global.layout[fy][fx].used = true;
                    global.layout[fy][fx].doors |= global.DOOR_W;
                    global.layout[ny][nx].doors |= global.DOOR_E;
                    placed++;
                    added = true;
                    break;
                }
            }
        }

        if (!added) break;
    }

    if (placed < _target_count)
    {
        show_debug_message("WARNING: layout only reached " + string(placed) + " / " + string(_target_count) + " cells (grid full or disconnected)");
    }
}
