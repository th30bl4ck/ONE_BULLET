function scr_assign_anchor(inst){
{
    if (!instance_exists(inst)) exit;

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