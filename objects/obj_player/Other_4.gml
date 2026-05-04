if variable_global_exists("spawn_object") && global.spawn_object != undefined {
    
    var sp = instance_find(global.spawn_object, 0);
    
    if (sp != noone) {
        x = sp.x;
        y = sp.y;
    }

    global.spawn_object = undefined;
}

// Ensure room transitions never leave the player soft locked from firing.
can_shoot = true;
bullet_id = noone;

show_debug_message("ROOM START");
show_debug_message("Spawn tag: " + string(global.entry_spawn_tag));

var found = false;
var spawn_obj = noone;

switch (global.entry_spawn_tag)
{
    case "north": spawn_obj = obj_spawn_north; break;
    case "east":  spawn_obj = obj_spawn_east;  break;
    case "south": spawn_obj = obj_spawn_south; break;
    case "west":  spawn_obj = obj_spawn_west;  break;
}

if (spawn_obj != noone && instance_exists(spawn_obj))
{
    var tag_spawn = instance_find(spawn_obj, 0);
    x = tag_spawn.x;
    y = tag_spawn.y;
    found = true;
}
else
{
    with (obj_room_spawn)
    {
        if (spawn_id == global.entry_spawn_tag)
        {
            other.x = x;
            other.y = y;
            other.found = true;
        }
    }
}

if (!found)
{
    show_debug_message("NO MATCHING SPAWN FOUND");
}
else
{
    show_debug_message("SPAWN SUCCESS");
}

// clear AFTER using
global.entry_spawn_tag = "";

global.note_open = false;
input_locked = false;