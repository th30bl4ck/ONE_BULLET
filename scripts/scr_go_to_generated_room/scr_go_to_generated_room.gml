var _dir = argument0;

var dx = 0;
var dy = 0;
var target_spawn = "";

switch (_dir)
{
    case global.DOOR_N:
        dy = -1;
        target_spawn = "south";
    break;

    case global.DOOR_E:
        dx = 1;
        target_spawn = "west";
    break;

    case global.DOOR_S:
        dy = 1;
        target_spawn = "north";
    break;

    case global.DOOR_W:
        dx = -1;
        target_spawn = "east";
    break;
}

var next_x = global.map_x + dx;
var next_y = global.map_y + dy;

if (next_x < 0) exit;
if (next_x >= global.grid_w) exit;
if (next_y < 0) exit;
if (next_y >= global.grid_h) exit;

if (!global.layout[# next_x, next_y]) exit;

// move map position
global.map_x = next_x;
global.map_y = next_y;

global.entry_spawn_tag = target_spawn;

room_goto(global.room_map[# next_x, next_y]);