/// RUN GENERATION

// Prevent duplicate persistent controllers (for example if placed in multiple rooms).
if (instance_number(obj_game_controller) > 1)
{
    show_debug_message("[RUN] Duplicate obj_game_controller detected. Destroying newer instance id=" + string(id));
    instance_destroy();
    exit;
}

// Clean up any previous run list before rebuilding
if (variable_global_exists("run_rooms") && ds_exists(global.run_rooms, ds_type_list))
{
    ds_list_destroy(global.run_rooms);
    show_debug_message("[RUN] Previous global.run_rooms destroyed before regeneration.");
}

global.run_rooms = ds_list_create();

var min_rooms = 8;
var max_rooms = 12;
var total_rooms = irandom_range(min_rooms, max_rooms);

for (var i = 0; i < total_rooms; i++)
{
    var room_data = {
        type: "combat",
        difficulty: i
    };
    ds_list_add(global.run_rooms, room_data);
}

// Force first and last rooms.
var start_room = global.run_rooms[| 0];
start_room.type = "start";
ds_list_set(global.run_rooms, 0, start_room);


var boss_room_index = total_rooms - 1;
var boss_room = global.run_rooms[| boss_room_index];
boss_room.type = "boss";
ds_list_set(global.run_rooms, boss_room_index, boss_room);

// Inject one shop and one elite somewhere in the middle.
if (total_rooms >= 4)
{
    var shop_index = irandom_range(1, total_rooms - 2);
    ds_list_set(global.run_rooms, shop_index, {
        type: "shop",
        difficulty: shop_index
    });

    var elite_index = irandom_range(1, total_rooms - 2);
    while (elite_index == shop_index)
    {
        elite_index = irandom_range(1, total_rooms - 2);
    }

    var elite_room = global.run_rooms[| elite_index];
    elite_room.type = "elite";
    ds_list_set(global.run_rooms, elite_index, elite_room);
}

// Start in room index 0.
global.current_room_index = 0;

show_debug_message("[RUN] Generated run with " + string(ds_list_size(global.run_rooms)) + " rooms.");
for (var r = 0; r < ds_list_size(global.run_rooms); r++)
{
    var rd = global.run_rooms[| r];
    show_debug_message("[RUN] room[" + string(r) + "] type=" + string(rd.type) + " difficulty=" + string(rd.difficulty));
}
show_debug_message("[RUN] current_room_index initialized to " + string(global.current_room_index));