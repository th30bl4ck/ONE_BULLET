if (instance_exists(shield)) {
    instance_destroy(shield);
}

if (path_exists(path)) {
    path_delete(path);
}

var base_xp = variable_instance_exists(id, "xp_value") ? xp_value : 5;
repeat (base_xp) {
    var xx = x + irandom_range(-16, 16);
    var yy = y + irandom_range(-16, 16);
    instance_create_layer(xx, yy, "Instances", obj_XP);
}

if (instance_exists(obj_player)) {
    with (obj_player) {
        combo_count += 1;
        combo_timer = combo_timer_max;
        combo_heat = clamp(combo_count / 10, 0, 1);
    }
}

if (variable_global_exists("room_enemy_kills")) {
    global.room_enemy_kills += 1;
}

if (variable_instance_exists(id, "anchor_id") && variable_global_exists("enemy_anchor_counts")) {
    if (variable_instance_exists(id, "anchor_claimed") && anchor_claimed) {
        global.enemy_anchor_counts[anchor_id] = max(0, global.enemy_anchor_counts[anchor_id] - 1);
    }
}