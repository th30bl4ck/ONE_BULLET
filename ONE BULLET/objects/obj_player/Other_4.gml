// Only reposition if a spawn point is defined
if variable_global_exists("spawn_object") {
    var sp = instance_find(global.spawn_object, 0);
    if sp != noone {
        x = sp.x;
        y = sp.y;
    }
    // Reset after using it so next room doesn’t reuse
    global.spawn_object = undefined;
}
