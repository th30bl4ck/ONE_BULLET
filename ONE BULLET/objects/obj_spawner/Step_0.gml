timer++;

if (timer >= spawn_rate) {
    timer = 0;

    // Spawn enemy at random edges
    var side = irandom(3);

    switch (side) {
        case 0: instance_create_layer(0, irandom(room_height), "Instances", obj_enemy); break;
        case 1: instance_create_layer(room_width, irandom(room_height), "Instances", obj_enemy); break;
        case 2: instance_create_layer(irandom(room_width), 0, "Instances", obj_enemy); break;
        case 3: instance_create_layer(irandom(room_width), room_height, "Instances", obj_enemy); break;
    }
}
