function spawn_enemy_at_edge(){
function spawn_enemy_at_edge()
{
    var side = irandom(3);
    var xx, yy;

    switch (side)
    {
        case 0: xx = -32; yy = irandom(room_height); break;           // left
        case 1: xx = room_width + 32; yy = irandom(room_height); break; // right
        case 2: xx = irandom(room_width); yy = -32; break;             // top
        case 3: xx = irandom(room_width); yy = room_height + 32; break; // bottom
    }

    instance_create_layer(xx, yy, "Instances", enemy_type);
}

}