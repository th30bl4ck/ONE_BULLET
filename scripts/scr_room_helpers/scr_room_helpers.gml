function scr_opposite_door(_door)
{
    switch (_door)
    {
        case global.DOOR_N: return global.DOOR_S;
        case global.DOOR_E: return global.DOOR_W;
        case global.DOOR_S: return global.DOOR_N;
        case global.DOOR_W: return global.DOOR_E;
    }

    return 0;
}

function scr_has_door(_mask, _door)
{
    return (_mask & _door) != 0;
}

function scr_pick_room_by_doors(_doors)
{
    var matches = [];

    for (var i = 0; i < array_length(global.ROOMS); i++)
    {
        if (global.ROOMS[i].doors == _doors)
        {
            array_push(matches, global.ROOMS[i].room);
        }
    }

    if (array_length(matches) <= 0) return -1;

    return matches[irandom(array_length(matches) - 1)];
}

/// When several markers share the same tag, pick the one on the matching edge of the room.
function scr_pick_edge_candidate_index(_tag, _xs, _ys)
{
    var n = array_length(_xs);
    if (n <= 0) return 0;
    if (n == 1) return 0;

    var best = 0;
    for (var k = 1; k < n; k++)
    {
        if (_tag == "west"  && _xs[k] < _xs[best]) best = k;
        if (_tag == "east"  && _xs[k] > _xs[best]) best = k;
        if (_tag == "north" && _ys[k] < _ys[best]) best = k;
        if (_tag == "south" && _ys[k] > _ys[best]) best = k;
    }

    return best;
}

/// Resolve player position for `global.entry_spawn_tag` ("north"|"east"|"south"|"west") in the *current* room.
function scr_get_entry_spawn_coords()
{
    var cx = room_width * 0.5;
    var cy = room_height * 0.5;
    var out = { x: cx, y: cy, found: false };

    if (!variable_global_exists("entry_spawn_tag")) return out;

    var tag = global.entry_spawn_tag;
    if (tag == "") return out;

    var cand_x = [];
    var cand_y = [];

    var i;
    for (i = 0; i < instance_number(obj_room_spawn); i++)
    {
        var rms = instance_find(obj_room_spawn, i);
        if (rms.spawn_id == tag)
        {
            array_push(cand_x, rms.x);
            array_push(cand_y, rms.y);
        }
    }

    if (array_length(cand_x) > 0)
    {
        var pick = scr_pick_edge_candidate_index(tag, cand_x, cand_y);
        out.x = cand_x[pick];
        out.y = cand_y[pick];
        out.found = true;
        return out;
    }

    var spawn_obj = noone;
    switch (tag)
    {
        case "north": spawn_obj = obj_spawn_north; break;
        case "east":  spawn_obj = obj_spawn_east;  break;
        case "south": spawn_obj = obj_spawn_south; break;
        case "west":  spawn_obj = obj_spawn_west;  break;
        default: return out;
    }

    cand_x = [];
    cand_y = [];

    for (i = 0; i < instance_number(spawn_obj); i++)
    {
        var sp = instance_find(spawn_obj, i);
        array_push(cand_x, sp.x);
        array_push(cand_y, sp.y);
    }

    if (array_length(cand_x) <= 0) return out;

    var pick2 = scr_pick_edge_candidate_index(tag, cand_x, cand_y);
    out.x = cand_x[pick2];
    out.y = cand_y[pick2];
    out.found = true;
    return out;
}

/// True if this layer name should be used for wall collision (never floor / background).
function scr_layer_name_is_wall_tilemap(_layer_name)
{
    var n = string_lower(_layer_name);
    if (n == "") return false;
    if (n == "tileset_floor") return false;
    if (n == "tiles_floor") return false;
    if (string_pos("floor", n) > 0) return false;
    if (string_pos("ceiling", n) > 0) return false;
    if (string_pos("background", n) > 0) return false;
    if (string_pos("parallax", n) > 0) return false;
    if (string_pos("wallpaper", n) > 0) return false;

    if (n == "tileset_wall") return true;
    if (n == "walls") return true;
    if (n == "wall_tiles") return true;
    if (n == "tiles_walls") return true;

    return false;
}

function scr_try_bind_wall_tilemap(_layer_id)
{
    if (_layer_id == -1) return false;

    var lname = string_lower(layer_get_name(_layer_id));
    if (!scr_layer_name_is_wall_tilemap(lname)) return false;

    var tid = layer_tilemap_get_id(_layer_id);
    if (tid == -1) return false;

    global.wall_tilemap_id = tid;
    return true;
}

/// Cache the wall tilemap for the current room (layer name differs per room in this project).
function scr_refresh_wall_tilemap()
{
    if (!variable_global_exists("wall_tilemap_id"))
    {
        global.wall_tilemap_id = noone;
        global.wall_tilemap_room = noone;
    }

    if (global.wall_tilemap_room == room)
        return;

    global.wall_tilemap_room = room;
    global.wall_tilemap_id = noone;

    // Exact names first (do not use bare "Wall" — it can match the wrong layer / group).
    var names = ["tileset_wall", "Walls", "walls", "Wall_Tiles", "tiles_walls"];
    var i;
    for (i = 0; i < array_length(names); i++)
    {
        var lid = layer_get_id(names[i]);
        if (scr_try_bind_wall_tilemap(lid))
            return;
    }

    // Fallback: scan room layers and pick the first valid *wall-named* tilemap.
    var arr = layer_get_all();
    if (!is_array(arr)) return;

    for (i = 0; i < array_length(arr); i++)
    {
        var lidf = arr[i];
        if (is_string(lidf))
            lidf = layer_get_id(lidf);
        if (scr_try_bind_wall_tilemap(lidf))
            return;
    }
}

/// Packed tilemap cell is solid (not empty / not erased).
function scr_tilemap_cell_is_solid(_tm, _px, _py)
{
    var c = tilemap_get_at_pixel(_tm, _px, _py);
    if (c == 0) return false;
    if (tile_get_empty(c)) return false;
    return true;
}

/// World-space AABB vs wall tiles and obj_wall instances.
function scr_wall_overlaps_rect(_l, _t, _r, _b)
{
    if (variable_global_exists("wall_tilemap_id"))
    {
        var tm = global.wall_tilemap_id;
        if (tm != noone && tm != -1)
        {
            if (scr_tilemap_cell_is_solid(tm, _l, _t)
             || scr_tilemap_cell_is_solid(tm, _r, _t)
             || scr_tilemap_cell_is_solid(tm, _l, _b)
             || scr_tilemap_cell_is_solid(tm, _r, _b))
            {
                return true;
            }
        }
    }

    if (instance_exists(obj_wall))
    {
        if (collision_rectangle(_l, _t, _r, _b, obj_wall, false, true))
            return true;
    }

    return false;
}
