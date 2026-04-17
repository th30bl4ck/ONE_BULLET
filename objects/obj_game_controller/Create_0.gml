
if (instance_number(obj_game_controller) > 1)
{
    instance_destroy();
    exit;
}

show_debug_message("CONTROLLER CREATE RUNNING");

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
            doors: 0,
            room_asset: -1
        };
    }
}

show_debug_message("LAYOUT CREATED");

// ========================
// GENERATE + ASSIGN
// ========================
scr_generate_layout(global.map_x, global.map_y, 10);
show_debug_message("LAYOUT GENERATED");

scr_assign_room_assets();
show_debug_message("ROOMS ASSIGNED");

// any extra setup
scr_rooms_init();

show_debug_message("CONTROLLER READY");