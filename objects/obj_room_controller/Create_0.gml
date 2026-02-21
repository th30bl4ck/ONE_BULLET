/// @description Resolve current room data and spawn content

room_cleared = false;
room_data = undefined;
auto_advance_frames = max(1, room_speed); // 1 second fallback if Enter is missed

function _log_current_room_state(_prefix)
{
    var _idx = variable_global_exists("current_room_index") ? global.current_room_index : -999;
    var _size = (variable_global_exists("run_rooms") && ds_exists(global.run_rooms, ds_type_list)) ? ds_list_size(global.run_rooms) : -1;
    var _type = is_struct(room_data) && variable_struct_exists(room_data, "type") ? string(room_data.type) : "<none>";
    show_debug_message("[ROOM] " + _prefix + " index=" + string(_idx) + " run_size=" + string(_size) + " type=" + _type);
}

function _build_fallback_run_if_missing()
{
    if (variable_global_exists("run_rooms") && ds_exists(global.run_rooms, ds_type_list))
    {
        return;
    }

    show_debug_message("[ROOM][WARN] run state missing in room controller; building fallback run list.");

    global.run_rooms = ds_list_create();
    ds_list_add(global.run_rooms, { type: "start", difficulty: 0 });
    ds_list_add(global.run_rooms, { type: "combat", difficulty: 1 });
    ds_list_add(global.run_rooms, { type: "boss", difficulty: 2 });

    if (!variable_global_exists("current_room_index"))
    {
        global.current_room_index = 0;
    }

    show_debug_message("[ROOM][WARN] Fallback run created with 3 rooms (start/combat/boss).");
}

function _spawn_placeholder_enemy(_count)
{
    var _fallback_obj = asset_get_index("obj_enemy_walker");
    if (_fallback_obj == -1) _fallback_obj = asset_get_index("obj_enemy_dasher");
    if (_fallback_obj == -1) _fallback_obj = asset_get_index("obj_enemy_shooter");

    if (_fallback_obj == -1)
    {
        show_debug_message("[ROOM][ERROR] No placeholder enemy object found (obj_enemy_walker/dasher/shooter missing).");
        return;
    }

    for (var i = 0; i < _count; i++)
    {
        instance_create_layer(irandom_range(100, room_width - 100), irandom_range(100, room_height - 100), "Instances", _fallback_obj);
    }

    show_debug_message("[ROOM] Spawned placeholder enemies count=" + string(_count));
}

attempt_advance_room = function(_reason)
{
    if (!room_cleared)
    {
        show_debug_message("[ROOM] Advance ignored (not cleared). reason=" + _reason);
        return;
    }

    if (!variable_global_exists("run_rooms") || !ds_exists(global.run_rooms, ds_type_list))
    {
        show_debug_message("[ROOM][ERROR] Advance failed: global.run_rooms missing/invalid. reason=" + _reason);
        return;
    }

    if (!variable_global_exists("current_room_index"))
    {
        global.current_room_index = 0;
        show_debug_message("[ROOM][WARN] current_room_index missing during transition. Reset to 0.");
    }

    global.current_room_index += 1;
    var _size = ds_list_size(global.run_rooms);

    show_debug_message("[ROOM] Advancing room (" + _reason + ") to index=" + string(global.current_room_index) + " of " + string(_size));

    if (global.current_room_index < _size)
    {
        room_restart();
    }
    else
    {
        show_debug_message("[ROOM] Run complete. No more rooms.");
    }
}

function spawn_room_content()
{
    if (!is_struct(room_data) || !variable_struct_exists(room_data, "type"))
    {
        show_debug_message("[ROOM][ERROR] room_data missing/invalid. Cannot spawn content.");
        return;
    }

    var _room_type = string(room_data.type);
    _log_current_room_state("Spawning room content");

    switch (_room_type)
    {
        case "start":
            show_debug_message("[ROOM] Start room (no forced spawns).");
        break;

        case "combat":
            if (script_exists(spawn_wave))
            {
                spawn_wave(room_data.difficulty);
            }
            else
            {
                show_debug_message("[ROOM][WARN] spawn_wave missing. Using placeholder.");
                _spawn_placeholder_enemy(max(1, 3 + room_data.difficulty));
            }
        break;

        case "elite":
            if (script_exists(spawn_elite_wave))
            {
                spawn_elite_wave(room_data.difficulty);
            }
            else
            {
                show_debug_message("[ROOM][WARN] spawn_elite_wave missing. Using placeholder.");
                _spawn_placeholder_enemy(max(1, 2 + room_data.difficulty));
            }
        break;

        case "shop":
            if (script_exists(spawn_shop))
            {
                spawn_shop();
            }
            else
            {
                show_debug_message("[ROOM][WARN] spawn_shop missing. Attempting direct obj_shopkeeper spawn.");
                var _shop_obj = asset_get_index("obj_shopkeeper");
                if (_shop_obj != -1)
                {
                    instance_create_layer(room_width * 0.5, room_height * 0.5, "Instances", _shop_obj);
                }
            }
        break;

        case "boss":
            if (script_exists(spawn_boss))
            {
                spawn_boss();
            }
            else
            {
                show_debug_message("[ROOM][WARN] spawn_boss missing. Using placeholder enemies.");
                _spawn_placeholder_enemy(8);
            }
        break;

        default:
            show_debug_message("[ROOM][WARN] Unknown room type '" + _room_type + "'. Falling back to combat placeholder.");
            _spawn_placeholder_enemy(3);
        break;
    }
}

// Defensive guards around global state.
_build_fallback_run_if_missing();

if (!is_callable(attempt_advance_room))
{
    show_debug_message("[ROOM][ERROR] attempt_advance_room helper missing.");
}

if (!variable_global_exists("run_rooms") || !ds_exists(global.run_rooms, ds_type_list))
{
    show_debug_message("[ROOM][ERROR] global.run_rooms missing or invalid after fallback attempt. Destroying obj_room_controller.");
    instance_destroy();
    exit;
}

if (!variable_global_exists("current_room_index"))
{
    global.current_room_index = 0;
    show_debug_message("[ROOM][WARN] global.current_room_index missing. Reset to 0.");
}

var _count = ds_list_size(global.run_rooms);
if (_count <= 0)
{
    show_debug_message("[ROOM][ERROR] global.run_rooms exists but is empty. Destroying obj_room_controller.");
    instance_destroy();
    exit;
}

global.current_room_index = clamp(global.current_room_index, 0, _count - 1);
room_data = global.run_rooms[| global.current_room_index];

spawn_room_content();
