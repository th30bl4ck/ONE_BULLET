function spawn_enemy_at_edge()
{
    var enemy_to_spawn = enemy_type;
    var min_dist = variable_global_exists("enemy_spawn_min_player_distance") ? global.enemy_spawn_min_player_distance : 160;
    var attempts = variable_global_exists("enemy_spawn_attempts") ? global.enemy_spawn_attempts : 64;
    var pos = scr_nav_get_enemy_spawn_position(min_dist, attempts);

    if (!pos.found)
        return noone;

    return instance_create_layer(pos.x, pos.y, "Instances", enemy_to_spawn);
}
