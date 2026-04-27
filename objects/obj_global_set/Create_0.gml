if (!variable_global_exists("game_initialized")) {

    global.game_initialized = true;

    // =========================
    // RUN STATE
    // =========================
    global.level = 1;
    global.xp = 0;
    global.xp_required = 20;
    global.coins = 0;

    global.room_enemy_kills = 0;
    global.room_damage_taken = 0;

    // =========================
    // PLAYER STATS
    // =========================
    global.player_health_max_base = 5;
    global.player_health_bonus = 0;

    global.xp_attract_range = 64;
    global.bullet_pierce = false;
    global.recall_speed = 6;
    global.player_bullet_speed = 10;
    global.bullet_max_distance = 300;

    // =========================
    // UI / NOTES
    // =========================
    global.note_open = false;
    global.note_text = "";
    global.active_note = noone;

    // =========================
    // DOOR SYSTEM
    // =========================
    global.DOOR_N = 1;
    global.DOOR_E = 2;
    global.DOOR_S = 4;
    global.DOOR_W = 8;

    // =========================
    // PROCEDURAL MAP
    // =========================
    global.grid_w = 4;
    global.grid_h = 4;

    global.map_x = 1;
    global.map_y = 1;

    global.entry_spawn_tag = "";

}