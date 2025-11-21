// Collision Event with player
global.next_room = second_room;      // target room
global.spawn_object = obj_spawnPoint; // corresponding spawn point in that room
room_goto(global.next_room);
