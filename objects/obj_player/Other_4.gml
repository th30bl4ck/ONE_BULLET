if variable_global_exists("spawn_object") {
    var sp = instance_find(global.spawn_object, 0);
    if (sp != noone) {
        x = sp.x;
        y = sp.y;
    }
    global.spawn_object = undefined;
}

global.wall_layer_id  = layer_get_id("tileset_wall");
global.wall_tilemap_id = layer_tilemap_get_id(global.wall_layer_id);
