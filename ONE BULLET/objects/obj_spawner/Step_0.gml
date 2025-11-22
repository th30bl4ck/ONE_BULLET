timer++;

spawn_rate -= difficulty_speed;
if (spawn_rate < min_spawn_rate) spawn_rate = min_spawn_rate;

if (timer >= spawn_rate) {
    timer = 0;

    // pick a random side
    var side = irandom(3);
    var xx, yy;

    switch (side) {
        case 0:
            xx = -32;                // left side OUTSIDE the room
            yy = irandom(room_height);
        break;

        case 1:
            xx = room_width + 32;    // right side OUTSIDE the room
            yy = irandom(room_height);
        break;

        case 2:
            xx = irandom(room_width);
            yy = -32;                // top OUTSIDE the room
        break;

        case 3:
            xx = irandom(room_width);
            yy = room_height + 32;   // bottom OUTSIDE the room
        break;
    }

    instance_create_layer(xx, yy, "Instances", obj_enemy);
}
