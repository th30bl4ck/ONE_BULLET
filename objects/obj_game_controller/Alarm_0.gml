// Runs one step after room_goto so spawn markers exist in the *new* room.
if (!variable_global_exists("entry_spawn_tag")) exit;
if (global.entry_spawn_tag == "") exit;

var res = scr_get_entry_spawn_coords();

if (instance_exists(obj_player))
{
    with (obj_player)
    {
        x = res.x;
        y = res.y;
    }
}
else
{
    instance_create_depth(res.x, res.y, 0, obj_player);
}

if (res.found)
{
    show_debug_message("ENTRY SPAWN (alarm): " + string(res.x) + "," + string(res.y));
}
else
{
    show_debug_message("ENTRY SPAWN (alarm): no marker — room center fallback");
}

global.entry_spawn_tag = "";
