if (instance_number(obj_global_set) > 1)
{
    instance_destroy();
    exit;
}

global.game_initialized = true;

// =========================
// RUN STATE
// =========================
global.level = 1;
global.xp = 0;
global.xp_required = 20;
global.coins = 500;

global.room_enemy_kills = 0;
global.room_damage_taken = 0;

// =========================
// PLAYER STATS
// =========================
global.player_health_max_base = 5;
global.player_health_bonus = 0;
global.player_health = {
    max: global.player_health_max_base,
    current: global.player_health_max_base,
    frame_full: 0,
    frame_empty: 8,
    segments: array_create(global.player_health_max_base, 0),
    frames: array_create(global.player_health_max_base, 0)
};

for (var i = 0; i < global.player_health.max; i++)
{
    global.player_health.frames[i] = global.player_health.frame_full;
}

// stats
global.xp_attract_range = 64;
global.player_move_speed_bonus = 0;
global.player_dash_time_bonus = 0;
global.bullet_pierce = false;
global.recall_speed = 6;
global.player_bullet_speed = 10;
global.bullet_max_distance = 300;
global.semantic_orbit = false;
global.the_jerk = false;
game_speed = 1;

if (variable_global_exists("upgrade_counts") && ds_exists(global.upgrade_counts, ds_type_map))
{
    ds_map_destroy(global.upgrade_counts);
}
global.upgrade_counts = ds_map_create();

// =========================
// UI / NOTES
// =========================
global.levelup_active = false;
global.choice_1 = "";
global.choice_2 = "";
global.levelup_sel = 0;
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
global.do_room_change = false;
global.next_room = noone;
global.spawn_object = undefined;
global.wall_tilemap_id = noone;
global.wall_tilemap_room = noone;
global.enemy_anchor_counts = [0, 0, 0, 0];
global.enemy_anchor_offsets = [
    [-64, 0],
    [64, 0],
    [0, -64],
    [0, 64]
];

global.room_lighting_enabled = true;
global.room_lighting_time_uniform = shader_get_uniform(shader_normal_room, "u_time");
global.room_lighting_view_pos_uniform = shader_get_uniform(shader_normal_room, "u_view_pos");
global.room_lighting_view_size_uniform = shader_get_uniform(shader_normal_room, "u_view_size");
global.room_lighting_screen_size_uniform = shader_get_uniform(shader_normal_room, "u_screen_size");
global.room_lighting_room_size_uniform = shader_get_uniform(shader_normal_room, "u_room_size");

// ===========
// shop items
// ===========
global.shop_item_1 = noone;