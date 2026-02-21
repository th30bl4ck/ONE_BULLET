function spawn_wave(difficulty)
{
    var enemy_count = 3 + difficulty;

    for (var i = 0; i < enemy_count; i++)
    {
        var x_pos = irandom_range(100, room_width - 100);
        var y_pos = irandom_range(100, room_height - 100);

        instance_create_layer(x_pos, y_pos, "Instances", obj_enemy_walker);
    }
}