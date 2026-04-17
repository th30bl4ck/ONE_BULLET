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

with (obj_room_spawn)
{
    if (spawn_id == global.entry_spawn_tag)
    {
        other.x = x;
        other.y = y;
        other.found = true;
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

