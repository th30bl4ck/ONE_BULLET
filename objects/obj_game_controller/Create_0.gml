
if (instance_number(obj_game_controller) > 1)
{
    instance_destroy();
    exit;
}

show_debug_message("CONTROLLER CREATE RUNNING");

// Seed GameMaker's RNG before procedural generation so each new run gets a fresh layout.
randomize();
show_debug_message("RNG SEED: " + string(random_get_seed()));

// ========================
// GLOBAL INIT 
// ========================
if (!variable_global_exists("entry_spawn_tag"))
{
    global.entry_spawn_tag = "";
}

if (!variable_global_exists("do_room_change"))
{
    global.do_room_change = false;
}

// Door constants
global.DOOR_N = 1;
global.DOOR_E = 2;
global.DOOR_S = 4;
global.DOOR_W = 8;

// Grid size
global.grid_w = 4;
global.grid_h = 4;

// Player starting position in grid
global.map_x = 1;
global.map_y = 1;

// ========================
// CREATE LAYOUT GRID 
// ========================
global.layout = array_create(global.grid_h);

for (var yy = 0; yy < global.grid_h; yy++)
{
    global.layout[yy] = array_create(global.grid_w);

    for (var xx = 0; xx < global.grid_w; xx++)
    {
        global.layout[yy][xx] = {
            used: false,
            visited: false,
            doors: 0,
            room_asset: -1
        };
    }
}

show_debug_message("LAYOUT CREATED");

// ========================
// GENERATE + ASSIGN
// ========================
scr_generate_layout(global.map_x, global.map_y, 15);
global.layout[global.map_y][global.map_x].visited = true;
show_debug_message("LAYOUT GENERATED");

scr_assign_room_assets();
show_debug_message("ROOMS ASSIGNED");

// any extra setup
scr_rooms_init();

// ========================
// DEBUG ROOM SPAWNER
// ========================
global.debug_room_spawn_open = false;
global.debug_room_spawn_index = 0;
global.debug_room_spawn_names = [];
global.debug_room_spawn_assets = [];

function debug_add_room(_name, _room)
{
    array_push(global.debug_room_spawn_names, _name);
    array_push(global.debug_room_spawn_assets, _room);
}

debug_add_room("starting_room", starting_room);
debug_add_room("second_room", second_room);
debug_add_room("room4", room4);
debug_add_room("settings_room", settings_room);
debug_add_room("main_menu", main_menu);
debug_add_room("rm_intro", rm_intro);

debug_add_room("rm_N_v1", rm_N_v1);
debug_add_room("rm_N_v2", rm_N_v2);
debug_add_room("rm_E_v1", rm_E_v1);
debug_add_room("rm_E_v2", rm_E_v2);
debug_add_room("rm_S_v1", rm_S_v1);
debug_add_room("rm_S_v2", rm_S_v2);
debug_add_room("rm_W_v1", rm_W_v1);
debug_add_room("rm_W_v2", rm_W_v2);

debug_add_room("rm_NS_v1", rm_NS_v1);
debug_add_room("rm_NS_v2", rm_NS_v2);
debug_add_room("rm_EW_v1", rm_EW_v1);
debug_add_room("rm_EW_v2", rm_EW_v2);
debug_add_room("rm_NE_v1", rm_NE_v1);
debug_add_room("rm_NE_v2", rm_NE_v2);
debug_add_room("rm_NW_v1", rm_NW_v1);
debug_add_room("rm_NW_v2", rm_NW_v2);
debug_add_room("rm_ES_v1", rm_ES_v1);
debug_add_room("rm_ES_v2", rm_ES_v2);
debug_add_room("rm_SW_v1", rm_SW_v1);
debug_add_room("rm_SW_v2", rm_SW_v2);

debug_add_room("rm_NES_v1", rm_NES_v1);
debug_add_room("rm_NES_v2", rm_NES_v2);
debug_add_room("rm_ESW_v1", rm_ESW_v1);
debug_add_room("rm_ESW_v2", rm_ESW_v2);
debug_add_room("rm_NSW_v1", rm_NSW_v1);
debug_add_room("rm_NSW_v2", rm_NSW_v2);
debug_add_room("rm_NEW_v1", rm_NEW_v1);
debug_add_room("rm_NEW_v2", rm_NEW_v2);

debug_add_room("rm_NESW_v1", rm_NESW_v1);
debug_add_room("rm_NESW_v2", rm_NESW_v2);

debug_add_room("rm_Chest", rm_Chest);
debug_add_room("rm_Medbay", rm_Medbay);
debug_add_room("rm_Boss_V2", rm_Boss_V2);

debug_add_room("rm_shop_N", rm_shop_N);
debug_add_room("rm_shop_E", rm_shop_E);
debug_add_room("rm_shop_S", rm_shop_S);
debug_add_room("rm_shop_W", rm_shop_W);

show_debug_message("CONTROLLER READY");
