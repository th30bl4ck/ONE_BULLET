if variable_global_exists("spawn_object") && global.spawn_object != undefined {
    
    var sp = instance_find(global.spawn_object, 0);
    
    if (sp != noone) {
        x = sp.x;
        y = sp.y;
    }

    global.spawn_object = undefined;
}

// Ensure room transitions never leave the player soft-locked from firing.
can_shoot = true;
bullet_id = noone;