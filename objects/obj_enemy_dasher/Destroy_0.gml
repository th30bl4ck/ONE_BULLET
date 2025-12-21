for (var i = 0; i < 5; i++) {
    var xx = x + irandom_range(-16, 16);
    var yy = y + irandom_range(-16, 16);
    instance_create_layer(xx, yy, "Instances", obj_XP);
}

with (obj_player) {
    combo_count += 1;
    combo_timer = combo_timer_max;

    // Heat scales with combo
    combo_heat = clamp(combo_count / 10, 0, 1);
}

if (variable_global_exists("room_enemy_kills")) {
    global.room_enemy_kills += 1;
} else {
    global.room_enemy_kills = 1;
}
