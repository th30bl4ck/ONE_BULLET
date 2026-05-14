if (!game_pause) exit;

// ===============================
// TOP-LEFT: COINS
// ===============================
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

draw_text(16, 16, "Coins: " + string(global.coins));


// ===============================
// TOP: PAUSED TEXT
// ===============================
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(gui_w * 0.5, 42, "Game Paused");


// ===============================
// CENTER: VISITED MAP
// ===============================
if (variable_global_exists("layout") && is_array(global.layout))
{
    var rows = array_length(global.layout);
    if (rows > 0)
    {
        var cols = array_length(global.layout[0]);
        var cell = 42;
        var gap = 8;
        var map_w = cols * cell + (cols - 1) * gap;
        var map_h = rows * cell + (rows - 1) * gap;
        var map_x = gui_w * 0.5 - map_w * 0.5;
        var map_y = gui_h * 0.5 - map_h * 0.5;

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(gui_w * 0.5, map_y - 28, "Map");

        for (var yy = 0; yy < rows; yy++)
        {
            for (var xx = 0; xx < cols; xx++)
            {
                var room_cell = global.layout[yy][xx];
                if (!is_struct(room_cell)) continue;

                var seen = variable_struct_exists(room_cell, "visited") && room_cell.visited;
                if (!seen) continue;

                var x1 = map_x + xx * (cell + gap);
                var y1 = map_y + yy * (cell + gap);
                var x2 = x1 + cell;
                var y2 = y1 + cell;
                var cx = x1 + cell * 0.5;
                var cy = y1 + cell * 0.5;

                var current = (xx == global.map_x && yy == global.map_y);
                var fill_col = current ? make_color_rgb(235, 190, 80) : make_color_rgb(70, 95, 95);
                var edge_col = current ? c_white : make_color_rgb(150, 180, 175);

                draw_set_alpha(0.86);
                draw_set_color(fill_col);
                draw_rectangle(x1, y1, x2, y2, false);

                draw_set_alpha(1);
                draw_set_color(edge_col);
                draw_rectangle(x1, y1, x2, y2, true);

                draw_set_color(make_color_rgb(180, 205, 195));
                draw_set_alpha(0.75);

                if ((room_cell.doors & global.DOOR_N) != 0 && yy > 0)
                {
                    var north = global.layout[yy - 1][xx];
                    if (is_struct(north) && variable_struct_exists(north, "visited") && north.visited)
                        draw_line_width(cx, y1, cx, y1 - gap, 4);
                }

                if ((room_cell.doors & global.DOOR_E) != 0 && xx < cols - 1)
                {
                    var east = global.layout[yy][xx + 1];
                    if (is_struct(east) && variable_struct_exists(east, "visited") && east.visited)
                        draw_line_width(x2, cy, x2 + gap, cy, 4);
                }

                if ((room_cell.doors & global.DOOR_S) != 0 && yy < rows - 1)
                {
                    var south = global.layout[yy + 1][xx];
                    if (is_struct(south) && variable_struct_exists(south, "visited") && south.visited)
                        draw_line_width(cx, y2, cx, y2 + gap, 4);
                }

                if ((room_cell.doors & global.DOOR_W) != 0 && xx > 0)
                {
                    var west = global.layout[yy][xx - 1];
                    if (is_struct(west) && variable_struct_exists(west, "visited") && west.visited)
                        draw_line_width(x1, cy, x1 - gap, cy, 4);
                }

                draw_set_alpha(1);
            }
        }
    }
}


// ===============================
// BOTTOM-LEFT: UPGRADES LIST 
// ===============================
if (variable_global_exists("upgrade_counts") && global.upgrade_counts != noone)
{
    // These MUST match your ds_map keys exactly:
    var upgrades = [
        "Rollershoes",
        "Medkit",
        "Stim",
        "Sticky Finger",
        "Big Boy Boots",
        "Magnet Core",
        "Trigger Finger",
        "Long Barrel"
    ];

    var base_x = 50;
    var bottom_y = display_get_gui_height() - 32;

    var pad = 4;          // padding inside each row
    var icon_gap = 8;     // space between icon and text
    var icon_size_fallback = 16;

   
    var cursor_y = bottom_y;

    draw_set_halign(fa_left);
    draw_set_color(c_white);

    // ----- Header -----
    var header = "Upgrades:";
    var header_h = string_height(header);

    var header_top = cursor_y - header_h;
    draw_set_valign(fa_top);
    draw_text(base_x, header_top, header);

    cursor_y = header_top - pad;

    // ----- Entries -----
    for (var i = 0; i < array_length(upgrades); i++)
    {
        var upgrade_name = upgrades[i];

        if (!ds_map_exists(global.upgrade_counts, upgrade_name))
            continue;

        var count = global.upgrade_counts[? upgrade_name];
        if (count <= 0)
            continue;

        var label = upgrade_name;
        if (count > 1) label += " x" + string(count);

        // text height
        var text_h = string_height(label);

        // icon sprite (if exists)
        var icon = noone;
        var icon_h = icon_size_fallback;

        if (variable_global_exists("upgrade_icons") && global.upgrade_icons != noone)
        {
            if (ds_map_exists(global.upgrade_icons, upgrade_name))
            {
                icon = global.upgrade_icons[? upgrade_name];
                if (icon != noone && !is_undefined(icon))
                {
                    icon_h = sprite_get_height(icon);
                }
            }
        }

        // row height
        var row_h = max(text_h, icon_h) + pad;

        // row top
        var row_top = cursor_y - row_h;

        // center icon + text in row
        var icon_y = row_top + (row_h - icon_h) * 0.5;
        var text_y = row_top + (row_h - text_h) * 0.5;

        var icon_x = base_x;
        var text_x = base_x + icon_size_fallback + icon_gap;

        // draw icon
        if (icon != noone)
        {
            draw_sprite(icon, 0, icon_x, icon_y);
        }

        // draw text
        draw_set_valign(fa_top);
        draw_text(text_x, text_y, label);

        // move up
        cursor_y = row_top;
    }
}


draw_set_alpha(1);
draw_set_color(c_white);
