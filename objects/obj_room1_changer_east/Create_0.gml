
if (!variable_global_exists("DOOR_E"))
{
    global.DOOR_N = 1;
    global.DOOR_E = 2;
    global.DOOR_S = 4;
    global.DOOR_W = 8;
}

door_dir = global.DOOR_E;

unlocked = true;

sprite_index = side_door;
image_speed = 0;
image_index = 0;

_unlocked_prev = unlocked;
_opening = false;