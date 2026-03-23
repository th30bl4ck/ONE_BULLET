function scr_generate_layout(_start_x, _start_y, _target_count)
{
    var frontier = [];
    var placed = 1;

    layout[_start_y][_start_x].used = true;
    array_push(frontier, [_start_x, _start_y]);

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

        // shuffle a bit
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

            if (nx < 0 || nx >= grid_w || ny < 0 || ny >= grid_h) continue;
            if (layout[ny][nx].used) continue;

            // random chance to place here
            if (irandom(100) > 55) continue;

            layout[ny][nx].used = true;

            layout[cy][cx].doors |= door;
            layout[ny][nx].doors |= scr_opposite_door(door);

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
}