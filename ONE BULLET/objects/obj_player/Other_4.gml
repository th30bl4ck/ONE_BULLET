if variable_global_exists("spawn_object") {
    var sp = instance_find(global.spawn_object, 0);
    if (sp != noone) {
        x = sp.x;
        y = sp.y;
    }
    global.spawn_object = undefined;
}
