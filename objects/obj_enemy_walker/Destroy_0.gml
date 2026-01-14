// =========================
// BASE XP 
// =========================
var base_xp = variable_instance_exists(id, "xp_value") ? xp_value : 3;

// =========================
// GET PLAYER 
// =========================
var p = instance_find(obj_player, 0);
var combo = instance_exists(p) ? p.combo_count : 0;
scr_enemy_separation();

// =========================
// COMBO MULTIPLIER
// =========================
var mult = scr_get_combo_xp_multiplier(combo);
var final_xp = ceil(base_xp * mult);

// =========================
// SPAWN XP ORBS
// =========================
repeat (final_xp) {
 for (var i = 0; i < 1; i++) {
    var xx = x + irandom_range(-16, 16);
    var yy = y + irandom_range(-16, 16);
    instance_create_layer(xx, yy, "Instances", obj_XP);
}
}
// =========================
// INCREASE COMBO
// =========================
if (instance_exists(p)) {
    p.combo_count += 1;
    p.combo_timer = p.combo_timer_max;
    p.combo_heat = clamp(p.combo_count / 10, 0, 1);
}

if (variable_global_exists("room_enemy_kills")) {
    global.room_enemy_kills += 1;
} else {
    global.room_enemy_kills = 1;
}
