/// RUN GENERATION

if (variable_global_exists("run_rooms") && ds_exists(global.run_rooms, ds_type_list))
{
    ds_list_destroy(global.run_rooms);
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

// Set start room
var start_room = global.run_rooms[| 0];
start_room.type = "start";
ds_list_set(global.run_rooms, 0, start_room);

// Set boss room
var boss_room_index = total_rooms - 1;
var boss_room = global.run_rooms[| boss_room_index];
boss_room.type = "boss";
ds_list_set(global.run_rooms, boss_room_index, boss_room);

// Add shop room
var shop_index = irandom_range(1, total_rooms - 2);
ds_list_set(global.run_rooms, shop_index, {
    type: "shop",
    difficulty: shop_index
});

// Add elite room (different from shop)
var elite_index = irandom_range(1, total_rooms - 2);
while (elite_index == shop_index)
{
    elite_index = irandom_range(1, total_rooms - 2);
}

var elite_room = global.run_rooms[| elite_index];
elite_room.type = "elite";
ds_list_set(global.run_rooms, elite_index, elite_room);

// Track current room
global.current_room_index = 0;