function scr_rooms_init()
{
    global.ROOMS = [];

    // Door constants
    global.DOOR_N = 1;
    global.DOOR_E = 2;
    global.DOOR_S = 4;
    global.DOOR_W = 8;

    // helper
    function add_room(_room, _doors)
    {
        array_push(global.ROOMS, {
            room  : _room,
            doors : _doors
        });
    }

    // -----------------
    // 1 door rooms
    // -----------------
    add_room(rm_N_v1, global.DOOR_N);
    add_room(rm_N_v2, global.DOOR_N);

    add_room(rm_E_v1, global.DOOR_E);
    add_room(rm_E_v2, global.DOOR_E);

    add_room(rm_S_v1, global.DOOR_S);
    add_room(rm_S_v2, global.DOOR_S);

    add_room(rm_W_v1, global.DOOR_W);
    add_room(rm_W_v2, global.DOOR_W);

    // -----------------
    // 2 door rooms
    // -----------------
    add_room(room_NS_v1, global.DOOR_N | global.DOOR_S);
    add_room(room_NS_v2, global.DOOR_N | global.DOOR_S);

    add_room(room_EW_v1, global.DOOR_E | global.DOOR_W);
    add_room(room_EW_v2, global.DOOR_E | global.DOOR_W);

    add_room(room_NE_v1, global.DOOR_N | global.DOOR_E);
    add_room(room_NE_v2, global.DOOR_N | global.DOOR_E);

    add_room(room_NW_v1, global.DOOR_N | global.DOOR_W);
    add_room(room_NW_v2, global.DOOR_N | global.DOOR_W);

    add_room(room_ES_v1, global.DOOR_E | global.DOOR_S);
    add_room(room_ES_v2, global.DOOR_E | global.DOOR_S);

    add_room(room_SW_v1, global.DOOR_S | global.DOOR_W);
    add_room(room_SW_v2, global.DOOR_S | global.DOOR_W);

    // -----------------
    // 3 door rooms
    // -----------------
    add_room(rm_3_NES_v1, global.DOOR_N | global.DOOR_E | global.DOOR_S);
    add_room(rm_3_NES_v2, global.DOOR_N | global.DOOR_E | global.DOOR_S);

    add_room(rm_3_ESW_v1, global.DOOR_E | global.DOOR_S | global.DOOR_W);
    add_room(rm_3_ESW_v2, global.DOOR_E | global.DOOR_S | global.DOOR_W);

    add_room(rm_3_NSW_v1, global.DOOR_N | global.DOOR_S | global.DOOR_W);
    add_room(rm_3_NSW_v2, global.DOOR_N | global.DOOR_S | global.DOOR_W);

    add_room(rm_3_NEW_v1, global.DOOR_N | global.DOOR_E | global.DOOR_W);
    add_room(rm_3_NEW_v2, global.DOOR_N | global.DOOR_E | global.DOOR_W);

    // -----------------
    // 4 door rooms
    // -----------------
    add_room(rm_4_all_v1, global.DOOR_N | global.DOOR_E | global.DOOR_S | global.DOOR_W);
    add_room(rm_4_all_v2, global.DOOR_N | global.DOOR_E | global.DOOR_S | global.DOOR_W);


}