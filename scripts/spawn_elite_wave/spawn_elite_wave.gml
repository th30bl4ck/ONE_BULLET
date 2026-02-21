function spawn_elite_wave(difficulty)
{
    var _elite_obj = asset_get_index("obj_enemy_dasher");
    if (_elite_obj == -1) _elite_obj = asset_get_index("obj_enemy_shooter");
    if (_elite_obj == -1) _elite_obj = asset_get_index("obj_enemy_walker");

        if (_elite_obj == -1)
    {
        show_debug_message("[SPAWN][ERROR] spawn_elite_wave: no valid elite enemy object found.");
        return;
    }
    var enemy_count = max(1, 5 + difficulty);
    
    for (var i = 0; i < enemy_count; i++)
    {
        var x_pos = irandom_range(100, room_width - 100);
        var y_pos = irandom_range(100, room_height - 100);

        instance_create_layer(x_pos, y_pos, "Instances", _elite_obj);
    }
    show_debug_message("[SPAWN] spawn_elite_wave difficulty=" + string(difficulty) + " count=" + string(enemy_count));
}

