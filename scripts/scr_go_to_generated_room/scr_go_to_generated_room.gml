function scr_go_to_generated_room(_dir)
{
    show_debug_message("=== DOOR USED ===");

    var dx = 0;
    var dy = 0;
    var target_spawn = "";

    switch (_dir)
    {
        case global.DOOR_N: dy = -1; target_spawn = "south"; break;
        case global.DOOR_E: dx = 1;  target_spawn = "west";  break;
        case global.DOOR_S: dy = 1;  target_spawn = "north"; break;
        case global.DOOR_W: dx = -1; target_spawn = "east";  break;
    }

    var next_x = global.map_x + dx;
    var next_y = global.map_y + dy;

    show_debug_message("Trying: " + string(next_x) + "," + string(next_y));

    if (!variable_global_exists("layout"))
    {
        show_debug_message("FAILED: layout does not exist");
        return;
    }

    if (next_y < 0 || next_y >= array_length(global.layout))
    {
        show_debug_message("FAILED: Y out of bounds");
        return;
    }

    if (next_x < 0 || next_x >= array_length(global.layout[next_y]))
    {
        show_debug_message("FAILED: X out of bounds");
        return;
    }

    var next_cell = global.layout[next_y][next_x];

    if (!is_struct(next_cell))
    {
        show_debug_message("FAILED: not a struct");
        return;
    }

    show_debug_message("Cell used: " + string(next_cell.used));

    if (!next_cell.used)
    {
        show_debug_message("FAILED: room not generated there");
        return;
    }

    var next_room = next_cell.room_asset;

    if (next_room == -1)
    {
        show_debug_message("FAILED: no room assigned");
        return;
    }

    show_debug_message("SUCCESS: preparing room change");

    // store everything safely
    global.map_x = next_x;
    global.map_y = next_y;

    global.entry_spawn_tag = target_spawn;
    global.next_room = next_room;
    global.do_room_change = true;
}