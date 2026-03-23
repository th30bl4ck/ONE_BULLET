function scr_opposite_door(_door)
{
    switch (_door)
    {
        case global.DOOR_N: return global.DOOR_S;
        case global.DOOR_E: return global.DOOR_W;
        case global.DOOR_S: return global.DOOR_N;
        case global.DOOR_W: return global.DOOR_E;
    }

    return 0;
}

function scr_has_door(_mask, _door)
{
    return (_mask & _door) != 0;
}

function scr_pick_room_by_doors(_doors)
{
    var matches = [];

    for (var i = 0; i < array_length(global.ROOMS); i++)
    {
        if (global.ROOMS[i].doors == _doors)
        {
            array_push(matches, global.ROOMS[i].room);
        }
    }

    if (array_length(matches) <= 0) return -1;

    return matches[irandom(array_length(matches) - 1)];
}