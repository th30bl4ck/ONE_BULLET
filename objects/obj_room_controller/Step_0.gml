/// @description Monitor room clear state + reliable input/auto-advance

var _enemy_parent = asset_get_index("obj_enemy_parent");
if (_enemy_parent == -1)
{
    show_debug_message("[ROOM][ERROR] obj_enemy_parent does not exist. Cannot determine clear state reliably.");
    exit;
}

if (instance_number(_enemy_parent) <= 0)
{
    if (!room_cleared)
    {
        room_cleared = true;
        auto_advance_frames = max(1, room_speed);
        var _type = is_struct(room_data) && variable_struct_exists(room_data, "type") ? string(room_data.type) : "<none>";
        show_debug_message("[ROOM] Room cleared at index=" + string(global.current_room_index) + " type=" + _type + " (Press Enter or wait ~1s)");
    }

    if (keyboard_check_pressed(vk_enter))
    {
        attempt_advance_room("step_enter");
        exit;
    }

    auto_advance_frames -= 1;
    if (auto_advance_frames <= 0)
    {
        attempt_advance_room("auto_advance");
    }
}
