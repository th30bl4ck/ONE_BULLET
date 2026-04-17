global.level = 1;
global.xp = 0;

// XP needed for the first level
global.xp_required = 20;

global.coins = 0;
global.room_enemy_kills = 0;
global.room_damage_taken = 0;

global.xp_attract_range = 64;
global.bullet_pierce = false;
global.recall_speed = 6;
global.player_bullet_speed = 10;

global.note_open = false;
global.note_text = "";
global.active_note = noone;

global.xp_attract_range += 32;
attract_range = global.xp_attract_range;

global.bullet_max_distance = 300;

global.DOOR_N = 1;
global.DOOR_E = 2;
global.DOOR_S = 4;
global.DOOR_W = 8;

// Procedural generation setup
global.grid_w = 4;
global.grid_h = 4;

// starting position in the grid
global.map_x = 1;
global.map_y = 1;

if (!variable_global_exists("entry_spawn_tag"))
{
    global.entry_spawn_tag = "";
}