function scr_go_to_room(_dir)
{
    var dx = 0;
    var dy = 0;

    switch (_dir)
    {
        case global.DOOR_N: dy = -1; break;
        case global.DOOR_E: dx = 1; break;
        case global.DOOR_S: dy = 1; break;
        case global.DOOR_W: dx = -1; break;
    }

    var nx = global.map_x + dx;
    var ny = global.map_y + dy;

    if (nx < 0 || nx >= grid_w || ny < 0 || ny >= grid_h) return;
    if (!layout[ny][nx].used) return;

    var next_room = layout[ny][nx].room_asset;
    if (next_room == -1) return;

    global.map_x = nx;
    global.map_y = ny;

    room_goto(next_room);
}