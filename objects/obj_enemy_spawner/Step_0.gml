//------------------------------------
// GLOBAL BLOCKS
//------------------------------------
if (global.levelup_active) exit;
if (arena_complete) exit;


//------------------------------------
// WAVE NOT ACTIVE 
//------------------------------------
if (!wave_in_progress)
{
    // If all waves are done, complete arena
    if (current_wave >= max_waves)
    {
        arena_complete = true;

        if (!coins_spawned)
        {
            var coin_count = global.room_enemy_kills div 10;
            coin_count = max(0, coin_count - global.room_damage_taken);

            if (coin_count > 0)
            {
                scr_coins_spawn(coin_count);
            }

            coins_spawned = true;
        }

        // Unlock the exit to the next room
        with (obj_room1_changer)
        {
            unlocked = true;
        }

        exit;
    }

    wave_break_timer++;

    if (wave_break_timer >= wave_break_time)
    {
        wave_break_timer = 0;
        wave_in_progress = true;

        // Enemies per wave scales slightly
        wave_enemy_total = 7 + current_wave * 2;
        wave_enemy_spawned = 0;
        spawn_timer = 0;
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

    // Spawn from room edges
    var side = irandom(3);
    var xx, yy;

    switch (side)
    {
        case 0: xx = -32; yy = irandom(room_height); break;
        case 1: xx = room_width + 32; yy = irandom(room_height); break;
        case 2: xx = irandom(room_width); yy = -32; break;
        case 3: xx = irandom(room_width); yy = room_height + 32; break;
    }

    // Full mix every wave
    var enemy_to_spawn = choose(
        obj_enemy_walker,
        obj_enemy_dasher,
        obj_enemy_shooter,
        obj_enemy_splitter
    );

    // CREATE + ASSIGN ANCHOR (Step 2)
    var e = instance_create_layer(xx, yy, "Instances", enemy_to_spawn);
    scr_assign_anchor(e);

    wave_enemy_spawned++;
}
}
else
{
    //------------------------------------
    // WAVE COMPLETE → MOVE TO NEXT WAVE
    //------------------------------------
    if (instance_number(obj_enemy_walker) == 0 &&
        instance_number(obj_enemy_dasher) == 0 &&
        instance_number(obj_enemy_shooter) == 0&&
        instance_number(obj_enemy_splitter) == 0)
    {
        current_wave++;
        wave_in_progress = false;
    }
}
