// Door is locked → do nothing
if (!unlocked) exit;


global.spawn_object = spawnObject; 
global.next_room = second_room;
room_goto(global.next_room);