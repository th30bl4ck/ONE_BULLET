if (variable_instance_exists(id, "anchor_id") && variable_global_exists("enemy_anchor_counts"))
{
    if (anchor_claimed) // only if spawner counted it
    {
        global.enemy_anchor_counts[anchor_id] = max(0, global.enemy_anchor_counts[anchor_id] - 1);
    }
}
