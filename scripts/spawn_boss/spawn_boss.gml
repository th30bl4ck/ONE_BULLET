function spawn_boss()
{
    var _boss_obj = asset_get_index("obj_boss_abomination");
    if (_boss_obj == -1)
    {
        show_debug_message("[SPAWN][ERROR] spawn_boss: obj_boss_abomination missing. Falling back to strong enemy wave.");
        if (script_exists(spawn_elite_wave))
        {
            spawn_elite_wave(6);
        }
        return;
    }

    instance_create_layer(room_width * 0.5, room_height * 0.5, "Instances", _boss_obj);
    show_debug_message("[SPAWN] spawn_boss created obj_boss_abomination.");
}