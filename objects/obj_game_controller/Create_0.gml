/// RUN GENERATION

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

// Set start and boss
global.run_rooms[| 0].type = "start";
global.run_rooms[| total_rooms - 1].type = "boss";

// Add shop
var shop_index = irandom_range(1, total_rooms - 2);
global.run_rooms[| shop_index].type = "shop";

// Add elite (not same as shop)
var elite_index = irandom_range(1, total_rooms - 2);

while (elite_index == shop_index)
{
    elite_index = irandom_range(1, total_rooms - 2);
}

global.run_rooms[| elite_index].type = "elite";

// Track current room
global.current_room_index = 0;