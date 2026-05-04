function scr_assign_anchor(inst){
{
    if (!instance_exists(inst)) exit;

    // Ensure anchor globals exist even if no bootstrap object initialized them yet.
    if (!variable_global_exists("enemy_anchor_counts") || !is_array(global.enemy_anchor_counts) || array_length(global.enemy_anchor_counts) < 4)
    {
        global.enemy_anchor_counts = [0, 0, 0, 0];
    }

    if (!variable_global_exists("enemy_anchor_offsets") || !is_array(global.enemy_anchor_offsets) || array_length(global.enemy_anchor_offsets) < 4)
    {
        global.enemy_anchor_offsets = [
            [-64, 0],
            [64, 0],
            [0, -64],
            [0, 64]
        ];
    }

    // Pick anchor with the lowest count
    var best = 0;
    var best_count = global.enemy_anchor_counts[0];

    for (var i = 1; i < 4; i++)
    {
        var c = global.enemy_anchor_counts[i];
        if (c < best_count)
        {
            best = i;
            best_count = c;
        }
    }

    // Assign
    inst.anchor_id = best;
    inst.anchor_jitter = irandom_range(-18, 18); // small randomness so they don't form perfect lines
    inst.anchor_claimed = true;

    global.enemy_anchor_counts[best] += 1;
}

}