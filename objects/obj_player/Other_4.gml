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

if (variable_global_exists("entry_spawn_tag"))
{
    var i, inst;
    for (i = 0; i < instance_number(obj_room_spawn); i += 1)
    {
        inst = instance_find(obj_room_spawn, i);
        if (inst != noone)
        {
            if (inst.spawn_id == global.entry_spawn_tag)
            {
                x = inst.x;
                y = inst.y;
                break;
            }
        }
    }
}