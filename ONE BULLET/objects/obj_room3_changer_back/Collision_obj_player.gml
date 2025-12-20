// Door is locked → do nothing
if (!unlocked) exit;


global.spawn_object = obj_spawnpoint_second_room_2; 
global.next_room = second_room;
room_goto(global.next_room);