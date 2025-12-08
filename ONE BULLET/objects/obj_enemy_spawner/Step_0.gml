//------------------------------------
// WAVE NOT ACTIVE → WAIT + START WAVE
//------------------------------------
if (!wave_in_progress)
{
    wave_break_timer++;

    if (wave_break_timer >= wave_break_time)
    {
        wave_break_timer = 0;
        wave_in_progress = true;

        // Number of enemies this wave
        wave_enemy_total = 3 + current_wave * 1;

        wave_enemy_spawned = 0;
    }

    exit;
}



//------------------------------------
// WAVE ACTIVE → SPAWN ENEMIES
//------------------------------------
if (wave_enemy_spawned < wave_enemy_total)
{
    spawn_timer++;

    if (spawn_timer >= spawn_delay)
    {
        spawn_timer = 0;

        // Spawn position from room edges
        var side = irandom(3);
        var xx, yy;

        switch (side)
        {
            case 0: xx = -32; yy = irandom(room_height); break;
            case 1: xx = room_width + 32; yy = irandom(room_height); break;
            case 2: xx = irandom(room_width); yy = -32; break;
            case 3: xx = irandom(room_width); yy = room_height + 32; break;
        }

        //------------------------------------
        // PICK ENEMY TYPE PER SPAWN
        //------------------------------------
        var enemy_to_spawn;

        if (current_wave <= 3)
        {
            // ONLY walkers in first 3 waves
            enemy_to_spawn = obj_enemy_walker;
        }
        else if (current_wave <= 6)
        {
            // MIX of walkers + dashers (equal chance)
            enemy_to_spawn = choose(obj_enemy_walker, obj_enemy_dasher);
        }
        else
        {
            // MIX but weighted toward dashers
            enemy_to_spawn = choose(
                obj_enemy_walker,
                obj_enemy_walker,
                obj_enemy_dasher,
                obj_enemy_dasher
            );
        }

        // Create the enemy
        instance_create_layer(xx, yy, "Instances", enemy_to_spawn);

        wave_enemy_spawned++;
    }
}
else
{
    //------------------------------------
    // WAVE COMPLETE → NEXT WAVE
    //------------------------------------
    if (instance_number(obj_enemy_walker) == 0 && instance_number(obj_enemy_dasher) == 0)
    {
        current_wave++;
        wave_in_progress = false;
    }
}

